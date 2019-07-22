function (superbuild_python_write_reqs path)
  get_property(packages GLOBAL
    PROPERTY _superbuild_python_packages)

  file(WRITE "${path}" "")
  foreach (package IN LISTS packages)
    file(APPEND "${path}"
      "${package}\n")
  endforeach ()
endfunction ()

function (superbuild_install_superbuild_python3)
  if (USE_SYSTEM_python3)
    return ()
  endif()

  set(options)
  set(values
    LIBSUFFIX)
  set(multivalues
    MODULES)
  cmake_parse_arguments(_install_superbuild_python "${options}" "${values}" "${multivalues}" ${ARGN})

  set(modules
    __future__
    __pycache__
    _bootlocale
    _collections_abc
    _compat_pickle
    _compression
    _dummy_thread
    _markupbase
    _osx_support
    _py_abc
    _pydecimal
    _pyio
    _sitebuiltins
    _strptime
    _threading_local
    _weakrefset
    abc
    aifc
    antigravity
    argparse
    ast
    asynchat
    asyncio
    asyncore
    base64
    bdb
    binhex
    bisect
    bz2
    cProfile
    calendar
    cgi
    cgitb
    chunk
    cmd
    code
    codecs
    codeop
    collections
    colorsys
    compileall
    concurrent
    config-${superbuild_python_version}m-x86_64-linux-gnu
    configparser
    contextlib
    contextvars
    copy
    copyreg
    crypt
    csv
    ctypes
    curses
    dataclasses
    datetime
    dbm
    decimal
    difflib
    dis
    distutils
    doctest
    dummy_threading
    email
    encodings
    ensurepip
    enum
    filecmp
    fileinput
    fnmatch
    formatter
    fractions
    ftplib
    functools
    genericpath
    getopt
    getpass
    gettext
    glob
    gzip
    hashlib
    heapq
    hmac
    html
    http
    idlelib
    imaplib
    imghdr
    imp
    importlib
    inspect
    io
    ipaddress
    json
    keyword
    lib2to3
    linecache
    locale
    logging
    lzma
    macpath
    mailbox
    mailcap
    mimetypes
    modulefinder
    multiprocessing
    netrc
    nntplib
    ntpath
    nturl2path
    numbers
    opcode
    operator
    optparse
    os
    pathlib
    pdb
    pickle
    pickletools
    pipes
    pkgutil
    platform
    plistlib
    poplib
    posixpath
    pprint
    profile
    pstats
    pty
    py_compile
    pyclbr
    pydoc
    pydoc_data
    queue
    quopri
    random
    re
    reprlib
    rlcompleter
    runpy
    sched
    secrets
    selectors
    shelve
    shlex
    shutil
    signal
    site
    smtpd
    smtplib
    sndhdr
    socket
    socketserver
    sqlite3
    sre_compile
    sre_constants
    sre_parse
    ssl
    stat
    statistics
    string
    stringprep
    struct
    subprocess
    sunau
    symbol
    symtable
    sysconfig
    tabnanny
    tarfile
    telnetlib
    tempfile
    test
    textwrap
    this
    threading
    timeit
    tkinter
    token
    tokenize
    trace
    traceback
    tracemalloc
    tty
    turtle
    turtledemo
    types
    typing
    unittest
    urllib
    uu
    uuid
    venv
    warnings
    wave
    weakref
    webbrowser
    wsgiref
    xdrlib
    xml
    xmlrpc
    zipapp
    zipfile
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
      MODULE_DIRECTORIES  "${superbuild_install_location}/lib/python${superbuild_python_version}"
                          "${superbuild_install_location}/lib/python${superbuild_python_version}/lib-dynload")
    install(
      DIRECTORY   "${superbuild_install_location}/lib/python${superbuild_python_version}/lib-dynload/"
      DESTINATION "lib/python${superbuild_python_version}/lib-dynload"
      COMPONENT   "superbuild")
  endif ()
endfunction ()
