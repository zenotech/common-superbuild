set(openvkl_isas)
if (CMAKE_SYSTEM_PROCESSOR STREQUAL "amd64" OR
    CMAKE_SYSTEM_PROCESSOR STREQUAL "AMD64" OR
    CMAKE_SYSTEM_PROCESSOR STREQUAL "x86_64")
  list(APPEND openvkl_isas
    -DOPENVKL_ISA_AVX:BOOL=ON
    -DOPENVKL_ISA_AVX2:BOOL=ON
    -DOPENVKL_ISA_AVX512KNL:BOOL=OFF
    -DOPENVKL_ISA_AVX512SKX:BOOL=ON
    -DOPENVKL_ISA_AVX512SKX_8_WIDE:BOOL=OFF
    -DOPENVKL_ISA_SSE4:BOOL=ON)
elseif (CMAKE_SYSTEM_PROCESSOR MATCHES "arm64" OR
        CMAKE_SYSTEM_PROCESSOR MATCHES "aarch64")
  # Use NEON2X on macOS as its arm64 support is very new. Other platforms may
  # be targeting older processors.
  if (APPLE)
    list(APPEND openvkl_isas
      -DOPENVKL_ISA_NEON:BOOL=OFF
      -DOPENVKL_ISA_NEON2X:BOOL=ON)
  else ()
    list(APPEND openvkl_isas
      -DOPENVKL_ISA_NEON:BOOL=ON
      -DOPENVKL_ISA_NEON2X:BOOL=OFF)
  endif ()
endif ()

superbuild_add_project(openvkl
  DEPENDS ispc tbb cxx11 embree rkcommon
  LICENSE_FILES
    LICENSE.txt
  CMAKE_ARGS
    -DBUILD_BENCHMARKS:BOOL=OFF
    -DBUILD_EXAMPLES:BOOL=OFF
    -DBUILD_TESTING:BOOL=OFF
    -DCMAKE_INSTALL_NAME_DIR:PATH=<INSTALL_DIR>/lib
    -DCMAKE_INSTALL_LIBDIR:STRING=lib
    -DCMAKE_INSTALL_INCLUDEDIR:STRING=include
    -DISPC_EXECUTABLE:PATH=<INSTALL_DIR>/bin/ispc
    ${openvkl_isas})

superbuild_apply_patch(openvkl install-rpath "make rpath for superbuild to modify")
