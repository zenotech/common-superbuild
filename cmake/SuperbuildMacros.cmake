include(SuperbuildExternalProject)
include(CMakeParseArguments)

#------------------------------------------------------------------------------
function (superbuild_add_project name)
  _superbuild_project_check_name("${name}")

  if (superbuild_build_phase)
    set(arguments)
    set(optional_depends)
    set(accumulate FALSE)

    foreach (arg IN LISTS ARGN)
      if (arg STREQUAL "DEPENDS_OPTIONAL")
        set(accumulate TRUE)
      elseif (arg MATCHES "${_ep_keywords_ExternalProject_Add}")
        set(accumulate FALSE)
      elseif (accumulate)
        list(APPEND optional_depends
          "${arg}")
      endif ()

      if (NOT accumulate)
        list(APPEND arguments
          "${arg}")
      endif ()
    endforeach ()

    foreach (op_dep IN LISTS optional_depends)
      if (${op_dep}_enabled)
        list(APPEND arguments
          DEPENDS "${op_dep}")
      endif ()
    endforeach ()
    set("${name}_arguments"
      "${arguments}"
      PARENT_SCOPE)
  else ()
    set(flags
      CAN_USE_SYSTEM)
    set(keys
      DEPENDS DEPENDS_OPTIONAL)
    cmake_parse_arguments(_args "${flags}" "${keys}" "" ${ARGN})

    option("ENABLE_${name}" "Request to build project ${name}" OFF)
    # Set the TYPE because it is overrided to INTERNAL if it is required by
    # dependencies later.
    set_property(CACHE "ENABLE_${project}" PROPERTY TYPE BOOL)
    set_property(GLOBAL APPEND
      PROPERTY
        superbuild_projects "${name}")

    if (_args_CAN_USE_SYSTEM)
      set_property(GLOBAL
        PROPERTY
          "${name}_system" TRUE)
      if (USE_SYSTEM_${name})
        set(_args_DEPENDS "")
        set(_args_DEPENDS_OPTIONAL "")
      endif ()
    endif ()

    set_property(GLOBAL
      PROPERTY
        "${name}_depends" ${_args_DEPENDS})
    set_property(GLOBAL
      PROPERTY
        "${name}_depends_optional" ${_args_DEPENDS_OPTIONAL})
  endif ()
endfunction ()

#------------------------------------------------------------------------------
# adds a dummy project to the build, which is a great way to setup a list
# of dependencies as a build option. IE dummy project that turns on all
# third party libraries
function (superbuild_add_dummy_project _name)
  superbuild_add_project(${_name} "${ARGN}")

  set_property(GLOBAL
    PROPERTY
      "${_name}_is_dummy" TRUE)
endfunction ()

function (superbuild_add_extra_cmake_args)
  if (NOT superbuild_build_phase)
    return ()
  endif ()

  _superbuild_check_current_project("add_extra_cmake_args")

  set_property(GLOBAL APPEND
    PROPERTY
      "${current_project}_cmake_args" ${ARGN})
endfunction ()

#------------------------------------------------------------------------------
function (superbuild_project_add_step name)
  if (NOT superbuild_build_phase)
    return ()
  endif ()

  _superbuild_check_current_project("add_external_project_step")

  set_property(GLOBAL APPEND
    PROPERTY
      "${current_project}_steps" "${name}")
  set_property(GLOBAL
    PROPERTY
      "${current_project}_step_${name}" ${ARGN})
endfunction ()

#------------------------------------------------------------------------------
# In case of OpenMPI on Windows, for example, we need to pass extra compiler
# flags when building projects that use MPI. This provides an experimental
# mechanism for the same.
# There are two kinds of flags, those to use to build to the project itself, or
# those to use to build any dependencies. The default is the latter. For former,
# pass in an optional argument PROJECT_ONLY.
function (superbuild_append_flags key value)
  if (NOT "x${key}" STREQUAL "xCMAKE_CXX_FLAGS" AND
      NOT "x${key}" STREQUAL "xCMAKE_C_FLAGS" AND
      NOT "x${key}" STREQUAL "xLDFLAGS")
    message(AUTHOR_WARNING
      "Currently, only CMAKE_CXX_FLAGS, CMAKE_C_FLAGS, and LDFLAGS are supported.")
  endif ()

  set(project_only FALSE)
  foreach (arg IN LISTS ARGN)
    if (arg STREQUAL "PROJECT_ONLY")
      set(project_only TRUE)
    else ()
      message(AUTHOR_WARNING "Unknown argument to append_flags(), ${arg}.")
    endif ()
  endforeach ()

  if (build-projects)
    _superbuild_check_current_project("append_flags")

    set(property "${current_project}_append_flags_${key}")
    if (project_only)
      set(property "${current_project}_append_project_only_flags_${key}")
    endif ()

    set_property(GLOBAL APPEND
      PROPERTY
        "${property}" "${value}")
  endif ()
endfunction ()

