set(hdf5_build_static_libs ON)
if (BUILD_SHARED_LIBS)
  set(hdf5_build_static_libs OFF)
endif ()

set(hdf5_mpi_supported ${mpi_enabled})
if (_hdf5_disable_mpi_support)
  set(hdf5_mpi_supported OFF)
endif ()

superbuild_add_project(hdf5
  CAN_USE_SYSTEM
  DEPENDS zlib szip
  DEPENDS_OPTIONAL hdf5cpp mpi
  LICENSE_FILES
    COPYING
    COPYING_LBNL_HDF5
  CMAKE_ARGS
    -DBUILD_TESTING:BOOL=OFF
    -DBUILD_SHARED_LIBS:BOOL=${BUILD_SHARED_LIBS}
    -DBUILD_STATIC_LIBS:BOOL=${hdf5_build_static_libs}
    -DDEFAULT_API_VERSION:STRING=v18
    -DHDF5_BUILD_CPP_LIB:BOOL=${hdf5cpp_enabled}
    -DHDF5_BUILD_TOOLS:BOOL=OFF
    -DHDF5_BUILD_UTILS:BOOL=OFF
    -DHDF5_BUILD_EXAMPLES:BOOL=OFF
    -DHDF5_ENABLE_PARALLEL:BOOL=${hdf5_mpi_supported}
    -DHDF5_ENABLE_Z_LIB_SUPPORT:BOOL=TRUE
    -DHDF5_ENABLE_SZIP_SUPPORT:BOOL=TRUE
    -DHDF5_ENABLE_SZIP_ENCODING:BOOL=TRUE
    -DSZIP_USE_EXTERNAL:BOOL=TRUE
    -DZLIB_USE_EXTERNAL:BOOL=TRUE
    -DHDF5_BUILD_HL_LIB:BOOL=TRUE
    -DHDF5_BUILD_WITH_INSTALL_NAME:BOOL=ON)

superbuild_add_extra_cmake_args(
  -DHDF5_ROOT:PATH=<INSTALL_DIR>)

superbuild_apply_patch(hdf5 fix-ext-pkg-find
  "Force proper logic for zlib and szip dependencies")
