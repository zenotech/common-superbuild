if (fortran_enabled)
  list(APPEND scipy_process_environment
    FC ${CMAKE_Fortran_COMPILER})
endif ()

superbuild_add_project_python_pyproject(scipy
  PACKAGE scipy
  DEPENDS fortran numpy lapack pybind11 pythonpythran pythonmesonpython pythonwheel pkgconf
  LICENSE_FILES
    LICENSE.txt
  PROCESS_ENVIRONMENT
    ${scipy_process_environment})

# Set `-fallow-argument-mismatch` for gfortran 10+.
if (CMAKE_Fortran_COMPILER_ID STREQUAL "GNU" AND
    NOT CMAKE_Fortran_COMPILER_VERSION VERSION_LESS "10")
  superbuild_append_flags(f_flags
    -fallow-argument-mismatch
    PROJECT_ONLY)
endif ()

superbuild_apply_patch(scipy use-blas-lapack
  "Use blas/lapack")

# https://github.com/scipy/scipy/pull/19168
superbuild_apply_patch(scipy meson-dependencies
  "Fix dependencies in Cython generation")
