include("SuperbuildUtils-apple")

function (superbuild_detect_64bit_target)
  if (CROSS_BUILD_STAGE STREQUAL "cross")
    return ()
  endif ()

  # Collect information about the build platform.
  include(CheckTypeSize)

  check_type_size(void* void_ptr_size
    BUILTIN_TYPES_ONLY)
  if (void_ptr_size EQUAL 8)
    set(64bit_build TRUE
      PARENT_SCOPE)
  else ()
    set(64bit_build FALSE
      PARENT_SCOPE)
  endif ()
endfunction ()
