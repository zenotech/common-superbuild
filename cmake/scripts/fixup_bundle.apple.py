#!/usr/bin/env python2.7

import json
import os
import os.path
import re
import shutil
import subprocess


class Pipeline(object):
    def __init__(self, *commands):
        if not commands:
            raise RuntimeError('Pipeline: at least one command must be given')

        self._commands = commands

    def __call__(self):
        last_input = open('/dev/null', 'r')

        for command_args in self._commands:
            command = subprocess.Popen(command_args, stdin=last_input, stdout=subprocess.PIPE)
            last_input.close()
            last_input = command.stdout

        stdout, _ = command.communicate()
        return stdout


class Library(object):
    def __init__(self, path, parent=None, search_paths=None):
        # This is the actual path to a physical file
        self._path = path

        if search_paths is None:
            self._search_paths = []
        else:
            self._search_paths = search_paths

        self._parent = parent
        self._symlinks = None
        self._framework_info = None
        self._executable_path = None
        self._dependencies = None
        self._rpaths = None
        self._installed_id = None

    def __hash__(self):
        return self._path.__hash__()

    def __eq__(self, other):
        return self._path == other._path

    def __repr__(self):
        return 'Library(%s : %s)' % (self.id, self.path)

    @property
    def path(self):
        return self._path

    @property
    def parent(self):
        return self._parent

    @property
    def name(self):
        return os.path.basename(self.path)

    @property
    def installed_id(self):
        return self._installed_id

    def set_installed_id(self, installed_id):
        self._installed_id = installed_id

    @property
    def symlinks(self):
        if self._symlinks is None:
            realpath = os.path.realpath(self.path)
            dirname = os.path.dirname(realpath)
            symlinks = Pipeline([
                    'find',
                    '-L',
                    dirname,
                    '-depth', '1',
                    '-samefile', realpath,
                ])

            symlinks = set(symlinks().split())

            symlink_bases = []
            for symlink in symlinks:
                symlink_dir, symlink_base = os.path.split(symlink)
                if not symlink_dir == dirname:
                    continue
                symlink_bases.append(symlink_base)
            symlink_bases.remove(self.name)
            self._symlinks = symlink_bases

        return self._symlinks

    @property
    def executable_path(self):
        if self._parent is not None:
            return self._parent.executable_path
        return self._executable_path

    @property
    def loader_path(self):
        return os.path.dirname(self.path)

    @property
    def is_framework(self):
        return self.path.count('.framework')

    @property
    def framework_info(self):
        if self._framework_info is None:
            if not self.is_framework:
                self._framework_info = (None, None, None)
            else:
                name = None
                library = []

                path = self.path
                while path:
                    path, component = os.path.split(path)
                    if component.endswith('.framework'):
                        name = component
                        break
                    library.append(component)

                if name is None:
                    raise RuntimeError('%s is not a framework?' % self.path)

                self._framework_info = (
                        os.path.join(path),
                        name,
                        os.path.join(*reversed(library)),
                    )
        return self._framework_info

    @property
    def framework_path(self):
        return self.framework_info[0]

    @property
    def framework_name(self):
        return self.framework_info[1]

    @property
    def framework_library(self):
        return self.framework_info[2]

    @property
    def rpaths(self):
        if self._rpaths is None:
            rpaths = []
            if self._parent is not None:
                rpaths.extend(self._parent.rpaths)
            get_rpaths = Pipeline([
                    'otool',
                    '-l',
                    self.path,
                ], [
                    'awk',
                    '''
                    $1 == "cmd" {
                        cmd = $2
                    }

                    $1 == "path" {
                        if (cmd == "LC_RPATH") {
                            print $2
                        }
                    }
                    ''',
                ])
            rpaths.extend(get_rpaths().split('\n'))

            resolved_rpaths = []
            for rpath in rpaths:
                if rpath.startswith('@executable_path'):
                    # If the loader does not have an executable path, it is a plugin or
                    # a framework and we trust the executable which loads the plugin to
                    # provide this library instead.
                    if self.executable_path is None:
                        continue
                    resolved_rpaths.append(ref.replace('@executable_path', self.executable_path))
                elif rpath.startswith('@loader_path'):
                    resolved_rpaths.append(ref.replace('@loader_path', self.loader_path))

            self._rpaths = resolved_rpaths
        return self._rpaths

    def _get_dependencies(self):
        pipe = Pipeline([
                'otool',
                '-L',
                self.path,
            ], [
                'sed',
                '-n',
                '-e', '/compatibility version/s/ (compatibility.*)//p',
            ])
        return pipe().split()

    @property
    def dependencies(self):
        if self._dependencies is None:
            collection = {}
            for dep in self._get_dependencies():
                deplib = Library.create_from_reference(dep, self)
                if deplib is not None:
                    collection[dep] = deplib
            self._dependencies = collection
        return self._dependencies

    def _find_library(self, ref):
        print 'WARNING: dependency from %s to %s requires a search path' % (self.path, ref)
        for loc in self._search_paths:
            find = Pipeline([
                    'find',
                    loc,
                    '-name', ref,
                ])
            output = find()
            if output:
                return output.split('\n')[0]
        return ref

    @classmethod
    def create_from_reference(cls, ref, loader):
        paths = [ref]
        if ref.startswith('@executable_path'):
            # If the loader does not have an executable path, it is a plugin or
            # a framework and we trust the executable which loads the plugin to
            # provide this library instead.
            if loader.executable_path is None:
                return None
            paths.append(ref.replace('@executable_path', loader.executable_path))
        elif ref.startswith('@loader_path'):
            paths.append(ref.replace('@loader_path', loader.loader_path))
        elif ref.startswith('@rpath'):
            for rpath in loader.rpaths:
                paths.append(ref.replace('@rpath', rpath))
        paths.append(os.path.join(os.path.dirname(loader.path), ref))
        for path in paths:
            if os.path.exists(path):
                return cls.create_from_path(path, parent=loader)
        search_path = loader._find_library(ref)
        if os.path.exists(search_path):
            return cls.create_from_path(search_path, parent=loader)
        raise RuntimeError('Unable to find the %s library from %s' % (ref, loader.path))

    __cache = {}

    @classmethod
    def create_from_path(cls, path, parent=None):
        if not os.path.exists(path):
            raise RuntimeError('%s does not exist' % path)

        if path not in cls.__cache:
            search_paths = None
            if parent is not None:
                search_paths = parent._search_paths

            cls.__cache[path] = Library(path, parent=parent,
                                        search_paths=search_paths)

        return cls.__cache[path]

    @classmethod
    def create_from_manifest(cls, path, installed_id):
        if path in cls.__cache:
            raise RuntimeError('There is already a library for %s' % path)

        library = Library(path)
        library.set_installed_id(installed_id)

        cls.__cache[path] = library
        return cls.__cache[path]


