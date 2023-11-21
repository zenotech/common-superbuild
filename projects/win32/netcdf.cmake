include("${CMAKE_CURRENT_LIST_DIR}/../netcdf.cmake")

# Fix linking to a shared hdf5 on Windows
superbuild_apply_patch(netcdf find-shared-hdf5
  "Link to HDF5 shared on Windows")

# Fix installation rules on Windows
superbuild_apply_patch(netcdf install-fixes
  "Hide globbing install rules")
