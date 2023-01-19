set(netcdf_libdir)
if (UNIX AND NOT APPLE)
  set(netcdf_libdir
    -DCMAKE_INSTALL_LIBDIR:BOOL=lib)
endif ()

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
  CMAKE_ARGS
    -DBUILD_SHARED_LIBS:BOOL=${BUILD_SHARED_LIBS}
    -DNC_FIND_SHARED_LIBS:BOOL=${BUILD_SHARED_LIBS}
    -DBUILD_TESTING:BOOL=OFF
    -DCMAKE_INSTALL_NAME_DIR:PATH=<INSTALL_DIR>/lib
    -DENABLE_PARALLEL4:BOOL=${netcdf_mpi_supported}
    -DENABLE_PARALLEL_TESTS:BOOL=OFF
    -DENABLE_TESTS:BOOL=OFF
    -DTEST_PARALLEL:BOOL=OFF
    -DBUILD_UTILITIES:BOOL=OFF
    -DUSE_SZIP:BOOL=OFF
    -DENABLE_DAP:BOOL=OFF
    -DENABLE_NCZARR:BOOL=OFF
    ${netcdf_libdir})

superbuild_apply_patch(netcdf fix-size-uchar
  "fix check on size of uchar: test for existence first")

superbuild_apply_patch(netcdf parallel-hdf5
  "link to MPI when using a parallel HDF5")

# Remove once https://github.com/Unidata/netcdf-c/pull/2592/files is merged
superbuild_apply_patch(netcdf remove-zip-dep
  "remove unneeded zip dependency")
