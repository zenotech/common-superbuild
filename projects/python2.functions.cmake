function (superbuild_install_superbuild_python2)
  if (USE_SYSTEM_python2)
    return ()
  endif ()

  set(options)
  set(values
    LIBSUFFIX)
  set(multivalues
    MODULES)
  cmake_parse_arguments(_install_superbuild_python "${options}" "${values}" "${multivalues}" ${ARGN})

  set(modules
    # string services
    string re struct difflib StringIO cStringIO textwrap codecs unicodedata
    stringprep fpformat

    encodings
    sre_compile sre_constants sre_parse

    _struct _strptime

    # data types
    datetime calendar collections heapq bisect array sets sched mutex Queue
    weakref UserDict UserList UserString types new copy pprint repr

    arraymodule _bisectmodule _weakrefset _collections

    # numeric and math modules
    numbers math cmath decimal fractions random itertools functools operator

    _functools _random

    # file and directory access
    fileinput stat statvfs filecmp tempfile glob fnmatch linecache shutil
    dircache
    macpath

    # os.path (part of os below), but needs these:
    genericpath ntpath nturl2path posixpath

    # data persistence
    pickle cPickle copy_reg shelve
    marshal anydbm whichdb dbm gdbm dbhash bsddb dumbdbm sqlite3
    _bsddb

    # data compression and archiving
    zlib gzip bz2 zipfile tarfile

    # file formats
    csv ConfigParser
    robotparser netrc xdrlib plistlib

    _csv

    # crypto services
    hashlib hmac
    md5 sha

    _hashlib _sha _md5 _sha256 _sha512

    # os services
    os io time argparse optparse getopt logging getpass platform errno
    ctypes fcntl
    curses

    _ctypes _io _pyio

    threading multiprocessing select thread mmap dummy_threading
    dummy_thread readline rlcompleter

    _multiprocessing _threading_local

    # ipc and networking
    subprocess socket signal popen2
    ssl asyncore asynchat
    _socket _ssl

    # internet data handling
    email json mimetools mimetypes MimeWriter multifile rfc822 base64 binhex
    binascii quopri uu
    mailcap mailbox mhlib mimify

    # markup tools
    HTMLParser sgmllib htmllib htmlentitydefs xml

    _elementtree pyexpat markupbase

    # internet protocol and support
    webbrowser urllib urllib2 httplib uuid urlparse cgi cookielib xmlrpclib
    BaseHTTPServer SimpleHTTPServer SimpleXMLRPCServer SocketServer
    cgitb wsgiref ftplib poplib imaplib nntplib smtplib smtpd telnetlib
    CGIHTTPServer Cookie DocXMLRPCServer

    _LWPCookieJar _MozillaCookieJar

    # multimedia services
    audioop imageop aifc sunau wave chunk colorsys imghdr sndhdr ossaudiodev

    # i18n
    locale gettext

    # program frameworks
    cmd shlex

    # gui modules (tk)
    Tkinter ttk Tix ScrolledText turtle

    # development tools
    pydoc doctest unittest test
    pydoc_data

    # debugging and profiling
    bdb pdb
    hotshot timeit trace

    # software packaging and distribution
    distutils
    ensurepip

    # python runtime services
    sys sysconfig __builtin__ future_builtins __main__ warnings contextlib abc
    atexit traceback __future__ gc inspect site user
    fpectl lib2to3

    _abcoll _sysconfigdata opcode

    # custom python interpreters
    code codeop

    # restricted execution
    rexec Bastion
    ihooks

    # importing modules
    imp importlib imputil zipimport pkgutil modulefinder runpy

    # python language services
    parser ast symtable symbol token keyword tokenize pyclbr py_compile
    compileall compiler dis pickletools

    # misc services
    formatter

    # windows services
    msilib msvcrt _winreg winsound

    # unix services
    commands
    posix pwd spwd grp crypt dl termios tty pty fnctl pipes posixfile
    resource nis syslog

    # os x services
    ic MacOS macostools findertools EasyDialogs FrameWork autoGIL ColorPicker
    gensuitemodule aetools aepack aetypes MiniAEFrame

    # irix services
    #al AL cd fl FL flp fm gl DEVICE GL imgfile jpeg

    # sunos services
    #sunaudiodev SUNAUDIODEV
    )

  if (WIN32)
    superbuild_windows_install_python(
      MODULE_DESTINATION  "/"
      MODULES             ${modules} ${_install_superbuild_python_MODULES}
      MODULE_DIRECTORIES  "${superbuild_install_location}/bin/Lib"
      SEARCH_DIRECTORIES  "${superbuild_install_location}/bin"
                          "${superbuild_install_location}/lib${_install_superbuild_python_LIBSUFFIX}"
      EXCLUDE_REGEXES     "MSVCR90.dll")
  else ()
    superbuild_unix_install_python(
      MODULE_DESTINATION  "/"
      LIBDIR              "lib${_install_superbuild_python_LIBSUFFIX}"
      MODULES             ${modules} ${_install_superbuild_python_MODULES}
      MODULE_DIRECTORIES  "${superbuild_install_location}/lib/python2.7"
                          "${superbuild_install_location}/lib/python2.7/lib-dynload")

    set(lib_dynload_directory "${CMAKE_CURRENT_BINARY_DIR}/python/lib-dynload")
    file(REMOVE_RECURSE "${lib_dynload_directory}")
    file(MAKE_DIRECTORY "${lib_dynload_directory}")
    install(
      DIRECTORY   "${lib_dynload_directory}/"
      DESTINATION "lib/python2.7/lib-dynload"
      COMPONENT   "superbuild")
  endif ()
endfunction ()
