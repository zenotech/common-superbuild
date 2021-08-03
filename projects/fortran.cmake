superbuild_add_dummy_project(fortran)

if (fortran_enabled)
  enable_language(Fortran)
endif ()

superbuild_add_extra_cmake_args(
  -DCMAKE_Fortran_COMPILER:FILEPATH=${CMAKE_Fortran_COMPILER})

if (APPLE AND
    NOT EXISTS "/usr/lib/libSystem.dylib" AND
    NOT EXISTS "/usr/lib/libSystem.tbd")
  # macOS 11.5+ no longer ships with `libSystem.dylib` in `/usr/lib`, so
  # `gfortran` cannot find it when linking. Help it out as best we can.
  set(fortran_libsystem_path)
  if (EXISTS "${CMAKE_OSX_SYSROOT}/usr/lib/libSystem.tbd")
    set(fortran_libsystem_path
      "${CMAKE_OSX_SYSROOT}/usr/lib")
  endif ()

  if (fortran_libsystem_path)
    string(APPEND _superbuild_fortran_ld_flags
      " -L${fortran_libsystem_path}")
  endif ()
endif ()

# Support adding Fortran-specific linker flags.
if (_superbuild_fortran_ld_flags)
  superbuild_append_flags(ld_flags "${_superbuild_fortran_ld_flags}")
endif ()
