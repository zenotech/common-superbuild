include("SuperbuildUtils-apple")
include("SuperbuildUtils-unix")

function (superbuild_detect_64bit_target)
  if (CROSS_BUILD_STAGE STREQUAL "cross")
    return ()
  endif ()

  # Collect information about the build platform.
  include(CheckTypeSize)

  check_type_size(void* void_ptr_size
    BUILTIN_TYPES_ONLY)
  if (void_ptr_size EQUAL 8)
    set(superbuild_is_64bit TRUE
      PARENT_SCOPE)
  else ()
    set(superbuild_is_64bit FALSE
      PARENT_SCOPE)
  endif ()
endfunction ()

function (superbuild_setup_flags)
  if (WIN32)
    return ()
  endif ()

  # FIXME: currently, if any of these are empty, we have build issues on Unix.
  set(superbuild_ldflags "$ENV{LDFLAGS} -L${superbuild_install_location}/lib"
    PARENT_SCOPE)
  set(superbuild_ld_library_path "${superbuild_install_location}/lib:$ENV{LD_LIBRARY_PATH}"
    PARENT_SCOPE)

  if (CROSS_BUILD_STAGE STREQUAL "cross")
    return ()
  endif ()

  set(superbuild_cpp_flags "$ENV{CPPFLAGS}")
  set(superbuild_cxx_flags "$ENV{CXXFLAGS} -fPIC")
  set(superbuild_c_flags "$ENV{CFLAGS} -fPIC")

  superbuild_osx_add_version_flags()

  foreach (var cpp_flags cxx_flags c_flags)
    set("superbuild_${var}"
      "${superbuild_${var}}"
      PARENT_SCOPE)
  endforeach ()
endfunction ()

function (superbuild_prepare_build_tree)
  if (WIN32)
    # Windows doesn't like it if that directory does not exist even if it is
    # empty.
    file(MAKE_DIRECTORY "${superbuild_install_location}/lib")
  endif ()
endfunction ()
