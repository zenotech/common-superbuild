superbuild_add_dummy_project(fortran)

if (fortran_enabled)
  enable_language(Fortran)
endif ()

superbuild_add_extra_cmake_args(
  -DCMAKE_Fortran_COMPILER:FILEPATH=${CMAKE_Fortran_COMPILER})

# Support adding Fortran-specific linker flags.
if (_superbuild_fortran_ld_flags)
  superbuild_append_flags(ld_flags "${_superbuild_fortran_ld_flags}")
endif ()
