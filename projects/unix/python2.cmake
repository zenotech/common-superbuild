if (BUILD_SHARED_LIBS)
  set(python2_shared_args --enable-shared)
else ()
  set(python2_shared_args --disable-shared --enable-static)
endif ()

if (NOT _python2_unicode_default)
  set(_python2_unicode_default "UCS2")
endif ()

set(python2_USE_UNICODE "${_python2_unicode_default}" CACHE STRING "Enable Unicode support for python2")
set_property(CACHE python2_USE_UNICODE PROPERTY STRINGS "OFF;UCS2;UCS4")
mark_as_advanced(python2_USE_UNICODE)

if (python2_USE_UNICODE STREQUAL "UCS2")
  set(python2_unicode_args "--enable-unicode=ucs2")
elseif (python2_USE_UNICODE STREQUAL "UCS4")
  set(python2_unicode_args "--enable-unicode=ucs4")
else ()
  set(python2_unicode_args "--disable-unicode")
endif ()

superbuild_add_project(python2
  CAN_USE_SYSTEM
  DEPENDS bzip2 zlib png
  CONFIGURE_COMMAND
    <SOURCE_DIR>/configure
      --prefix=<INSTALL_DIR>
      --with-ensurepip=install
      ${python2_unicode_args}
      ${python2_shared_args}
  BUILD_COMMAND
    $(MAKE)
  INSTALL_COMMAND
    make install)

if (NOT CMAKE_CROSSCOMPILING)
  # Pass the -rpath flag when building python to avoid issues running the
  # executable we built.
  superbuild_append_flags(
    ld_flags "-Wl,-rpath,${superbuild_install_location}/lib"
    PROJECT_ONLY)
endif ()

if (python2_enabled)
  set(superbuild_python_executable "${superbuild_install_location}/bin/python"
    CACHE INTERNAL "")
  set(superbuild_python_pip "${superbuild_install_location}/bin/pip"
    CACHE INTERNAL "")
else ()
  set(superbuild_python_executable ""
    CACHE INTERNAL "")
  set(superbuild_python_pip ""
    CACHE INTERNAL "")
endif ()

set(superbuild_python_version "2.7"
  CACHE INTERNAL "")

superbuild_add_extra_cmake_args(
  -DPython2_EXECUTABLE:FILEPATH=<INSTALL_DIR>/bin/python2.7
  -DPython2_INCLUDE_DIR:PATH=<INSTALL_DIR>/include/python2.7
  -DPython2_LIBRARY:FILEPATH=<INSTALL_DIR>/lib/libpython2.7.so

  -DPYTHON_EXECUTABLE:FILEPATH=<INSTALL_DIR>/bin/python2.7
  -DPYTHON_INCLUDE_DIR:PATH=<INSTALL_DIR>/include/python2.7
  -DPYTHON_LIBRARY:FILEPATH=<INSTALL_DIR>/lib/libpython2.7.so)
