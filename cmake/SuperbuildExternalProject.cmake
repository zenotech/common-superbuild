# Extends ExternalProject_Add(...) by adding a new option.
#  PROCESS_ENVIRONMENT <environment variables>
# When present the BUILD_COMMAND and CONFIGURE_COMMAND are executed as a
# sub-process (using execute_process()) so that the sepecified environment
# is passed on to the executed command (which does not happen by default).
# This will be deprecated once CMake starts supporting it.

include(ExternalProject)

if (CMAKE_GENERATOR MATCHES "Makefiles")
  # Because of the wrapped and nested way that "make" needs to get called, it's
  # not able to utilize the top level make jobserver so it's -j level must be
  # manually controlled.
  set(SUPERBUILD_PROJECT_PARALLELISM 5
    CACHE STRING "Number of jobs to use when compiling subprojects")
  mark_as_advanced(SUPERBUILD_PROJECT_PARALLELISM)

  # Parallelism isn't support for cross builds or toolchain builds.
  if (superbuild_is_cross)
    set(SUPERBUILD_PROJECT_PARALLELISM 1)
  endif ()
endif ()

#------------------------------------------------------------------------------
# Version of the function which strips PROCESS_ENVIRONMENT and CAN_USE_SYSTEM
# arguments for ExternalProject_Add.
function (_superbuild_ep_strip_extra_arguments name)
  set(arguments)
  set(accumulate FALSE)

  foreach (arg IN LISTS ARGN)
    if (arg STREQUAL "PROCESS_ENVIRONMENT" OR
        arg STREQUAL "CAN_USE_SYSTEM")
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
