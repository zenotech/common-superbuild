include("${CMAKE_CURRENT_LIST_DIR}/../netcdf.cmake")

# VS2015 support
superbuild_apply_patch(netcdf VS2015
  "Support Visual Studio 2015")
