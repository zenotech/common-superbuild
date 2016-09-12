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

        stdout, stderr = command.communicate()
        if command.returncode:
            raise RuntimeError('failed to execute pipeline:\n%s' % stderr)
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
        self._dependencies = None
        self._rpaths = None
        self._runpaths = None

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
    def symlinks(self):
        if self._symlinks is None:
            realpath = os.path.realpath(self.path)
            dirname = os.path.dirname(realpath)
            symlinks = Pipeline([
                    'find',
                    '-L',
                    dirname,
                    '-maxdepth', '1',
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
    def loader_path(self):
        return os.path.dirname(self.path)

    @property
    def loader_paths(self):
        loader_paths = [self.loader_path]
        if self.parent is not None:
            loader_paths.extend(self.parent.loader_paths)
        return loader_paths

    def _resolve_rpath(self, rpath):
        if rpath.startswith('$ORIGIN'):
            rpath = rpath.replace('$ORIGIN', self.loader_path)

        # TODO: Handle $LIB and $PLATFORM (also ${} forms).

        return rpath.strip()

    @property
    def rpaths(self):
        if self._rpaths is None:
            rpaths = []
            get_rpaths = Pipeline([
                    'objdump',
                    '-p',
                    self.path,
                ], [
                    'awk',
                    '''
                    $1 == "RUNPATH" {
                        exit
                    }

                    $1 == "RPATH" {
                        rpath_entries[LINE] = $2
                    }

                    END {
                        for (entry_idx in rpath_entries) {
                            split(rpath_entries[entry_idx], rpaths, /:/)
                            for (idx in rpaths) {
                                path = rpaths[idx]
                                if (path) {
                                    print path
                                }
                            }
                        }
                    }
                    ''',
                ])
            rpaths.extend(get_rpaths().split('\n'))

            self._rpaths = list(filter(lambda x: x, map(self._resolve_rpath, rpaths)))
        return self._rpaths

    @property
    def runpaths(self):
        if self._runpaths is None:
            runpaths = []
            get_runpaths = Pipeline([
                    'objdump',
                    '-p',
                    self.path,
                ], [
                    'awk',
                    '''
                    $1 == "RUNPATH" {
                        print $2
                    }
                    ''',
                ])
            runpaths.extend(get_runpaths().split(':'))

            self._runpaths = list(filter(lambda x: x, map(self._resolve_rpath, runpaths)))
        return self._runpaths

    def _get_dependencies(self):
        pipe = Pipeline([
                'objdump',
                '-p',
                self.path,
            ], [
                'awk',
                '''
                $1 == "NEEDED" {
                    print $2
                }
                ''',
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
                    '-maxdepth', '1',
                ])
            output = find()
            if output:
                return output.split('\n')[0]
        return ref

    __search_cache = None

    @classmethod
    def default_search_paths(cls):
        if cls.__search_cache is None:
            pipe = Pipeline([
                    'ldconfig',
                    '-v',
                ], [
                    'grep',
                    '-v',
                    '^\t',
                ], [
                    'cut',
                    '-d:',
                    '-f1',
                ])
            cls.__search_cache = pipe().split('\n')

        return cls.__search_cache

    @classmethod
    def create_from_reference(cls, ref, loader):
        paths = []

        if '/' in ref:
            if os.path.exists(ref):
                return cls.create_from_path(ref, parent=loader)
        else:
            paths.extend(loader.loader_paths)

            # Find the path via rpath.
            paths.extend(loader.rpaths)

            # Use LD_LIBRARY_PATH.
            ld_library_path = os.environ.get('LD_LIBRARY_PATH')
            if ld_library_path is not None:
                paths.extend(ld_library_path.split(':'))

            # Find the path via runpath.
            paths.extend(loader.runpaths)

            # Find the library in the default library search paths.
            paths.extend(cls.default_search_paths())

            for path in paths:
                libpath = os.path.join(path, ref)
                if os.path.exists(libpath):
                    return cls.create_from_path(libpath, parent=loader)

        search_path = loader._find_library(ref)
        if os.path.exists(search_path):
            return cls.create_from_path(search_path, parent=loader)
        raise RuntimeError('Unable to find the %s library from %s: %s' % (ref, loader.path, ', '.join(paths)))

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
    def create_from_manifest(cls, path):
        if path in cls.__cache:
            raise RuntimeError('There is already a library for %s' % path)

        library = Library(path)
        library._dependencies = {}

        cls.__cache[path] = library
        return cls.__cache[path]


class Module(Library):
    def __init__(self, path, bundle_location, **kwargs):
        super(Module, self).__init__(path, None, **kwargs)

        self._bundle_location = bundle_location

    @property
    def bundle_location(self):
        return self._bundle_location


class Executable(Module):
    def __init__(self, path, **kwargs):
        super(Executable, self).__init__(path, 'bin', **kwargs)


def copy_library(destination, libdir, library, dry_run=False):
    print 'Copying %s ==> %s' % (library.path, libdir)

    app_dest = os.path.join(destination, libdir)
    binary = os.path.join(app_dest, library.name)
    destination = app_dest

    if not dry_run:
        _os_makedirs(app_dest)
        shutil.copy(library.path, destination)

    for symlink in library.symlinks:
        print 'Creating symlink to %s/%s ==> %s' % (libdir, library.name, symlink)
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
        chmod = Pipeline([
                'chmod',
                'u+w',
                binary,
            ])
        chmod()

    return binary


# A function to fix up the fact that os.makedirs chokes if the path already
# exists.
def _os_makedirs(path):
    if os.path.exists(path):
        return
    os.makedirs(path)


def _create_arg_parser():
    import argparse

    parser = argparse.ArgumentParser(description='Install an ELF binary into a bundle')
    parser.add_argument('-d', '--destination', metavar='DEST', type=str, required=True,
                        help='the directory to create the bundle underneath')
    parser.add_argument('-i', '--include', metavar='REGEX', action='append',
                        default=[],
                        help='regular expression to include in the bundle (before exclusions)')
    parser.add_argument('-e', '--exclude', metavar='REGEX', action='append',
                        default=[],
                        help='regular expression to exclude from the bundle')
    parser.add_argument('-s', '--search', metavar='PATH', action='append',
                        default=[],
                        help='add a directory to search for dependent libraries')
    parser.add_argument('-n', '--dry-run', action='store_true',
                        help='do not actually copy files')
    parser.add_argument('-c', '--clean', action='store_true',
                        help='clear out the bundle destination before starting')
    parser.add_argument('-l', '--location', metavar='PATH', type=str,
                        help='where to place a module within the bundle')
    parser.add_argument('-L', '--libdir', metavar='PATH', type=str, required=True,
                        help='location to put dependent libraries')
    parser.add_argument('-m', '--manifest', metavar='PATH', type=str, required=True,
                        help='manifest for the application bundle')
    parser.add_argument('-t', '--type', metavar='TYPE', type=str, required=True,
                        choices=('executable', 'module'),
                        help='the type of binary to package')
    parser.add_argument('binary', metavar='BINARY', type=str,
                        help='the binary to package')

    return parser


def _install_binary(binary, is_excluded, bundle_dest, dep_libdir, installed, manifest, dry_run=False):
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
        installed[dep.path] = (dep, copy_library(bundle_dest, dep_libdir, dep, dry_run=dry_run))

    # Install the main executable itself.
    app_dest = os.path.join(bundle_dest, binary.bundle_location)
    binary_destination = os.path.join(app_dest, os.path.basename(binary.path))
    installed[binary.path] = (binary, binary_destination)
    print 'Copying %s ==> %s' % (binary.path, binary.bundle_location)
    if not dry_run:
        _os_makedirs(app_dest)
        shutil.copy(binary.path, app_dest)


def _update_manifest(manifest, installed, path):
    for input_path in installed.keys():
        manifest.add(input_path)

    with open(path, 'w+') as fout:
        json.dump(list(manifest), fout)


def main(args):
    parser = _create_arg_parser()
    opts = parser.parse_args(args)

    if opts.type == 'executable':
        main_exe = Executable(opts.binary, search_paths=opts.search)
    elif opts.type == 'module':
        if opts.location is None:
            raise RuntimeError('Modules require a location')

        main_exe = Module(opts.binary, opts.location,
                          search_paths=opts.search)

    bundle_dest = opts.destination

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
        # System libs
        if path.startswith('/lib'):
            return True
        if path.startswith('/usr/lib'):
            return True
        # Local installs
        if path.startswith('/usr/local/lib'):
            return True
        return False

    if opts.clean:
        # A new bundle does not have a manifest.
        manifest = set()
    else:
        with open(opts.manifest, 'r') as fin:
            manifest = set(json.load(fin))

        # Seed the cache with manifest entries.
        for path in manifest:
            Library.create_from_manifest(path)

    installed = {}
    _install_binary(main_exe, is_excluded, bundle_dest, opts.libdir, installed, manifest, dry_run=opts.dry_run)

    if not opts.dry_run:
        _update_manifest(manifest, installed, opts.manifest)


if __name__ == '__main__':
    import sys
    main(sys.argv[1:])