class Executable(Library):
    def __init__(self, path, **kwargs):
        super(Executable, self).__init__(path, None, **kwargs)

        self._executable_path = os.path.dirname(path)

    @property
    def bundle_location(self):
        return 'Contents/MacOS'

    @property
    def dependent_reference(self):
        return '@executable_path'


class Plugin(Library):
    def __init__(self, path, **kwargs):
        super(Plugin, self).__init__(path, None, **kwargs)

    @property
    def bundle_location(self):
        return 'Contents/Plugins'

    @property
    def dependent_reference(self):
        return '@loader_path'


class Framework(Library):
    def __init__(self, path, **kwargs):
        super(Framework, self).__init__(path, None, **kwargs)

        raise RuntimeError('Framework support is unimplemented.')

    @property
    def bundle_location(self):
        return 'Contents/Frameworks'

    @property
    def dependent_reference(self):
        return '@loader_path'


def copy_library(destination, library, dry_run=False):
    if library.is_framework:
        print 'Copying %s/%s ==> Contents/Frameworks' % (library.framework_path, library.framework_name)

        app_dest = os.path.join(destination, 'Contents', 'Frameworks')
        binary = os.path.join(app_dest, library.framework_name, library.framework_library)
        library.set_installed_id(os.path.join('@executable_path', '..', 'Frameworks', library.framework_name, library.framework_library))
        destination = os.path.join(app_dest, library.framework_name)

        if not dry_run:
            # FIXME: this could be optimized to only copy the particular version.
            if os.path.exists(destination):
                shutil.rmtree(destination)
            _os_makedirs(app_dest)
            shutil.copytree(os.path.join(library.framework_path, library.framework_name), destination, symlinks=True)
    else:
        print 'Copying %s ==> Contents/Libraries' % library.path

        app_dest = os.path.join(destination, 'Contents', 'Libraries')
        binary = os.path.join(app_dest, library.name)
        library.set_installed_id(os.path.join('@executable_path', '..', 'Libraries', library.name))
        destination = app_dest

        if not dry_run:
            _os_makedirs(app_dest)
            shutil.copy(library.path, destination)

        for symlink in library.symlinks:
            print 'Creating symlink to Contents/Libraries/%s ==> %s' % (library.name, symlink)
            if not dry_run:
                symlink_path = os.path.join(app_dest, symlink)
                if os.path.exists(symlink_path):
                    os.remove(symlink_path)
                ln = Pipeline([
                        'ln',
                        '-s',
                        library.name,
                        symlink_path,
                    ])
                ln()

    if not dry_run:
        install_name_tool = Pipeline([
                'install_name_tool',
                '-id', library.installed_id,
                binary,
            ])
        install_name_tool()

    return binary


# A function to fix up the fact that os.makedirs chokes if the path already
# exists.
def _os_makedirs(path):
    if os.path.exists(path):
        return
    os.makedirs(path)


