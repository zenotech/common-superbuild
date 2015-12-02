include("${CMAKE_CURRENT_LIST_DIR}/../hdf5.cmake")

# On Windows, find_package(HDF5) with cmake 2.8.[8,9] always ends up finding
# the dlls instead of the libs. So setting the variables explicitly for
# dependent projects.
superbuild_add_extra_cmake_args(
  -DHDF5_C_LIBRARY:FILEPATH=${install_location}/lib/hdf5.lib
  -DHDF5_HL_LIBRARY:FILEPATH=${install_location}/lib/hdf5_hl.lib
  # This variable is for CGNS, since CGNS doesn't use standard find_package()
  # to find hdf5.
  -DHDF5_LIBRARY:FILEPATH=${install_location}/lib/hdf5.lib
  # These variables are for netcdf
  -DHDF5_LIB:FILEPATH=${install_location}/lib/hdf5.lib
  -DHDF5_HL_LIB:FILEPATH=${install_location}/lib/hdf5_hl.lib
  -DHDF5_INCLUDE_DIR:FILEPATH=${install_location}/include)

if (NOT superbuild_is_64bit)
  # On 32-bit Windows, H5public.h ends up redefining ssize_t. This patch ensures
  # that the old definition is undef-ed before redefining it.
  superbuild_apply_patch(hdf5 fix-ssize_t-redefine
    "Fix ssize_t redefinition on 32-bit Windows")
endif ()

if (MSVC)
  # hdf5 has a bug with MSVC compiler where it doesn't realize its using MSVC
  # compiler when using nmake or ninja generators. This patch fixes that.
  superbuild_apply_patch(hdf5 msvc-non-vs-generator
    "Fix MSVC detection with Makefiles and Ninja generators")
endif ()
