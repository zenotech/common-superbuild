if (WIN32)
  list(APPEND qt5_options
    -qt-zlib)
else ()
  list(APPEND qt5_depends
    zlib)
  list(APPEND qt5_options
    -system-zlib)
endif ()

set(qt5_EXTRA_CONFIGURATION_OPTIONS ""
    CACHE STRING "Extra arguments to be passed to Qt when configuring.")
mark_as_advanced(qt5_EXTRA_CONFIGURATION_OPTIONS)

set(qt5_configure_ext)
if (WIN32)
  set(qt5_configure_ext ".bat")
endif ()

set(qt5_make_options)
if (CMAKE_C_COMPILER_LAUNCHER)
  list(APPEND qt5_make_options
    "CC=${CMAKE_C_COMPILER_LAUNCHER} ${CMAKE_C_COMPILER}")
endif ()
if (CMAKE_CXX_COMPILER_LAUNCHER)
  list(APPEND qt5_make_options
    "CXX=${CMAKE_CXX_COMPILER_LAUNCHER} ${CMAKE_CXX_COMPILER}")
endif ()

option(qt5_SKIP_PCH "Skip PCH" OFF)
mark_as_advanced(qt5_SKIP_PCH)
if (qt5_SKIP_PCH)
  list(APPEND qt5_options
    -no-pch)
endif ()

set(qt5_build_commands
  BUILD_COMMAND   $(MAKE) ${qt5_make_options}
  INSTALL_COMMAND make install)
if (WIN32)
  if ((NOT CMAKE_GENERATOR MATCHES "^NMake.*$") OR
      (NOT CMAKE_GENERATOR MATCHES "^Visual Studio.*$"))
    find_program(NMAKE_PATH nmake)
  endif ()

  set(qt5_build_commands
    BUILD_COMMAND   ${NMAKE_PATH}
    INSTALL_COMMAND ${NMAKE_PATH} install)
endif ()

set(qt5_optional_depends)
if (_superbuild_enable_openssl)
  list(APPEND qt5_optional_depends
    openssl)
endif ()

if ("openssl" IN_LIST qt5_optional_depends AND openssl_enabled)
  list(APPEND qt5_options "-openssl-linked")
else ()
  list(APPEND qt5_options "-no-openssl")
endif ()

# Add option to build qtsvg, on by default for svg icon support
option(qt5_ENABLE_SVG "Build Qt5 SVG library." ON)
mark_as_advanced(qt5_ENABLE_SVG)
if (NOT qt5_ENABLE_SVG)
  list(APPEND qt5_options
    -skip qtsvg)
endif()

# Add option to build qtmultimedia, on by default
option(qt5_ENABLE_MULTIMEDIA "Build Qt5 Multimedia library." ON)
mark_as_advanced(qt5_ENABLE_MULTIMEDIA)
if (NOT qt5_ENABLE_MULTIMEDIA)
  list(APPEND qt5_options
    -skip qtmultimedia)
endif()

foreach(module IN LISTS qt5_skip_modules)
  list(APPEND qt5_skip_args -skip ${module})
endforeach()

if (NOT qt5_SOURCE_SELECTION VERSION_LESS "5.15")
  list(APPEND qt5_options
    -no-zstd)
endif ()

superbuild_add_project(qt5
  CAN_USE_SYSTEM
  DEPENDS ${qt5_depends} ${qt5_extra_depends} cxx11
  DEPENDS_OPTIONAL ${qt5_optional_depends}
  LICENSE_FILES
    LICENSE.LGPLv3 # Qt is distributed under many licenses, this one can be chosen for the enabled components
  SPDX_LICENSE_IDENTIFIER
    LGPL-3.0-or-later
  SPDX_COPYRIGHT_TEXT
    "Copyright (C) 2015 The Qt Company Ltd"
  CONFIGURE_COMMAND
    <SOURCE_DIR>/configure${qt5_configure_ext}
      -opensource
      -confirm-license

      -release

      -prefix <INSTALL_DIR>
      -I <INSTALL_DIR>/include
      -L <INSTALL_DIR>/lib

      ${qt5_skip_args}

      -nomake examples
      -nomake tests

      -no-dbus
      -no-icu

      -qt-libjpeg
      -qt-pcre

      ${qt5_options}
      ${qt5_extra_options}
      ${qt5_EXTRA_CONFIGURATION_OPTIONS}
  ${qt5_build_commands}
  PROCESS_ENVIRONMENT
    ${qt5_process_environment})

superbuild_add_extra_cmake_args(
  -DPARAVIEW_QT_VERSION:STRING=5
  -DQt5_DIR:PATH=<INSTALL_DIR>/lib/cmake/Qt5)

if (NOT qt5_SOURCE_SELECTION VERSION_LESS "5.15")
  # reimplemented from https://invent.kde.org/qt/qt/qtbase/-/commit/8af35d27e8f02bbb99aef4ac495ed406e50e3cca
  superbuild_apply_patch(qt5 fix-xcb-header "Fix qxcb header for recent xcb")
endif ()
