include("${CMAKE_CURRENT_LIST_DIR}/../netcdf.cmake")

# Fix wrong name of win32 into _win32
superbuild_apply_patch(netcdf fix-_win32-name
  "Replace win32 with _win32")

# Fix linking to a shared hdf5 on Windows
superbuild_apply_patch(netcdf find-shared-hdf5
  "Link to HDF5 shared on Windows")

# Fix installation rules on Windows
superbuild_apply_patch(netcdf install-fixes
  "Hide globbing install rules")
