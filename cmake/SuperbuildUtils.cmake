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

macro(superbuild_make_path_var var)
  set(${var} ${ARGN})
  list(REMOVE_ITEM ${var} "")
  if (UNIX)
    string(REPLACE ";" ":" ${var} "${${var}}")
  endif ()
endmacro()

function (superbuild_setup_flags)
  if (WIN32)
    return ()
  endif ()

  superbuild_make_path_var(superbuild_ld_library_path
    "${superbuild_install_location}/lib"
    "$ENV{LD_LIBRARY_PATH}")
  set(superbuild_ld_library_path "${superbuild_ld_library_path}" PARENT_SCOPE)

  superbuild_make_path_var(superbuild_pkg_config_path
    "${superbuild_install_location}/lib/pkgconfig"
    "${superbuild_install_location}/share/pkgconfig"
    "$ENV{PKG_CONFIG_PATH}")
  set(superbuild_pkg_config_path "${superbuild_pkg_config_path}" PARENT_SCOPE)

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

# Bridge an old, deprecated, setting to a new replacement setting.
#
# Use this function when a user-visible flag is being renamed or otherwise
# replaced. If the old value is set, it will be given as the default value,
# otherwise the given default value will be used. This returned value should
# then be used in the ``set(CACHE)`` or ``option()`` call for the new value.
#
# If the old value is set, it will warn that it is deprecated for the new name.
#
# If replacing the setting ``OLD_SETTING`` with ``NEW_SETTING``, its usage
# would look like:
#
#   superbuild_deprecated_setting(default_setting NEW_SETTING OLD_SETTING "default value")
#   set(NEW_SETTING "${default_setting}"
#     CACHE STRING "Documentation for the setting.")
function (superbuild_deprecated_setting output_default new old intended_default)
  set(default "${intended_default}")
  if (DEFINED "${old}")
    message(WARNING "The '${old}' variable is deprecated for '${new}'.")
    set(default "${${old}}")
  endif ()

  set("${output_default}" "${default}" PARENT_SCOPE)
endfunction ()
