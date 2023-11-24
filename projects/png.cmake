set(png_libtype_args)
if (BUILD_SHARED_LIBS)
  set(png_libtype_args -DPNG_SHARED:BOOL=ON -DPNG_STATIC:BOOL=OFF)
else ()
  set(png_libtype_args -DPNG_STATIC:BOOL=ON -DPNG_SHARED:BOOL=OFF)
endif ()

set(png_args)
if (APPLE AND CMAKE_HOST_SYSTEM_PROCESSOR STREQUAL "arm64")
  list(APPEND png_args
    -DPNG_ARM_NEON:STRING=off)
endif ()

superbuild_add_project(png
  CAN_USE_SYSTEM
  DEPENDS zlib
  LICENSE_FILES
    LICENSE
  SPDX_LICENSE_IDENTIFIER
    Libpng
  SPDX_COPYRIGHT_TEXT
    "Copyright (c) 1995-2019 The PNG Reference Library Authors."
    "Copyright (c) 2018-2019 Cosmin Truta."
    "Copyright (c) 2000-2002, 2004, 2006-2018 Glenn Randers-Pehrson."
    "Copyright (c) 1996-1997 Andreas Dilger."
    "Copyright (c) 1995-1996 Guy Eric Schalnat, Group 42, Inc."
  CMAKE_ARGS
    ${png_libtype_args}
    -DCMAKE_MACOSX_RPATH:BOOL=FALSE
    -DCMAKE_INSTALL_NAME_DIR:PATH=<INSTALL_DIR>/lib
    -DCMAKE_INSTALL_LIBDIR:PATH=lib
    -DPNG_TESTS:BOOL=OFF
    ${png_args}
    # VTK uses API that gets hidden when PNG_NO_STDIO is TRUE (default).
    -DPNG_NO_STDIO:BOOL=OFF)
