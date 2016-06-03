# This file implements the logic to inject environment variables into the build
# steps of projects. It is quite messy.

if (CMAKE_VERSION VERSION_LESS "3.4"
    OR TRUE) # Patches exist which aren't upstreamed yet.
  # Needed for fixes.
  include("${CMAKE_CURRENT_LIST_DIR}/patches/ExternalProject.cmake")
else ()
  include(ExternalProject)
endif ()

# Because of the wrapped and nested way that "make" needs to get called, it's
# not able to utilize the top level make jobserver so it's -j level must be
# manually controlled.
include(ProcessorCount)
processorcount(superbuild_cpu_count)
if (NOT superbuild_cpu_count)
  set(SUPERBUILD_NCPUS 8)
endif ()

set(SUPERBUILD_PROJECT_PARALLELISM "${superbuild_cpu_count}"
  CACHE STRING "Number of jobs to use when compiling subprojects")
mark_as_advanced(SUPERBUILD_PROJECT_PARALLELISM)

set(superbuild_make_program "make")
if (CMAKE_GENERATOR MATCHES "Makefiles")
  set(superbuild_make_program "${CMAKE_MAKE_PROGRAM}")
endif ()

# Add "PROCESS_ENVIRONMENT" to the list of keywords recognized.
string(REPLACE ")" "|PROCESS_ENVIRONMENT)"
  _ep_keywords__superbuild_ExternalProject_add "${_ep_keywords_ExternalProject_Add}")

# Version of the function which strips PROCESS_ENVIRONMENT arguments for
# ExternalProject_Add.
function (_superbuild_ep_strip_extra_arguments name)
  set(arguments)
  set(accumulate FALSE)

  foreach (arg IN LISTS ARGN)
    if (arg STREQUAL "PROCESS_ENVIRONMENT")
      set(skip TRUE)
    elseif (arg MATCHES "${_ep_keywords_ExternalProject_Add}")
      set(skip FALSE)
    endif ()

    if (NOT skip)
      list(APPEND arguments "${arg}")
    endif ()
  endforeach ()

  ExternalProject_Add("${name}" "${arguments}")
endfunction ()

function (_superbuild_ep_wrap_command var target command_name)
  get_property(has_command TARGET "${target}"
    PROPERTY "_EP_${command_name}_COMMAND" SET)
  set("has_${var}"
    "${has_command}"
    PARENT_SCOPE)

  get_property(command TARGET "${target}"
    PROPERTY "_EP_${command_name}_COMMAND")

  if (NOT has_command)
    if (command_name STREQUAL "CONFIGURE")
      _ep_extract_configure_command(command "${target}")
      if (command)
        set(has_command 1)
      endif ()
    else ()
      # Get the ExternalProject-generated command.
      _ep_get_build_command("${target}" "${command_name}" command)
      set(has_command 1)
    endif ()
  endif ()

  # Replace $(MAKE) usage.
  set(submake_regex "^\\$\\(MAKE\\)")
  if (command MATCHES "${submake_regex}")
    string(REGEX REPLACE "${submake_regex}" "${superbuild_make_program};-j${SUPERBUILD_PROJECT_PARALLELISM}" command "${command}")
  endif ()

  if (command)
    string(TOLOWER "${command_name}" step)
    set(new_command
      "${CMAKE_COMMAND}" -P
      "${CMAKE_CURRENT_BINARY_DIR}/${target}-${step}.cmake")
  else ()
    set(has_command 0)
  endif ()

  set("original_${var}"
    "${command}"
    PARENT_SCOPE)
  set("${var}"
    "${command_name}_COMMAND" "${new_command}"
    PARENT_SCOPE)

  set("req_${var}"
    "${has_command}"
    PARENT_SCOPE)
endfunction ()

function (_superbuild_ExternalProject_add name)
  # Create a temporary target so we can query target properties.
  add_custom_target("sb-${name}")
  _ep_parse_arguments(_superbuild_ExternalProject_add "sb-${name}" _EP_ "${ARGN}")

  get_property(has_process_environment TARGET "sb-${name}"
    PROPERTY _EP_PROCESS_ENVIRONMENT SET)
  if (NOT has_process_environment)
    _superbuild_ep_strip_extra_arguments(${name} "${ARGN}")
    return ()
  endif ()

  _superbuild_ep_wrap_command(configure_command "sb-${name}" CONFIGURE)
  _superbuild_ep_wrap_command(build_command     "sb-${name}" BUILD)
  _superbuild_ep_wrap_command(install_command   "sb-${name}" INSTALL)

  set(args)
  if (has_configure_command OR req_configure_command)
    list(APPEND args
      "${configure_command}")
  endif ()
  if (has_build_command OR req_build_command)
    list(APPEND args
      "${build_command}")
  endif ()
  list(APPEND args
    "${install_command}")

  # Now strip PROCESS_ENVIRONMENT and commands from arguments.
  set(skip FALSE)
  foreach (arg IN LISTS ARGN)
    if (arg MATCHES "${_ep_keywords__superbuild_ExternalProject_add}")
      if (arg MATCHES "^(PROCESS_ENVIRONMENT|BUILD_COMMAND|INSTALL_COMMAND|CONFIGURE_COMMAND)$")
        set(skip TRUE)
      else ()
        set(skip FALSE)
      endif ()
    endif ()
    if (NOT skip)
      list(APPEND args
        "${arg}")
    endif ()
  endforeach ()

  set(suppress_default OFF)
  if (DEFINED "_superbuild_suppress_${name}_output")
    set(suppress_default "${_superbuild_suppress_${name}_output}")
  endif ()

  # Add option to dump the output to a file. This keeps it hidden from CTest if
  # it just cannot be silenced.
  option("SUPPRESS_${name}_OUTPUT" "Suppress output for ${name}" "${suppress_default}")
  mark_as_advanced("SUPPRESS_${name}_OUTPUT")

  if (SUPPRESS_${name}_OUTPUT)
    # Silence the build and install steps.
    list(APPEND args
      LOG_BUILD   1
      LOG_INSTALL 1)
  endif ()

  # Quote args to keep empty list elements around so that we properly parse
  # empty install, configure, build, etc.
  ExternalProject_Add("${name}" "${args}")

  # Configure the scripts after the call ExternalProject_Add() since that sets
  # up the directories correctly.
  get_target_property(process_environment "sb-${name}"
    _EP_PROCESS_ENVIRONMENT)
  _ep_replace_location_tags("${name}" process_environment)

  foreach (step IN ITEMS configure build install)
    if (req_${step}_command)
      string(TOUPPER "${step}" step_upper)

      set(step_command "${original_${step}_command}")
      _ep_replace_location_tags("${name}" step_command)

      configure_file(
        "${CMAKE_CURRENT_LIST_DIR}/cmake/superbuild_handle_environment.cmake.in"
        "${CMAKE_CURRENT_BINARY_DIR}/sb-${name}-${step}.cmake"
        @ONLY)
    endif ()
  endforeach ()
endfunction ()
