string(REPLACE ")" "|PROCESS_ENVIRONMENT)"
  _ep_keywords_PVExternalProject_Add "${_ep_keywords_ExternalProject_Add}")

function (PVExternalProject_Add name)
  # now strip PROCESS_ENVIRONMENT from argments.
  set (skip TRUE)
  foreach(arg IN LISTS ARGN)
    if (arg MATCHES "${_ep_keywords_PVExternalProject_Add}")
      if (arg MATCHES "^(PROCESS_ENVIRONMENT|BUILD_COMMAND|INSTALL_COMMAND|CONFIGURE_COMMAND)$")
        set (skip FALSE)
      else()
        set (skip TRUE)
      endif ()
    endif()
    if (skip)
      list(APPEND new_argn ${arg})
    endif()
  endforeach()
  #new_argn has to be quoted to keep empty list elements around
  #so that we properly parse empty install, configure, build,  etc
  ExternalProject_Add(${name} "${new_argn}")

  # configure the scripts after the call ExternalProject_Add() since that sets
  # up the directories correctly.
  get_target_property(process_environment pv-${name}
    _EP_PROCESS_ENVIRONMENT)
  _ep_replace_location_tags(${name} process_environment)

  option(SUPPRESS_${name}_OUTPUT "Suppress output for ${name}" OFF)
  mark_as_advanced(SUPPRESS_${name}_OUTPUT)

  set(suppress "${SUPPRESS_${name}_OUTPUT}")

  if (has_configure_command)
    get_target_property(step_command pv-${name} _EP_CONFIGURE_COMMAND)
    _ep_replace_location_tags(${name} step_command)
    configure_file(${SuperBuild_CMAKE_DIR}/pep_configure.cmake.in
      ${CMAKE_CURRENT_BINARY_DIR}/pv-${name}-configure.cmake
      @ONLY
      )
  endif()

  if (has_build_command)
    get_target_property(step_command pv-${name} _EP_BUILD_COMMAND)
    _ep_replace_location_tags(${name} step_command)
    configure_file(${SuperBuild_CMAKE_DIR}/pep_configure.cmake.in
      ${CMAKE_CURRENT_BINARY_DIR}/pv-${name}-build.cmake
      @ONLY)
  endif()
endfunction()
