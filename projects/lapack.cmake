set(lapack_environment)

# Set `-fallow-argument-mismatch` for gfortran 10+.
if (CMAKE_Fortran_COMPILER_ID STREQUAL "GNU" AND
    NOT CMAKE_Fortran_COMPILER_VERSION VERSION_LESS "10")
  list(APPEND lapack_environment
    FFLAGS -fallow-argument-mismatch)
endif ()

superbuild_add_project(lapack
  CAN_USE_SYSTEM
  DEPENDS fortran
  CMAKE_ARGS
    -DBUILD_SHARED_LIBS:BOOL=${BUILD_SHARED_LIBS}
    -DBUILD_TESTING:BOOL=OFF
    -DCMAKE_INSTALL_PREFIX:PATH=<INSTALL_DIR>
  PROCESS_ENVIRONMENT
    ${lapack_environment})
