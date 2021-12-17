set(freetype_install_rpath)
if (UNIX AND NOT APPLE)
  list(APPEND freetype_install_rpath
    -DCMAKE_INSTALL_RPATH:STRING=<INSTALL_DIR>/lib)
endif ()

superbuild_add_project(freetype
  CAN_USE_SYSTEM
  DEPENDS zlib png
  CMAKE_ARGS
    -DBUILD_SHARED_LIBS:BOOL=${BUILD_SHARED_LIBS}
    -DCMAKE_INSTALL_LIBDIR:STRING=lib
    -DCMAKE_INSTALL_NAME_DIR:PATH=<INSTALL_DIR>/lib
    ${freetype_install_rpath}
    -DFT_WITH_ZLIB:BOOL=${zlib_enabled}
    -DFT_WITH_BZIP2:BOOL=OFF
    -DFT_WITH_PNG:BOOL=${png_enabled}
    -DFT_WITH_HARFBUZZ:BOOL=OFF
    -DFT_WITH_BROTLI:BOOL=OFF)

# Upstream commit 5bcaf51b611ce579c89c2bb423984ec89fdaadd7
# https://gitlab.freedesktop.org/freetype/freetype/-/commit/5bcaf51b611ce579c89c2bb423984ec89fdaadd7
superbuild_apply_patch(freetype msvc-include-behavior
  "fix MSVC `#pragma once` emulation")
