superbuild_add_project(hdf5
  CAN_USE_SYSTEM
  DEPENDS zlib szip

  CMAKE_ARGS
    -DBUILD_SHARED_LIBS:BOOL=${BUILD_SHARED_LIBS}
    -DHDF5_ENABLE_Z_LIB_SUPPORT:BOOL=TRUE
    -DHDF5_ENABLE_SZIP_SUPPORT:BOOL=TRUE
    -DHDF5_ENABLE_SZIP_ENCODING:BOOL=TRUE
    -DHDF5_BUILD_HL_LIB:BOOL=TRUE
    -DHDF5_BUILD_WITH_INSTALL_NAME:BOOL=ON)

if (WIN32)
  set(hdf5_cmake_subdir "cmake/hdf5")
else ()
  set(hdf5_cmake_subdir "share/cmake/hdf5")
endif ()

superbuild_add_extra_cmake_args(
  "-DHDF5_DIR:PATH=<INSTALL_DIR>/${hdf5_cmake_subdir}")

# HDF5 on Windows installs a zlib that gets found this way; avoid using it.
superbuild_apply_patch(hdf5 no-zlib-config
  "Do not use a system zlib-config.cmake file")
