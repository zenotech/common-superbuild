if (fortran_enabled)
  list(APPEND scipy_process_environment
    FC ${CMAKE_Fortran_COMPILER})
endif ()

superbuild_python_version_check(scipy
  "3.8" "0" # Unsupported
  "3.9" "1.13.1"
  "3.10" "1.15.0")

set(scipy_python_args)
if (scipy_SOURCE_SELECTION VERSION_GREATER_EQUAL "1.15.0")
  list(APPEND scipy_python_args
    -Csetup-args=-Dblas=blas
    -Csetup-args=-Dlapack=lapack)
endif ()

superbuild_add_project_python_pyproject(scipy
  PACKAGE scipy
  DEPENDS fortran numpy lapack pybind11 pythonpythran pythonmesonpython pythonwheel pkgconf
  LICENSE_FILES
    LICENSE.txt
  SPDX_LICENSE_IDENTIFIER
    BSD-3-Clause
  SPDX_COPYRIGHT_TEXT
    "Copyright (c) 2001-2002 Enthought, Inc. 2003-2023, SciPy Developers"
  PYTHON_ARGS
    ${scipy_python_args}
  PROCESS_ENVIRONMENT
    ${scipy_process_environment})

# Set `-fallow-argument-mismatch` for gfortran 10+.
if (CMAKE_Fortran_COMPILER_ID STREQUAL "GNU" AND
    NOT CMAKE_Fortran_COMPILER_VERSION VERSION_LESS "10")
  superbuild_append_flags(f_flags
    -fallow-argument-mismatch
    PROJECT_ONLY)
endif ()

if (scipy_SOURCE_SELECTION STREQUAL "1.15.0")
  # https://github.com/scipy/scipy/pull/22270
  superbuild_apply_patch(scipy 1.15.0-build-order-fixes
    "Fix missing build dependencies")
endif ()

if (scipy_SOURCE_SELECTION VERSION_LESS "1.15.0")
  superbuild_apply_patch(scipy use-blas-lapack
    "Use blas/lapack")

  # https://github.com/scipy/scipy/pull/19168
  superbuild_apply_patch(scipy meson-dependencies
    "Fix dependencies in Cython generation")
endif ()
