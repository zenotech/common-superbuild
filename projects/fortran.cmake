enable_language(Fortran)

superbuild_add_dummy_project(fortran)

superbuild_add_extra_cmake_args(
  -DCMAKE_Fortran_COMPILER:FILEPATH=${CMAKE_Fortran_COMPILER})
