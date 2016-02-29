#!/usr/bin/env python

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


# XXX(fixme): use a metaclass to keep memoize path -> Library instance?
#class LibraryMeta(type):
#    def __init__(self, name, bases, dict):
#        super(LibraryMeta, self).__init__(name, bases, dict)


class Library(object):
    def __init__(self, path, id, parent=None, symlinks=None):
        # This is the actual path to a physical file
        self._real_path = path

        # This is the id for shared library.
        self._id = id

        self._parent = parent

        # These are names for symbolic links to this file.
        if symlinks is None:
            self._symlinks = []
        else:
            self._symlinks = symlinks

        self._framework_info = None
        self._executable_path = None
        self._dependencies = None
        self._rpaths = None

    def __hash__(self):
        return self.path.__hash__()

    def __eq__(self, other):
        return self.path == other.path

    def __repr__(self):
        return 'Library(%s : %s)' % (self.id, self.path)

    @property
    def path(self):
        return self._real_path

    @property
    def name(self):
        return os.path.basename(self.path)

    @property
    def id(self):
        return self._id

    @property
    def symlinks(self):
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
                        os.path.join(reversed(library)),
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
            # TODO(rpath): discover rpaths
            # TODO(rpath): add rpaths
            self._rpaths = rpaths
        return self._rpaths

    @staticmethod
    def _get_dependencies(path):
        pipe = Pipeline([[
                'otool',
                '-L',
                path,
            ], [
                'sed',
                '-n'
                '-e', '/compatibility version/s/ (compatibility.*)//p',
            ]])
        return pipe().split()

    @property
    def dependencies(self):
        if self._dependencies is None:
            collection = set()
            for dep in self._get_dependencies(self.path):
                deplib = Library.create_from_reference(dep, self)
                if deplib is not None:
                    collection.add(deplib)
            self._dependencies = collection
        return self._dependencies

    # XXX(rewrite)
    @staticmethod
    def _find_library(ref):
        name = os.path.basename(ref)
        for loc in SearchLocations:
            output = commands.getoutput('find "%s" -name "%s"' % (loc, name)).strip()
            if output:
                return output
        return ref

    @classmethod
    def create_from_reference(cls, ref, loader):
        paths = [ref]
        if ref.startswith('@executable_path'):
            # If the loader does not have an executable path, it is a plugin
            # and we trust the executable which loads the plugin to provide
            # this library instead.
            if loader.executable_path is None:
                return None
            paths.append(ref.replace('@executable_path', loader.executable_path))
        elif ref.startswith('@loader_path'):
            paths.append(ref.replace('@loader_path', loader.loader_path))
        elif ref.startswith('@rpath'):
            for rpath in loader.rpaths:
                paths.append(ref.replace('@rpath', rpath))
        for path in paths:
            if os.path.exists(path):
                return cls.create_from_path(path, parent=loader)
        raise RuntimeError('Unable to find the %s library from %s' % (ref, loader))

    @staticmethod
    def _get_id(lib):
        pipe = Pipeline([[
                'otool',
                '-D',
                lib,
            ]])
        return pipe().split('\n')[1]

    @classmethod
    def create_from_path(cls, path, parent=None):
        if not os.path.exists(path):
            raise RuntimeError('%s does not exist' % path)

        realpath = os.path.realpath(path)
        dirname = os.path.dirname(realpath)
        symlinks = Pipeline([[
                'find',
                '-L',
                dirname,
                '-samefile', realpath,
            ]])

        symlinks = set(symlinks().split())
        try:
            symlinks.remove(realpath)
        except ValueError:
            pass

        symlink_bases = []
        for symlink in symlinks:
            symlink_dir, symlink_base = os.path.split(symlink)
            if not symlink_dir == dirname:
                continue
            symlink_bases.append(symlink_base)

        return Library(realpath, self._get_id(path), parent=parent, symlinks=symlink_bases)


class Executable(Library):
    def __init__(self, path):
        super(Executable, self).__init__(self, path, None)

        self._executable_path = os.path.dirname(path)

    @property
    def bundle_location(self):
        return 'Contents/MacOS'


