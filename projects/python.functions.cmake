function (superbuild_install_superbuild_python)
  if (USE_SYSTEM_python)
    return ()
  endif ()

  set(modules
    ConfigParser StringIO UserDict __future__ _abcoll _socket _weakrefset abc
    atexit base64 bisect code codecs codeop collections commands compileall
    copy copy_reg difflib fnmatch functools genericpath getopt glob hashlib
    httplib functools heapq io keyword linecache locale mimetools new ntpath
    nturl2path os pickle pkgutil platform posixpath pprint py_compile random re
    rfc822 runpy shlex shutil site socket sre_compile sre_constants sre_parse
    stat string struct subprocess sysconfig tempfile textwrap threading
    traceback types unittest urllib urllib2 urlparse warnings weakref

    ctypes distutils email encodings importlib json multiprocessing xml)

  if (WIN32)
    superbuild_windows_install_python(
      "${CMAKE_INSTALL_PREFIX}"
      MODULES ${modules}
              ${ARGN}
      MODULE_DIRECTORIES
              "${superbuild_install_location}/bin/Lib"
      SEARCH_DIRECTORIES
              "lib"
      DESTINATION
              "bin/Lib")
  else ()
    message(FATAL_ERROR "Not supported on Linux yet.")
  endif ()
endfunction ()
