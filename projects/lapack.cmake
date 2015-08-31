if (CMAKE_GENERATOR STREQUAL "Ninja")
  list(APPEND lapack_arguments
    CMAKE_GENERATOR "Unix Makefiles")
endif ()

superbuild_add_project(lapack
  CAN_USE_SYSTEM
  DEPENDS fortran
  CMAKE_ARGS
    -DBUILD_SHARED_LIBS:BOOL=${BUILD_SHARED_LIBS}
    -DCMAKE_INSTALL_PREFIX:PATH=<INSTALL_DIR>
  ${lapack_arguments})
