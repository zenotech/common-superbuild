set(numpy_process_environment)
if (lapack_enabled)
  list(APPEND numpy_process_environment
    BLAS    "${BLAS_LIBRARIES}"
    LAPACK  "${LAPACK_LIBRARIES}")
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

set(numpy_depends_optional)
if (NOT WIN32)
  set(numpy_depends_optional fortran lapack)
endif()

superbuild_add_project_python(numpy
  PACKAGE numpy
  CAN_USE_SYSTEM
  DEPENDS pythonsetuptools
  DEPENDS_OPTIONAL ${numpy_depends_optional}
  PROCESS_ENVIRONMENT
    MKL         "None"
    ATLAS       "None"
    ${numpy_process_environment})
