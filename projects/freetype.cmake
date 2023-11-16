set(freetype_install_rpath)
if (UNIX AND NOT APPLE)
  list(APPEND freetype_install_rpath
    -DCMAKE_INSTALL_RPATH:STRING=<INSTALL_DIR>/lib)
endif ()

if (zlib_enabled)
  set(freetype_zlib_disable OFF)
else ()
  set(freetype_zlib_disable ON)
endif ()

if (png_enabled)
  set(freetype_png_disable OFF)
else ()
  set(freetype_png_disable ON)
endif ()

superbuild_add_project(freetype
  CAN_USE_SYSTEM
  DEPENDS zlib png
  LICENSE_FILES
    LICENSE.TXT
    docs/FTL.TXT
  SPDX_LICENSE_IDENTIFIER
    FTL
  SPDX_COPYRIGHT_TEXT
    "Copyright 1996-2002, 2006 by David Turner, Robert Wilhelm, and Werner Lemberg"
  CMAKE_ARGS
    -DBUILD_SHARED_LIBS:BOOL=${BUILD_SHARED_LIBS}
    -DCMAKE_INSTALL_LIBDIR:STRING=lib
    -DCMAKE_INSTALL_NAME_DIR:PATH=<INSTALL_DIR>/lib
    ${freetype_install_rpath}
    -DFT_DISABLE_ZLIB:BOOL=${freetype_zlib_disable}
    -DFT_REQUIRE_ZLIB:BOOL=${zlib_enabled}
    -DFT_DISABLE_BZIP2:BOOL=ON
    -DFT_DISABLE_PNG:BOOL=${freetype_png_disable}
    -DFT_REQUIRE_PNG:BOOL=${png_enabled}
    -DFT_DISABLE_HARFBUZZ:BOOL=ON
    -DFT_DISABLE_BROTLI:BOOL=ON)
