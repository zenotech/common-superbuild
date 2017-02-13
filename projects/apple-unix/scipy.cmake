set(scipy_process_environment)
if (lapack_enabled)
  list(APPEND scipy_process_environment
    MKL     "None"
    ATLAS   "None"
    BLAS    "<INSTALL_DIR>/lib"
    LAPACK  "<INSTALL_DIR>/lib")
endif ()

if (fortran_enabled)
  list(APPEND scipy_process_environment
    FC ${CMAKE_Fortran_COMPILER})
endif ()

superbuild_add_project(scipy
  DEPENDS python fortran numpy lapack
  BUILD_IN_SOURCE 1
  CONFIGURE_COMMAND ""
  BUILD_COMMAND
    ${superbuild_python_executable}
      setup.py
      config_fc
      "--f90exec=${CMAKE_Fortran_COMPILER}"
      build
  INSTALL_COMMAND
    ${superbuild_python_executable}
      setup.py
      install
      --prefix=<INSTALL_DIR>
  PROCESS_ENVIRONMENT
    PYTHONPATH "<INSTALL_DIR>/lib/python2.7/site-packages"
    ${scipy_process_environment})

# The superbuild setting LDFLAGS (even to empty) causes SciPy to not add its
# flags, so add required flags manually.
if (APPLE)
  # Scipy does not link libpython directly, but instead looks for them at load
  # time.
  superbuild_append_flags(ld_flags "-undefined dynamic_lookup" PROJECT_ONLY)
elseif (CMAKE_Fortran_COMPILER_ID STREQUAL "GNU")
  superbuild_append_flags(ld_flags "-shared" PROJECT_ONLY)
endif ()
