set(hdf5_build_static_libs ON)
if (BUILD_SHARED_LIBS)
  set(hdf5_build_static_libs OFF)
endif ()

if (mpi_enabled)
  set(hdf5_mpi_supported ON)
else ()
  set(hdf5_mpi_supported OFF)
endif ()
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
    SPDX_LICENSE_IDENTIFIER
      BSD-3-Clause
    SPDX_COPYRIGHT_TEXT
      "Copyright 2006 by The HDF Group."
      "Copyright 1998-2006 by The Board of Trustees of the University of Illinois."
      "Copyright (c) 2016, The Regents of the University of California, through Lawrence Berkeley National Laboratory (subject to receipt of any required approvals from the U.S. Dept. of Energy)."
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
    # The logic for the `_USE_EXTERNAL` flags is 100% backwards.
    -DSZIP_USE_EXTERNAL:BOOL=0
    -DZLIB_USE_EXTERNAL:BOOL=0
    -DHDF5_BUILD_HL_LIB:BOOL=TRUE
    -DHDF5_BUILD_WITH_INSTALL_NAME:BOOL=ON)

superbuild_add_extra_cmake_args(
  -DHDF5_ROOT:PATH=<INSTALL_DIR>)

superbuild_apply_patch(hdf5 fix-ext-pkg-find
  "Force proper logic for zlib and szip dependencies")

superbuild_apply_patch(hdf5 szip-library-variables
  "Link with the variables that szip provides")
