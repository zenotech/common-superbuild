set(qt4_EXTRA_CONFIGURATION_OPTIONS ""
  CACHE STRING "Extra arguments to be passed to Qt4 when configuring.")
mark_as_advanced(qt4_EXTRA_CONFIGURATION_OPTIONS)

set(qt4_build_commands
  BUILD_COMMAND   $(MAKE)
  INSTALL_COMMAND make install)

set(qt4_configure_ext)
if (WIN32)
  if ((NOT CMAKE_GENERATOR MATCHES "^NMake.*$") OR
      (NOT CMAKE_GENERATOR MATCHES "^Visual Studio.*$"))
    find_program(NMAKE_PATH nmake)
  endif ()

  # TODO: Fix the zdll.lib issue (qt wants the library to be named differently
  # hence skipping using our zlib on windows. Let qt build its own zlib.)
  set(qt4_configure_ext ".exe")
  list(APPEND qt4_extra_arguments
    BUILD_IN_SOURCE 1)
  set(qt4_build_commands
    BUILD_COMMAND   ${NMAKE_PATH}
    INSTALL_COMMAND ${NMAKE_PATH} install)
else ()
  list(APPEND qt4_extra_options
    -no-svg
    -no-xinerama
    -no-xvideo
    -system-zlib)
endif ()

# If not using system qt4, add qt4_ENABLE_OPENSSL option
option(qt4_ENABLE_OPENSSL "Build Qt with OpenSSL support" OFF)
mark_as_advanced(qt4_ENABLE_OPENSSL)
if (NOT qt4_ENABLE_OPENSSL)
  list(APPEND qt4_extra_options "-no-openssl")
endif ()

superbuild_add_project(qt4
  CAN_USE_SYSTEM
  DEPENDS zlib ${qt4_extra_depends}
  DEPENDS_OPTIONAL cxx11
  ${qt4_extra_arguments}
  CONFIGURE_COMMAND
    <SOURCE_DIR>/configure${qt4_configure_ext}
      -opensource
      -confirm-license

      -release

      -prefix <INSTALL_DIR>
      -I <INSTALL_DIR>/include
      -L <INSTALL_DIR>/lib

      -no-audio-backend
      -no-dbus
      -no-declarative-debug
      -no-multimedia
      -no-phonon
      -no-script
      -no-scripttools
      -no-webkit
      -stl
      -xmlpatterns

      -nomake demos
      -nomake examples
      -nomake tests

      -qt-libjpeg
      -qt-libtiff

      ${qt4_extra_options}
      ${qt4_EXTRA_CONFIGURATION_OPTIONS}
  ${qt4_build_commands})

superbuild_add_extra_cmake_args(
  -DPARAVIEW_QT_VERSION:STRING=4)
