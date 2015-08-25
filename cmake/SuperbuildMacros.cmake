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
