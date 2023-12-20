set(blosc_static_libs ON)
if (BUILD_SHARED_LIBS)
  set(blosc_static_libs OFF)
endif ()

set(blosc_without_lz4 ON)
if (lz4_enabled)
  set(blosc_without_lz4 OFF)
endif ()

set(blosc_without_zlib ON)
if (zlib_enabled)
  set(blosc_without_zlib OFF)
endif ()

set(blosc_without_zstd ON)
if (zstd_enabled)
  set(blosc_without_zstd OFF)
endif ()

superbuild_add_project(blosc
  CAN_USE_SYSTEM
  DEPENDS_OPTIONAL
    zlib zstd lz4
  LICENSE_FILES
    LICENSE.txt
    LICENSES/LZ4.txt
  SPDX_LICENSE_IDENTIFIER
    "BSD-3-Clause AND BSD-2-Clause"
  SPDX_COPYRIGHT_TEXT
    "Copyright (c) 2009-2018 Francesc Alted"
    "Copyright (c) 2019-present Blosc Development Team"
  CMAKE_ARGS
    -DCMAKE_INSTALL_LIBDIR:STRING=lib
    -DCMAKE_INSTALL_NAME_DIR:PATH=<INSTALL_DIR>/lib
    -DBUILD_SHARED:BOOL=${BUILD_SHARED_LIBS}
    -DBUILD_STATIC:BOOL=${blosc_static_libs}
    -DBUILD_TESTS:BOOL=OFF
    -DBUILD_FUZZERS:BOOL=OFF
    -DBUILD_BENCHMARKS:BOOL=OFF
    -DDEACTIVATE_LZ4:BOOL=${blosc_without_lz4}
    -DDEACTIVATE_SNAPPY:BOOL=ON
    -DDEACTIVATE_ZLIB:BOOL=${blosc_without_zlib}
    -DDEACTIVATE_ZSTD:BOOL=${blosc_without_zstd}
    -DPREFER_EXTERNAL_LZ4:BOOL=${lz4_enabled}
    -DPREFER_EXTERNAL_ZLIB:BOOL=${zlib_enabled}
    -DPREFER_EXTERNAL_ZSTD:BOOL=${zstd_enabled})
