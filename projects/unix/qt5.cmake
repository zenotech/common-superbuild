list(APPEND qt5_extra_depends
  freetype
  fontconfig
  png)
list(APPEND qt5_extra_options
  -qt-xcb
  -system-libpng
  -fontconfig)
if (NOT qt5_SOURCE_SELECTION VERSION_LESS "5.12")
  list(APPEND qt5_extra_options
    -xkbcommon)
endif ()

list(APPEND qt5_process_environment
  PKG_CONFIG_PATH <INSTALL_DIR>/lib/pkgconfig)

include(qt5.common)

if (NOT qt5_SOURCE_SELECTION VERSION_LESS "5.10")
  superbuild_apply_patch(qt5 btn-trigger-defs
    "Handle older kernels without BTN_TRIGGER_HAPPY defines")
endif ()
