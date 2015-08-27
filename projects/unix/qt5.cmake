list(APPEND qt5_extra_depends
  freetype
  fontconfig
  png)
list(APPEND qt5_extra_options
  -qt-xcb
  -system-libpng
  -I <INSTALL_DIR>/include/freetype2
  -I <INSTALL_DIR>/include/fontconfig)

include(qt5.common)
