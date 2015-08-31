if (WIN32)
  list(APPEND qt5_options
    -qt-zlib)
else ()
  list(APPEND qt5_depends
    zlib)
  list(APPEND qt5_options
    -no-alsa
    -no-pulseaudio
    -system-zlib)
endif ()

set(qt5_EXTRA_CONFIGURATION_OPTIONS ""
    CACHE STRING "Extra arguments to be passed to Qt when configuring.")

set(qt5_configure_ext)
if (WIN32)
  set(qt5_configure_ext ".bat")
endif ()

set(qt5_build_commands
  BUILD_COMMAND   $(MAKE)
  INSTALL_COMMAND make install)
if (WIN32)
  if ((NOT "${CMAKE_GENERATOR}" MATCHES "^NMake.*$") OR
      (NOT "${CMAKE_GENERATOR}" MATCHES "^Visual Studio.*$"))
    find_program(NMAKE_PATH nmake)
  endif ()

  set(qt5_build_commands
    BUILD_COMMAND   ${NMAKE_PATH}
    INSTALL_COMMAND ${NMAKE_PATH} install)
endif ()

superbuild_add_project(qt5
  DEPENDS ${qt5_depends} ${qt5_extra_depends}
  CONFIGURE_COMMAND
    <SOURCE_DIR>/configure${qt5_configure_ext}
      -opensource
      -confirm-license

      -release

      -prefix <INSTALL_DIR>
      -I <INSTALL_DIR>/include
      -L <INSTALL_DIR>/lib

      -skip qtconnectivity
      -skip qtlocation
      -skip qtmultimedia
      -skip qtquick1
      -skip qtsensors
      -skip qtserialport
      -skip qtsvg
      -skip qtwayland
      -skip qtwebchannel
      -skip qtwebengine
      -skip qtwebkit
      -skip qtwebkit-examples
      -skip qtwebsockets

      -nomake examples
      -nomake tests

      -no-dbus
      -no-openssl

      -qt-libjpeg
      -qt-pcre

      ${qt5_options}
      ${qt5_extra_options}
      ${qt5_EXTRA_CONFIGURATION_OPTIONS}
  ${qt5_build_commands})

superbuild_add_extra_cmake_args(
  -DPARAVIEW_QT_VERSION:STRING=5
  -DQt5_DIR:PATH=<INSTALL_DIR>/lib/cmake/Qt5)
