set(qt4_EXTRA_CONFIGURATION_OPTIONS ""
  CACHE STRING "Extra arguments to be passed to Qt4 when configuring.")

# See https://bugreports.qt.io/browse/QTBUG-5774 and the links available there.
cmake_dependent_option(qt4_WORK_AROUND_BROKEN_ASSISTANT_BUILD "Work around a build issue in Qt. Use this if you see linker errors with QtHelp and QCLucene." OFF
  "NOT WIN32" OFF)
mark_as_advanced(qt4_WORK_AROUND_BROKEN_ASSISTANT_BUILD)

set(qt4_build_commands
  BUILD_COMMAND   $(MAKE)
  INSTALL_COMMAND make install)
if (qt4_WORK_AROUND_BROKEN_ASSISTANT_BUILD)
  # This hack is required because Qt's build gets mucked up when we set
  # LDFLAGS, CXXFLAGS, etc. Installing things makes it work because the files
  # get placed into the install tree which has rpaths so they get found. Since
  # it is such a hack, it is an option which off and hidden by default.
  set(qt4_build_commands
    BUILD_COMMAND   $(MAKE) install
    INSTALL_COMMAND "")
endif ()

set(qt4_configure_ext)
if (WIN32)
  if ((NOT "${CMAKE_GENERATOR}" MATCHES "^NMake.*$") OR
      (NOT "${CMAKE_GENERATOR}" MATCHES "^Visual Studio.*$"))
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

superbuild_add_project(qt4
  CAN_USE_SYSTEM
  DEPENDS zlib ${qt4_extra_depends}
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
      -no-openssl
      -no-phonon
      -no-script
      -no-scripttools
      -no-webkit
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
