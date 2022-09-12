superbuild_add_project(cgns
  DEPENDS hdf5
  DEPENDS_OPTIONAL mpi
  LICENSE_FILES
    license.txt
  CMAKE_ARGS
    -DCGNS_BUILD_CGNSTOOLS:BOOL=OFF
    -DCGNS_BUILD_TESTING:BOOL=OFF
    -DCGNS_ENABLE_HDF5:BOOL=${hdf5_enabled}
    -DCGNS_ENABLE_TESTS:BOOL=OFF
    -DHDF5_NEED_MPI:BOOL=${mpi_enabled})

superbuild_apply_patch(cgns hdf5-versioning
  "Fix HDF5 structure versioning")
