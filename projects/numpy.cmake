set(numpy_process_environment)
if (lapack_enabled)
  list(APPEND numpy_process_environment
    MKL     "None"
    ATLAS   "None"
    BLAS    "${BLAS_LIBRARIES}"
    LAPACK  "${LAPACK_LIBRARIES}")
endif ()

# If any variables are set, we must have the PROCESS_ENVIRONMENT keyword
if (numpy_process_environment)
  list(INSERT numpy_process_environment 0
    PROCESS_ENVIRONMENT)
endif ()

set(numpy_fortran_compiler "no")
if (fortran_enabled)
  set(numpy_fortran_compiler "${CMAKE_Fortran_COMPILER}")
endif ()

superbuild_add_project(numpy
  CAN_USE_SYSTEM
  DEPENDS python
  DEPENDS_OPTIONAL fortran lapack
  BUILD_IN_SOURCE 1
  CONFIGURE_COMMAND ""
  BUILD_COMMAND
    ${superbuild_python_executable}
      setup.py
      build
      "--fcompiler=${numpy_fortran_compiler}"
  INSTALL_COMMAND
    ${superbuild_python_executable}
      setup.py
      install
      --install-lib=<INSTALL_DIR>/lib/python2.7/site-packages
      --prefix=<INSTALL_DIR>
  ${numpy_process_environment})
