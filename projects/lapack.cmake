if(APPLE)
list(APPEND EXTRA_ARGS -DCMAKE_MACOSX_RPATH:BOOL=ON
  -DCMAKE_SKIP_BUILD_RPATH:BOOL=FALSE
  -DCMAKE_BUILD_WITH_INSTALL_RPATH:BOOL=FALSE
  -DCMAKE_INSTALL_RPATH:STRING=${superbuild_install_location}/lib
  -DCMAKE_INSTALL_RPATH_USE_LINK_PATH:BOOL=TRUE)
endif()
set(lapack_environment)

superbuild_add_project(lapack
  CAN_USE_SYSTEM
  DEPENDS fortran
  LICENSE_FILES
    LICENSE
  SPDX_LICENSE_IDENTIFIER
    BSD-3-Clause
  SPDX_COPYRIGHT_TEXT
    "Copyright (c) 1992-2022 The University of Tennessee and The University of Tennessee Research Foundation"
    "Copyright (c) 2000-2022 The University of California Berkeley"
    "Copyright (c) 2006-2022 The University of Colorado Denver"
  CMAKE_ARGS
    -DBUILD_SHARED_LIBS:BOOL=${BUILD_SHARED_LIBS}
    -DBUILD_TESTING:BOOL=OFF
    -DCBLAS:BOOL=ON
    -DCMAKE_INSTALL_PREFIX:PATH=<INSTALL_DIR>
    -DCMAKE_INSTALL_NAME_DIR:STRING=<INSTALL_DIR>/lib
    -DCMAKE_INSTALL_LIBDIR:STRING=lib
    ${EXTRA_ARGS}
  PROCESS_ENVIRONMENT
    ${lapack_environment})

# Set `-fallow-argument-mismatch` for gfortran 10+.
if (CMAKE_Fortran_COMPILER_ID STREQUAL "GNU" AND
    NOT CMAKE_Fortran_COMPILER_VERSION VERSION_LESS "10")
  superbuild_append_flags(f_flags
    -fallow-argument-mismatch
    PROJECT_ONLY)
endif ()
