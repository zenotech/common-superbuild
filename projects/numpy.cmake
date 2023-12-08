# Check to see if the build path is too short for the packages.
if (numpy_enabled AND UNIX AND NOT APPLE)
  string(LENGTH "${CMAKE_BINARY_DIR}" numpy_bindir_len)
  # Emperically determined. If longer paths still have the issue, raise this limit.
  if (numpy_bindir_len LESS 24)
    message(WARNING
      "Note that your build tree (${CMAKE_BINARY_DIR}) is too short for "
      "packaging (due to limited RPATH space in the header). Please use a "
      "longer build directory to avoid this problem. You may ignore it if you "
      "are not building packages.")
  endif ()
endif ()

set(numpy_process_environment)
if (lapack_enabled)
  list(APPEND numpy_process_environment
    BLAS    "<INSTALL_DIR>"
    LAPACK  "<INSTALL_DIR>"
    NPY_BLAS_ORDER blas
    NPY_LAPACK_ORDER lapack)
else()
  list(APPEND numpy_process_environment
    BLAS    "None"
    LAPACK  "None")
endif ()

if (fortran_enabled)
  list(APPEND numpy_process_environment
    FC "${CMAKE_Fortran_COMPILER}")
endif ()

set(numpy_fortran_compiler "no")
if (fortran_enabled)
  set(numpy_fortran_compiler "${CMAKE_Fortran_COMPILER}")
endif ()

set(numpy_python_build_args
  "--fcompiler=${numpy_fortran_compiler}")

set(numpy_depends)
set(numpy_depends_optional)
if (NOT WIN32)
  if (APPLE)
    # If `lapack` is not a hard requirement, we end up linking to
    # `Accelerate.framework` which is not wanted.
    list(APPEND numpy_depends
      lapack pkgconf)
  else ()
    list(APPEND numpy_depends_optional
      lapack)
  endif ()
  list(APPEND numpy_depends_optional
    fortran)
endif()

superbuild_add_project_python_pyproject(numpy
  PACKAGE numpy
  CAN_USE_SYSTEM
  DEPENDS
    pythoncython ${numpy_depends}
  DEPENDS_OPTIONAL ${numpy_depends_optional}
  LICENSE_FILES
    LICENSE.txt
  SPDX_LICENSE_IDENTIFIER
    BSD-3-Clause
  SPDX_COPYRIGHT_TEXT
    "Copyright (c) 2005-2023, NumPy Developers"
  PROCESS_ENVIRONMENT
    MKL         "None"
    ATLAS       "None"
    ${numpy_process_environment}
  REMOVE_MODULES
    numpy.array_api.tests
    numpy.compat.tests
    numpy.distutils.tests
    numpy.f2py.tests
    numpy.fft.tests
    numpy.lib.tests
    numpy.linalg.tests
    numpy.ma.tests
    numpy.matrixlib.tests
    numpy.polynomial.tests
    numpy.random._examples
    numpy.random.tests
    numpy.tests
    numpy.typing.tests
  )
