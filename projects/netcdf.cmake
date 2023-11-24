set(netcdf_mpi_supported ${mpi_enabled})
if (_netcdf_disable_mpi_support)
  set(netcdf_mpi_supported OFF)
endif ()

superbuild_add_project(netcdf
  CAN_USE_SYSTEM
  DEPENDS hdf5 zlib
  DEPENDS_OPTIONAL mpi
  LICENSE_FILES
    COPYRIGHT
  SPDX_LICENSE_IDENTIFIER
    BSD-3-Clause
  SPDX_COPYRIGHT_TEXT
    "Copyright 2018 Unidata"
  CMAKE_ARGS
    -DCURL_INCLUDE_DIR:STRING=0
    -DCURL_LIBRARY:STRING=0

    # https://github.com/Unidata/netcdf-c/issues/2742
    -DHAVE_HDF5_ZLIB:BOOL=1
    -DUSE_HDF5_SZIP:BOOL=1

    -DBUILD_SHARED_LIBS:BOOL=${BUILD_SHARED_LIBS}
    -DNC_FIND_SHARED_LIBS:BOOL=${BUILD_SHARED_LIBS}
    -DBUILD_TESTING:BOOL=OFF
    -DCMAKE_INSTALL_NAME_DIR:PATH=<INSTALL_DIR>/lib
    -DENABLE_BYTERANGE:BOOL=OFF
    -DENABLE_DAP_REMOTE_TESTS:BOOL=OFF
    -DENABLE_EXAMPLES:BOOL=OFF
    -DENABLE_FILTER_TESTING:BOOL=OFF
    -DENABLE_NCZARR_FILTERS_TESTING:BOOL=OFF
    -DENABLE_PARALLEL4:BOOL=${netcdf_mpi_supported}
    -DENABLE_PARALLEL_TESTS:BOOL=OFF
    -DENABLE_TESTS:BOOL=OFF
    -DTEST_PARALLEL:BOOL=OFF
    -DBUILD_UTILITIES:BOOL=OFF
    -DUSE_SZIP:BOOL=OFF
    -DENABLE_DAP:BOOL=OFF
    -DENABLE_NCZARR:BOOL=OFF
    -DCMAKE_INSTALL_LIBDIR:BOOL=lib)

superbuild_apply_patch(netcdf fix-size-uchar
  "fix check on size of uchar: test for existence first")

superbuild_apply_patch(netcdf parallel-hdf5
  "link to MPI when using a parallel HDF5")

superbuild_apply_patch(netcdf find-hdf5
  "Find HDF5 when finding netCDF")