class Plugin(Library):
    def __init__(self, path):
        super(Plugin, self).__init__(self, path, None)

    @property
    def bundle_location(self):
        return 'Contents/Plugins'


#class Framework?


def copy_library(destination, library, dry_run=False):
    if library.is_framework:
        print 'Copying %s ==> Contents/Frameworks' % library.framework_path
        app_dest = os.path.join(destination, 'Contents', 'Frameworks', library.framework_name)
        if not dry_run:
            # FIXME: this could be optimized to only copy the particular version.
            shutil.copytree(library.framework_path, app_dest, symlinks=True)
            new_id = '@executable_path/../Frameworks/%s' % library.framework_name
            install_name_tool = Pipeline([[
                    'install_name_tool',
                    '-id', new_id,
                    os.path.join(app_dest, library.framework_library),
                ]])
            install_name_tool()
    else:
        print 'Copying %s ==> Contents/Libraries' % library.path
        app_dest = os.path.join(destination, 'Contents', 'Libraries')
        if not dry_run:
            shutil.copy(library.path, app_dest)
            new_id = '@executable_path/../Libraries/%s' % library.name
            install_name_tool = Pipeline([[
                    'install_name_tool',
                    '-id', new_id,
                    os.path.join(app_dest, library.name),
                ]])
            install_name_tool()

        for symlink in library.symlinks:
            print 'Creating symlink to Contents/Libraries/%s ==> %s' % (library.name, symlink)
            if not dry_run:
                ln = Pipeline([[
                        'ln',
                        '-s',
                        library.name,
                        os.path.join(app_dest, symlink),
                    ]])
                ln()


def _create_arg_parser():
    import argparse

    parser = argparse.ArgumentParser(description='Install an OS X application into a bundle')
    parser.add_argument('-b', '--bundle', metavar='BUNDLE', type=str, required=True,
                        help='the name of the application (including .app extension)')
    parser.add_argument('-d', '--destination', metavar='DEST', type=str, required=True,
                        help='the directory to create the bundle underneath')
    parser.add_argument('-i', '--include', metavar='REGEX', type=str, action='append',
                        help='regular expression to include in the bundle (before exclusions)')
    parser.add_argument('-e', '--exclude', metavar='REGEX', type=str, action='append',
                        help='regular expression to exclude from the bundle')
    parser.add_argument('-s', '--search', metavar='PATH', type=str, action='append',
                        help='add a directory to search for dependent libraries')
    parser.add_argument('-n', '--dry-run', type=bool, action='store_true',
                        help='do not actually copy files')
    parser.add_argument('-t', '--type', metavar='TYPE', type=str,
                        choices=('executable', 'plugin'),
                        help='the type of binary to package')
    parser.add_argument('binary', metavar='BINARY', nargs=1, required=True,
                        help='the binary to package')

    return parser


def is_excluded(path, includes, excludes):
    for include in includes:
        if include.match(path):
            return False
    for exclude in excludes:
        if exclude.match(path):
            return True
    if path.startswith('/System/Library'):
        return True
    if path.startswith('/usr/lib'):
        return True
    if path.startswith('/usr/local/lib'):
        return False
    return False


def main(args):
    parser = _create_arg_parser()
    opts = args.parse_args(args)

    if opts.type == 'executable':
        main_exe = Executable(opts.binary)
    elif opts.type == 'plugin':
        main_exe = Plugin(opts.binary)

    includes = map(re.compile, opts.include)
    excludes = map(re.compile, opts.exclude)
    bundle_dest = os.path.join(opts.destination, opts.bundle)

    deps = main_exe.dependencies
    handled = set()
    while deps:
        dep = deps.pop(0)
        handled.add(dep.path)

        if not is_excluded(dep.path, includes, excludes):
            copy_library(bundle_dest, dry_run=opts.dry_run)

    print 'Copying %s ==> %s' % (main_exe.path, main_exe.bundle_location)
    if not opts.dry_run:
        shutil.copy(main_exe.path, os.path.join(bundle_dest, main_exe.bundle_location))


if __name__ == '__main__':
    import sys
    main(sys.argv[1:])
