if (CMAKE_GENERATOR STREQUAL "Ninja")
  list(APPEND lapack_arguments
    CMAKE_GENERATOR "Unix Makefiles")
endif ()

# TODO: find fortran compiler.
superbuild_add_project(lapack
  CAN_USE_SYSTEM
  CMAKE_ARGS
    -DBUILD_SHARED_LIBS:BOOL=${BUILD_SHARED_LIBS}
    -DCMAKE_INSTALL_PREFIX:PATH=<INSTALL_DIR>
    -DCMAKE_Fortran_COMPILER:FILEPATH=${CMAKE_Fortran_COMPILER}
  ${lapack_arguments})