#------------------------------------------------------------------------------
# Get dependencies for a project, including optional dependencies that are
# currently enabled. Since this macro looks at the ${mod}_enabled flag, it
# cannot be used in the 'processing' pass, but the 'build' pass alone.
function (superbuild_get_project_depends name prefix)
  if (NOT superbuild_build_phase)
    message(AUTHOR_WARNING "get_project_depends can only be used in build pass")
  endif ()

  if (${prefix}_${_name}_done)
    return ()
  endif ()
  set(${prefix}_${_name}_done TRUE)

  # Get regular dependencies.
  foreach (dep IN LISTS "${name}_depends")
    if (NOT ${prefix}_${dep}_done)
      list(APPEND "${prefix}_depends"
        "${dep}")
      superbuild_get_project_depends("${dep}" "${prefix}")
    endif ()
  endforeach ()

  # Get enabled optional dependencies.
  foreach (dep IN LISTS "${name}_depends_optional")
    if (${dep}_enabled AND NOT ${prefix}_${dep}_done)
      list(APPEND "${prefix}_depends"
        "${dep}")
      superbuild_get_project_depends("${dep}" "${prefix}")
    endif ()
  endforeach ()

  if (${prefix}_depends)
    list(REMOVE_DUPLICATES "${prefix}_depends")
  endif ()
  set("${prefix}_depends"
    "${${prefix}_depends}"
    PARENT_SCOPE)
endfunction ()

#------------------------------------------------------------------------------
function (superbuild_process_dependencies)
  set (enabled_projects)

  get_property(all_projects GLOBAL
    PROPERTY superbuild_projects)
  foreach(project IN LISTS all_projects)
    get_property("${project}_depends" GLOBAL
      PROPERTY "${project}_depends")
    get_property("${project}_depends_optional" GLOBAL
      PROPERTY "${project}_depends_optional")
    set("${project}_depends_all"
      "${${project}_depends}"
      "${${project}_depends_optional}")

    if (ENABLE_${project})
      list(APPEND enabled_projects "${project}")
    endif ()

    set("${project}_needed_by")
  endforeach ()
  if (NOT enabled_projects)
    message(FATAL_ERROR "No projects enabled!")
  endif ()
  list(SORT enabled_projects) # Deterministic order.

  # Order list to satisfy dependencies.
  # First only use the non-optional dependencies.
  include(TopologicalSort)
  topological_sort(enabled_projects "" _depends)

  # Now generate a project order using both, optional and non-optional
  # dependencies.
  set(ordered_projects "${enabled_projects}")
  topological_sort(enabled_projects "" _depends_all)

  # Update enabled_projects to be in the correct order taking into
  # consideration optional dependencies.
  set(new_order)
  foreach (project IN LISTS ordered_projects)
    list(FIND enabled_projects "${project}" found)
    if (found GREATER -1)
      list(APPEND new_order "${project}")
    endif ()
  endforeach ()
  set (enabled_projects ${new_order})

  # build information about what project needs what.
  foreach (project IN LISTS enabled_projects)
    _superbuild_enable_project("${project}" "")
    foreach (dep IN LISTS "${project}_depends")
      _superbuild_enable_project("${dep}" "${project}")
    endforeach ()
  endforeach ()

  foreach (project IN LISTS enabled_projects)
    if (ENABLE_${project})
      message(STATUS "Enabling ${project} as requested.")
    else ()
      list(SORT "${project}_needed_by")
      list(REMOVE_DUPLICATES "${project}_needed_by")

      string(REPLACE ";" ", " required_by "${${project}_needed_by}")
      message(STATUS "Enabling ${project} for: ${required_by}")
      set_property(CACHE "ENABLE_${project}" PROPERTY TYPE INTERNAL)
    endif ()
  endforeach ()

  string(REPLACE ";" ", " enabled "${enabled_projects}")
  message(STATUS "Building projects: ${enabled}")

  set(superbuild_build_phase TRUE)
  foreach (project IN LISTS enabled_projects)
    get_property(can_use_system GLOBAL
      PROPERTY "${project}_system" SET)
    if (can_use_system)
      # For every enabled project that can use system, expose the option to the
      # user.
      cmake_dependent_option("USE_SYSTEM_${project}" "" OFF
        "${project}_enabled" OFF)
    endif ()

    set(current_project "${project}")

    get_property(is_dummy GLOBAL
      PROPERTY "${project}_is_dummy")
    if (can_use_system AND USE_SYSTEM_${project})
      _superbuild_add_dummy_project_internal("${project}")
      include("${project}.use.system")
    elseif (is_dummy)
      # This project isn't built, just used as a graph node to represent a
      # group of dependencies.
      include("${project}")
      _superbuild_add_dummy_project_internal("${project}")
    else ()
      include("${project}")
      _superbuild_add_project_internal("${project}" "${${project}_arguments}")
    endif ()
  endforeach ()

  foreach (project IN LISTS all_projects)
    set("${project}_enabled"
      "${${project}_enabled}"
      PARENT_SCOPE)
  endforeach ()
endfunction ()

#------------------------------------------------------------------------------
# internal macro to validate project names.
function (_superbuild_project_check_name name)
  if (NOT name MATCHES "^[a-zA-Z][a-zA-Z0-9]*$")
    message(FATAL_ERROR "Invalid project name: ${_name}")
  endif ()
endfunction ()

function (_superbuild_check_current_project func)
  if (NOT current_project)
    message(AUTHOR_WARNING "${func} called an incorrect stage.")
    return ()
  endif ()
endfunction ()
