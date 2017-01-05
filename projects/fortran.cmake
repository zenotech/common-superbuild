superbuild_add_dummy_project(fortran)

if (fortran_enabled)
  enable_language(Fortran)
endif ()

superbuild_add_extra_cmake_args(
  -DCMAKE_Fortran_COMPILER:FILEPATH=${CMAKE_Fortran_COMPILER})
