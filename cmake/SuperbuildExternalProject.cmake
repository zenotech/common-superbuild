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