def _create_arg_parser():
    import argparse

    parser = argparse.ArgumentParser(description='Install an OS X binary into a bundle')
    parser.add_argument('-b', '--bundle', metavar='BUNDLE', type=str, required=True,
                        help='the name of the application (including .app extension)')
    parser.add_argument('-d', '--destination', metavar='DEST', type=str, required=True,
                        help='the directory to create the bundle underneath')
    parser.add_argument('-i', '--include', metavar='REGEX', action='append',
                        default=[],
                        help='regular expression to include in the bundle (before exclusions)')
    parser.add_argument('-e', '--exclude', metavar='REGEX', action='append',
                        default=[],
                        help='regular expression to exclude from the bundle')
    parser.add_argument('-p', '--plugin', metavar='PATH', action='append',
                        default=[], dest='plugins',
                        help='list of plugins to install with an executable')
    parser.add_argument('-s', '--search', metavar='PATH', action='append',
                        default=[],
                        help='add a directory to search for dependent libraries')
    parser.add_argument('-n', '--dry-run', action='store_true',
                        help='do not actually copy files')
    parser.add_argument('-c', '--clean', action='store_true',
                        help='clear out the bundle destination before starting')
    parser.add_argument('-m', '--manifest', metavar='PATH', type=str, required=True,
                        help='manifest for the application bundle')
    parser.add_argument('-t', '--type', metavar='TYPE', type=str,
                        choices=('executable', 'plugin'),
                        help='the type of binary to package')
    parser.add_argument('binary', metavar='BINARY', type=str,
                        help='the binary to package')

    return parser


def _install_binary(binary, is_excluded, bundle_dest, installed, manifest, dry_run=False):
    # Start looking at our main executable's dependencies.
    deps = binary.dependencies.values()
    while deps:
        dep = deps.pop(0)

        # Ignore dependencies which the bundle already provides.
        if dep.path in manifest:
            continue

        # Ignore dependencies we don't care about.
        if is_excluded(dep.path):
            continue

        # If we've already installed this dependency for some other library,
        # skip it.
        if dep.path in installed:
            continue

        # Add this dependency's dependencies to the pile.
        deps.extend(dep.dependencies.values())
        # Remember what we installed and where.
        installed[dep.path] = (dep, copy_library(bundle_dest, dep, dry_run=dry_run))

    # Install the main executable itself.
    app_dest = os.path.join(bundle_dest, binary.bundle_location)
    binary_destination = os.path.join(app_dest, os.path.basename(binary.path))
    installed[binary.path] = (binary, binary_destination)
    binary.set_installed_id(binary_destination)
    print 'Copying %s ==> %s' % (binary.path, binary.bundle_location)
    if not dry_run:
        _os_makedirs(app_dest)
        shutil.copy(binary.path, app_dest)


def _fix_installed_binaries(installed, dry_run=False):
    # Go through all of the binaries installed and fix up references to other things.
    for binary_info in installed.values():
        binary, installed_path = binary_info
        print 'Fixing binary references in %s' % binary.path

        changes = []
        for old_name, library in binary.dependencies.items():
            if library.installed_id is not None and \
               not old_name == library.installed_id:
                changes.extend(['-change', old_name, library.installed_id])

        # Fix up the library names.
        if not dry_run and changes:
            install_name_tool = Pipeline([
                    'install_name_tool',
                ] + changes + [
                    installed_path,
                ])
            install_name_tool()


def _update_manifest(manifest, installed, path):
    for input_path, binary_info in installed.items():
        binary, _ = binary_info
        manifest[input_path] = binary.installed_id

    with open(path, 'w+') as fout:
        json.dump(manifest, fout)


def main(args):
    parser = _create_arg_parser()
    opts = parser.parse_args(args)

    if opts.type == 'executable':
        main_exe = Executable(opts.binary, search_paths=opts.search)
    elif opts.type == 'plugin':
        main_exe = Plugin(opts.binary, search_paths=opts.search)
    elif opts.type == 'framework':
        main_exe = Framework(opts.binary, search_paths=opts.search)

    bundle_dest = os.path.join(opts.destination, opts.bundle)

    # Remove the old bundle.
    if not opts.dry_run and opts.clean and os.path.exists(bundle_dest):
        shutil.rmtree(bundle_dest)

    includes = map(re.compile, opts.include)
    excludes = map(re.compile, opts.exclude)

    def is_excluded(path):
        for include in includes:
            if include.match(path):
                return False
        for exclude in excludes:
            if exclude.match(path):
                return True
        # Apple
        if path.startswith('/System/Library'):
            return True
        if path.startswith('/usr/lib'):
            return True
        # Homebrew
        if path.startswith('/usr/local/lib'):
            return False
        # Macports
        if path.startswith('/opt/local/lib'):
            return False
        return False

    if opts.clean:
        # A new bundle does not have a manifest.
        manifest = {}
    else:
        with open(opts.manifest, 'r') as fin:
            manifest = json.load(fin)

        # Seed the cache with manifest entries.
        for path, installed_id in manifest.items():
            Library.create_from_manifest(path, installed_id)

    installed = {}
    _install_binary(main_exe, is_excluded, bundle_dest, installed, manifest, dry_run=opts.dry_run)

    for plugin in opts.plugins:
        plugin_bin = Plugin(plugin, search_paths=opts.search)
        _install_binary(plugin_bin, is_excluded, bundle_dest, installed, manifest, dry_run=opts.dry_run)

    _fix_installed_binaries(installed, dry_run=opts.dry_run)

    if not opts.dry_run:
        _update_manifest(manifest, installed, opts.manifest)


if __name__ == '__main__':
    import sys
    main(sys.argv[1:])
