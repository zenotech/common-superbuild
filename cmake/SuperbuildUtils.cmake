include("SuperbuildUtils-apple")
include("SuperbuildUtils-unix")

if (NOT CMAKE_CONFIGURATION_TYPES)
  set(_superbuild_build_type_force)
  if (NOT CMAKE_BUILD_TYPE)
    set(_superbuild_build_type_force FORCE)
  endif ()
  set(CMAKE_BUILD_TYPE "Release"
    CACHE STRING "The build mode" ${_superbuild_build_type_force})
  mark_as_advanced(CMAKE_BUILD_TYPE)
  set_property(CACHE CMAKE_BUILD_TYPE
    PROPERTY
      STRINGS "Release;RelWithDebInfo;Debug")

  if (NOT CMAKE_BUILD_TYPE)
    message(FATAL_ERROR "A build type (CMAKE_BUILD_TYPE) must be set.")
  endif ()

  if (CMAKE_BUILD_TYPE STREQUAL "Debug" AND NOT SUPERBUILD_ALLOW_DEBUG)
    message(FATAL_ERROR
      "Debug builds are probably not what you want. "
      "Set the SUPERBUILD_ALLOW_DEBUG variable using "
      "either the GUI ('Add Entry') or pass "
      "-DSUPERBUILD_ALLOW_DEBUG:BOOL=ON on the command "
      "to indicate this is what you intended.")
  endif ()
endif ()

function (superbuild_detect_64bit_target)
  if (CMAKE_CROSSCOMPILING)
    return ()
  endif ()

  # Collect information about the build platform.
  include(CheckTypeSize)

  check_type_size(void* void_ptr_size
    BUILTIN_TYPES_ONLY)
  if (void_ptr_size EQUAL 8)
    set(superbuild_is_64bit TRUE
      PARENT_SCOPE)
  elseif (void_ptr_size EQUAL 4)
    set(superbuild_is_64bit FALSE
      PARENT_SCOPE)
  else ()
    if (WIN32)
      set(extra_message "Are you in a Visual Studio command prompt?")
    else ()
      set(extra_message "Do you have working compilers?")
    endif ()
    message(FATAL_ERROR "Failed to determine whether the target architecture "
                        "is 32bit or 64bit. ${extra_message}")
  endif ()
endfunction ()

function (superbuild_setup_flags)
  if (WIN32)
    return ()
  endif ()

  set(ld_library_path "${superbuild_install_location}/lib")
  if (ENV{LD_LIBRARY_PATH})
    list(APPEND ld_library_path "$ENV{LD_LIBRARY_PATH}")
  endif ()
  string(REPLACE ";" ":" ld_library_path "${ld_library_path}")
  set(superbuild_ld_library_path "${ld_library_path}"
    PARENT_SCOPE)

  if (CMAKE_CROSSCOMPILING)
    return ()
  endif ()

  set(superbuild_cpp_flags "$ENV{CPPFLAGS} ${superbuild_extra_cpp_flags}")
  set(superbuild_cxx_flags "$ENV{CXXFLAGS} -fPIC ${superbuild_extra_cxx_flags}")
  set(superbuild_c_flags "$ENV{CFLAGS} -fPIC ${superbuild_extra_c_flags}")

  superbuild_osx_add_version_flags()

  foreach (var IN ITEMS cpp_flags cxx_flags c_flags)
    set("superbuild_${var}"
      "${superbuild_${var}}"
      PARENT_SCOPE)
  endforeach ()
endfunction ()

macro (superbuild_prepare_build_tree)
  if (WIN32)
    # Windows doesn't like it if that directory does not exist even if it is
    # empty.
    file(MAKE_DIRECTORY "${superbuild_install_location}/lib")
  endif ()

  set(_superbuild_module_gen_dir "${CMAKE_CURRENT_BINARY_DIR}/CMakeFiles/cmake")
  file(MAKE_DIRECTORY "${_superbuild_module_gen_dir}")
  list(APPEND CMAKE_MODULE_PATH
    "${_superbuild_module_gen_dir}")
endmacro ()
