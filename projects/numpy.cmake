set(numpy_process_environment)
if (lapack_enabled)
  if (NOT LAPACK_FOUND)
    find_package(LAPACK REQUIRED)
  endif ()
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

superbuild_add_project(numpy
  CAN_USE_SYSTEM
  DEPENDS python
  BUILD_IN_SOURCE 1
  CONFIGURE_COMMAND ""
  BUILD_COMMAND
    ${superbuild_python_executable}
      setup.py
      build
      --fcompiler=no
  INSTALL_COMMAND
    ${superbuild_python_executable}
      setup.py
      install
      --prefix=<INSTALL_DIR>
  ${numpy_process_environment})
