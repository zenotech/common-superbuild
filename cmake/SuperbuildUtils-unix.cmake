include (CMakeDependentOption)

function (superbuild_unix_ld_library_path_hack var)
  # XXX(Utkarsh): I am not exactly sure about the cause of these issues and how
  # to cleanly overcome them, however, on some Linuxes when CMake is built
  # shared, if we set LD_LIBRARY_PATH to the install/lib dir, we end up with
  # errors due to conflicts with system libz. So for now, I am making this an
  # option. By default we will let the superbuild scripts set LD_LIBRARY_PATH.
  # However if users get errors like: libz.so.1: no version information
  # available, then users should turn this flag off.
  cmake_dependent_option(PASS_LD_LIBRARY_PATH_FOR_BUILDS "Pass LD_LIBRARY_PATH to build scripts" ON
    "UNIX;NOT APPLE" OFF)
  mark_as_advanced(PASS_LD_LIBRARY_PATH_FOR_BUILDS)

  if (PASS_LD_LIBRARY_PATH_FOR_BUILDS)
    set("${var}"
      LD_LIBRARY_PATH "${superbuild_ld_library_path}"
      PARENT_SCOPE)
  endif ()
endfunction ()
