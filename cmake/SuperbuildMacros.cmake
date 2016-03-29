include(SuperbuildExternalProject)
include(CMakeParseArguments)

# The external projects list separator string should be set ASAP so that
# anything else can use it that needs it.
set(_superbuild_list_separator "-+-")

#------------------------------------------------------------------------------
function (superbuild_add_project name)
  _superbuild_project_check_name("${name}")

  set(can_use_system FALSE)
  set(must_use_system FALSE)
  set(default "${_superbuild_default_${name}}")
  set(allow_developer_mode FALSE)
  set(debuggable FALSE)
  set(depends)
  set(optional_depends)

  set(ep_arguments)
  set(grab)

  foreach (arg IN LISTS ARGN)
    if (arg STREQUAL "CAN_USE_SYSTEM")
      set(can_use_system TRUE)
      set(grab)
    elseif (arg STREQUAL "MUST_USE_SYSTEM")
      set(must_use_system TRUE)
      set(grab)
    elseif (arg STREQUAL "DEFAULT_ON")
      set(default ON)
      set(grab)
    elseif (arg STREQUAL "DEVELOPER_MODE")
      set(allow_developer_mode TRUE)
      set(grab)
    elseif (arg STREQUAL "DEBUGGABLE")
      set(debuggable TRUE)
      set(grab)
    elseif (arg STREQUAL "DEPENDS")
      set(grab depends)
    elseif (arg STREQUAL "DEPENDS_OPTIONAL")
      set(grab optional_depends)
    elseif (arg MATCHES "${_ep_keywords_ExternalProject_Add}")
      set(grab ep_arguments)
      list(APPEND ep_arguments
        "${arg}")
    elseif (grab)
      list(APPEND "${grab}"
        "${arg}")
    endif ()
  endforeach ()

  if (superbuild_build_phase)
    foreach (op_dep IN LISTS optional_depends)
      if (${op_dep}_enabled)
        list(APPEND ep_arguments
          DEPENDS "${op_dep}")
      endif ()
    endforeach ()

    get_property(all_projects GLOBAL
      PROPERTY superbuild_projects)
    set(missing_deps)
    set(missing_deps_optional)
    foreach (dep IN LISTS depends)
      list(FIND all_projects "${dep}" idx)
      if (idx EQUAL -1)
        list(APPEND missing_deps
          "${dep}")
      endif ()
    endforeach ()
    foreach (dep IN LISTS optional_depends)
      list(FIND all_projects "${dep}" idx)
      if (idx EQUAL -1)
        list(APPEND missing_deps_optional
          "${dep}")
      endif ()
    endforeach ()

    if (missing_deps_optional)
      string(REPLACE ";" ", " missing_deps_optional "${missing_deps_optional}")
      message(AUTHOR_WARNING "Optional dependencies for ${name} not found: ${missing_deps_optional}")
    endif ()
    if (missing_deps)
      string(REPLACE ";" ", " missing_deps "${missing_deps}")
      message(FATAL_ERROR "Dependencies for ${name} not found: ${missing_deps}")
    endif ()

    set("${name}_arguments"
      DEPENDS ${depends}
      "${ep_arguments}"
      PARENT_SCOPE)
  else ()
    option("ENABLE_${name}" "Request to build project ${name}" "${default}")
    # Set the TYPE because it is overrided to INTERNAL if it is required by
    # dependencies later.
    set_property(CACHE "ENABLE_${name}" PROPERTY TYPE BOOL)
    set_property(GLOBAL APPEND
      PROPERTY
        superbuild_projects "${name}")

    if (can_use_system)
      set_property(GLOBAL
        PROPERTY
          "${name}_system" TRUE)
      if (USE_SYSTEM_${name})
        set(depends)
        set(depends_optional)
      endif ()
    endif ()

    if (must_use_system)
      set_property(GLOBAL
        PROPERTY
          "${name}_system_force" TRUE)
      set(depends)
      set(depends_optional)
    endif ()

    if (allow_developer_mode)
      set_property(GLOBAL
        PROPERTY
          "${name}_developer_mode" TRUE)
    endif ()

    if (debuggable)
      set_property(GLOBAL
        PROPERTY
          "${name}_debuggable" TRUE)
    endif ()

    set_property(GLOBAL
      PROPERTY
        "${name}_depends" ${depends})
    set_property(GLOBAL
      PROPERTY
        "${name}_depends_optional" ${optional_depends})
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

function (superbuild_apply_patch _name _patch _comment)
  find_package(Git QUIET)
  if (NOT GIT_FOUND)
    mark_as_advanced(CLEAR GIT_EXECUTABLE)
    message(FATAL_ERROR "Could not find git executable.  Please set GIT_EXECUTABLE.")
  endif ()

  execute_process(
    COMMAND "${GIT_EXECUTABLE}"
            rev-parse
            --is-inside-work-tree
    RESULT_VARIABLE res
    OUTPUT_VARIABLE out
    ERROR_VARIABLE  err
    WORKING_DIRECTORY "${CMAKE_BINARY_DIRECTORY}"
    OUTPUT_STRIP_TRAILING_WHITESPACE)
  if (res AND NOT res EQUAL 128)
    message(FATAL_ERROR "Failed to determine if the build tree is inside of a git repository.")
  endif ()
  if (out STREQUAL "true")
    message(FATAL_ERROR
      "`git apply` does not work properly underneath a git repository; please "
      "relocate your build directory to be outside of any git repository.")
  endif ()

  superbuild_project_add_step("${_name}-patch-${_patch}"
    COMMAND   "${GIT_EXECUTABLE}"
              apply
              -p1
              "${CMAKE_CURRENT_LIST_DIR}/patches/${_name}-${_patch}.patch"
    DEPENDEES update
    DEPENDERS patch
    COMMENT   "${_comment}"
    WORKING_DIRECTORY <SOURCE_DIR>)
endfunction ()

function (superbuild_commit_patch _name _patch _comment)
  find_package(Git QUIET)
  if (NOT GIT_FOUND)
    mark_as_advanced(CLEAR GIT_EXECUTABLE)
    message(FATAL_ERROR "Could not find git executable.  Please set GIT_EXECUTABLE.")
  endif()

  superbuild_project_add_step("${_name}-patch-${_patch}"
    COMMAND   "${GIT_EXECUTABLE}"
              am
              "${CMAKE_CURRENT_LIST_DIR}/patches/${_name}-${_patch}.patch"
    DEPENDEES update
    DEPENDERS patch
    COMMENT   "${_comment}"
    WORKING_DIRECTORY <SOURCE_DIR>)
endfunction ()

function (superbuild_add_extra_cmake_args)
  if (NOT superbuild_build_phase)
    return ()
  endif ()

  _superbuild_check_current_project("superbuild_add_extra_cmake_args")

  set_property(GLOBAL APPEND
    PROPERTY
      "${current_project}_cmake_args" ${ARGN})
endfunction ()

#------------------------------------------------------------------------------
function (superbuild_project_add_step name)
  if (NOT superbuild_build_phase)
    return ()
  endif ()

  _superbuild_check_current_project("superbuild_project_add_step")

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
      message(AUTHOR_WARNING "Unknown argument to superbuild_append_flags(), ${arg}.")
    endif ()
  endforeach ()

  if (build-projects)
    _superbuild_check_current_project("superbuild_append_flags")

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
      ${${project}_depends}
      ${${project}_depends_optional})

    if (ENABLE_${project})
      list(APPEND enabled_projects "${project}")
    endif ()

    set("${project}_needed_by" "")
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
  topological_sort(ordered_projects "" _depends_all)

  # Update enabled_projects to be in the correct order taking into
  # consideration optional dependencies.
  set(new_order)
  foreach (project IN LISTS ordered_projects)
    list(FIND enabled_projects "${project}" found)
    if (found GREATER -1)
      list(APPEND new_order "${project}")
    endif ()
  endforeach ()
  set(enabled_projects ${new_order})

  # build information about what project needs what.
  foreach (project IN LISTS enabled_projects)
    _superbuild_enable_project("${project}" "")
    foreach (dep IN LISTS "${project}_depends")
      _superbuild_enable_project("${dep}" "${project}")
    endforeach ()
  endforeach ()

  foreach (project IN LISTS enabled_projects)
    list(SORT "${project}_needed_by")
    list(REMOVE_DUPLICATES "${project}_needed_by")

    if (ENABLE_${project})
      message(STATUS "Enabling ${project} as requested.")
    else ()
      string(REPLACE ";" ", " required_by "${${project}_needed_by}")
      message(STATUS "Enabling ${project} for: ${required_by}")
      set_property(CACHE "ENABLE_${project}" PROPERTY TYPE INTERNAL)
    endif ()
  endforeach ()

  string(REPLACE ";" ", " enabled "${enabled_projects}")
  message(STATUS "Building projects: ${enabled}")

  set(system_projects)

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
    get_property(must_use_system GLOBAL
      PROPERTY "${project}_system_force" SET)
    if (must_use_system)
      set(can_use_system TRUE)
      set(USE_SYSTEM_${project} TRUE)
    endif ()

    get_property(allow_developer_mode GLOBAL
      PROPERTY "${project}_developer_mode" SET)
    if (allow_developer_mode)
      # For every enabled project that can be used in developer mode, expose
      # the option to the user.
      # TODO: Make DEVELOPER_MODE a single option with the *value* being the
      # project to build as a developer mode.
      cmake_dependent_option("DEVELOPER_MODE_${project}" "" OFF
        "${project}_enabled" OFF)
    endif ()

    get_property(debuggable GLOBAL
      PROPERTY "${project}_debuggable" SET)
    if (WIN32 AND CMAKE_BUILD_TYPE STREQUAL "Debug")
      # Release and RelWithDebInfo is not mixable with Debug builds, so just
      # don't support it.
      set(debuggable FALSE)
    endif ()
    if (debuggable)
      set("CMAKE_BUILD_TYPE_${project}" "<same>"
        CACHE STRING "The build type for the ${project} project.")
      set_property(CACHE "CMAKE_BUILD_TYPE_${project}"
        PROPERTY
          STRINGS "<same>;Release;RelWithDebInfo")
      if (NOT WIN32)
        set_property(CACHE "CMAKE_BUILD_TYPE_${project}" APPEND
          PROPERTY
            STRINGS "Debug")
      endif ()
    endif ()

    set(current_project "${project}")

    get_property(is_dummy GLOBAL
      PROPERTY "${project}_is_dummy")
    if (can_use_system AND USE_SYSTEM_${project})
      list(APPEND system_projects
        "${project}")
      _superbuild_add_dummy_project_internal("${project}")
      include("${project}.system")
    elseif (allow_developer_mode AND DEVELOPER_MODE_${project})
      set(requiring_packages)
      foreach (dep IN LISTS ${project}_needed_by)
        # Verify all dependencies are in DEVELOPER_MODE.
        if (NOT DEVELOPER_MODE_${dep})
          list(APPEND requiring_packages "${dep}")
        endif ()
      endforeach ()

      if (requiring_packages)
        string(REPLACE ";" ", " requiring_packages "${requiring_packages}")
        message(FATAL_ERROR "${project} is in developer mode, but is required by: ${requiring_packages}.")
      endif ()

      include("${project}")
      _superbuild_write_developer_mode_cache("${project}" "${${project}_arguments}")
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
  set(enabled_projects
    "${enabled_projects}"
    PARENT_SCOPE)
  set(system_projects
    "${system_projects}"
    PARENT_SCOPE)
endfunction ()

#------------------------------------------------------------------------------
function (_superbuild_enable_project name needed_by)
  set("${name}_enabled" TRUE
    PARENT_SCOPE)

  if (needed_by)
    list(APPEND "${name}_needed_by"
      "${needed_by}")
    set("${name}_needed_by"
      "${${name}_needed_by}"
      PARENT_SCOPE)
  endif ()
endfunction ()

#------------------------------------------------------------------------------
function (_superbuild_add_dummy_project_internal name)
  superbuild_get_project_depends("${name}" arg)

  ExternalProject_Add("${name}"
    DEPENDS           ${arg_depends}
    INSTALL_DIR       "${superbuild_install_location}"
    DOWNLOAD_COMMAND  ""
    SOURCE_DIR        ""
    UPDATE_COMMAND    ""
    CONFIGURE_COMMAND ""
    BUILD_COMMAND     ""
    INSTALL_COMMAND   "")
endfunction ()

#------------------------------------------------------------------------------
function (_superbuild_add_project_internal name)
  set(cmake_params)
  foreach (flag CMAKE_C_FLAGS_DEBUG
                CMAKE_C_FLAGS_MINSIZEREL
                CMAKE_C_FLAGS_RELEASE
                CMAKE_C_FLAGS_RELWITHDEBINFO
                CMAKE_CXX_FLAGS_DEBUG
                CMAKE_CXX_FLAGS_MINSIZEREL
                CMAKE_CXX_FLAGS_RELEASE
                CMAKE_CXX_FLAGS_RELWITHDEBINFO)
    if (${flag})
      list(APPEND cmake_params "-D${flag}:STRING=${${flag}}")
    endif ()
  endforeach ()

  if (debuggable AND NOT CMAKE_BUILD_TYPE_${name} STREQUAL "<same>")
    list(APPEND cmake_params "-DCMAKE_BUILD_TYPE:STRING=${CMAKE_BUILD_TYPE_${name}}")
  else ()
    list(APPEND cmake_params "-DCMAKE_BUILD_TYPE:STRING=${CMAKE_BUILD_TYPE}")
  endif ()

  superbuild_osx_pass_version_flags(apple_flags)
  _superbuild_fetch_cmake_args("${name}" cmake_dep_args)
  list(APPEND cmake_params
    ${apple_flags}
    ${cmake_dep_args})

  # Get extra flags added using superbuild_append_flags(), if any.
  set(extra_vars
    c_flags
    cxx_flags
    ldflags)

  foreach (extra_var IN LISTS extra_vars)
    set("extra_${extra_var}")
  endforeach ()

  # Scan project flags.
  foreach (var IN LISTS extra_vars)
    string(TOUPPER "${var}" upper_var)
    get_property(extra_flags GLOBAL
      PROPERTY "${name}_append_project_only_flags_cmake_${upper_var}")

    list(APPEND "extra_${var}"
      ${extra_flags})
  endforeach ()

  # Scan dependency flags.
  foreach (dep IN LISTS arg_depends)
    foreach (var IN LISTS extra_vars)
      string(TOUPPER "${var}" upper_var)
      get_property(extra_flags GLOBAL
        PROPERTY "${dep}_append_flags_cmake_${upper_var}")

      list(APPEND "extra_${var}"
        ${extra_flags})
    endforeach ()
  endforeach ()

  foreach (var IN LISTS extra_vars)
    set(project_${var} "${superbuild_${var}}")
    if (extra_${var})
      set(project_${var} "${project_${var}} ${extra_${var}}")
    endif ()
  endforeach ()

  set(ld_library_path_argument)
  superbuild_unix_ld_library_path_hack(ld_library_path_argument)

  get_property("${name}_revision" GLOBAL
    PROPERTY "${name}_revision")
  if (NOT ${name}_revision)
    message(FATAL_ERROR "Missing revision information for ${name}.")
  endif ()

  # ARGN needs to be quoted so that empty list items aren't removed if
  # that happens options like INSTALL_COMMAND "" won't work
  _superbuild_ExternalProject_add(${name} "${ARGN}"
    PREFIX        "${name}"
    DOWNLOAD_DIR  "${superbuild_download_location}"
    INSTALL_DIR   "${superbuild_install_location}"

    # add url/mdf/git-repo etc. specified in versions.cmake
    ${${name}_revision}

    PROCESS_ENVIRONMENT
      LDFLAGS     "${project_ld_flags}"
      CPPFLAGS    "${superbuild_cppflags}"
      CXXFLAGS    "${project_cxx_flags}"
      CFLAGS      "${project_c_flags}"
      # disabling this since it fails when building numpy.
      # MACOSX_DEPLOYMENT_TARGET "${CMAKE_OSX_DEPLOYMENT_TARGET}"
      ${ld_library_path_argument}
      CMAKE_PREFIX_PATH "${superbuild_prefix_path}"
    CMAKE_ARGS
      -DCMAKE_INSTALL_PREFIX:PATH=${superbuild_prefix_path}
      -DCMAKE_PREFIX_PATH:PATH=${superbuild_prefix_path}
      -DCMAKE_C_FLAGS:STRING=${project_c_flags}
      -DCMAKE_CXX_FLAGS:STRING=${project_cxx_flags}
      -DCMAKE_SHARED_LINKER_FLAGS:STRING=${project_ld_flags}
      ${cmake_params}

    LIST_SEPARATOR "${_superbuild_list_separator}")

  get_property(additional_steps GLOBAL
    PROPERTY "${name}_steps")
  if (additional_steps)
    foreach (step IN LISTS additional_steps)
      get_property(step_arguments GLOBAL
        PROPERTY "${name}_step_${step}")
      ExternalProject_Add_Step("${name}" "${step}"
        "${step_arguments}")
    endforeach ()
  endif ()
endfunction ()

function (_superbuild_write_developer_mode_cache name)
  set(cmake_args
    "-DCMAKE_PREFIX_PATH:PATH=${superbuild_prefix_path}")
  if (debuggable AND NOT CMAKE_BUILD_TYPE_${name} STREQUAL "<same>")
    list(APPEND cmake_args
      "-DCMAKE_BUILD_TYPE:STRING=${CMAKE_BUILD_TYPE_${name}}")
  else ()
    list(APPEND cmake_args
      "-DCMAKE_BUILD_TYPE:STRING=${CMAKE_BUILD_TYPE}")
  endif ()

  superbuild_osx_pass_version_flags(apple_args)
  _superbuild_fetch_cmake_args("${name}" cmake_dep_args)
  list(APPEND cmake_args
    ${apple_args}
    ${cmake_dep_args})

  set(skip TRUE)
  foreach (arg IN LISTS ARGN)
    if (arg STREQUAL "CMAKE_ARGS")
      set(skip FALSE)
    elseif (arg STREQUAL "DEPENDS")
      set(skip TRUE)
    elseif (arg MATCHES _ep_keywords__superbuild_ExternalProject_add)
      set(skip TRUE)
    elseif (NOT skip)
      list(APPEND cmake_args
        "${arg}")
    endif ()
  endforeach ()

  _superbuild_add_dummy_project_internal("${name}")

  set(cache_file "${CMAKE_BINARY_DIR}/${name}-developer-config.cmake")
  if (COMMAND _ep_command_line_to_initial_cache)
    # Upstream ExternalProject changed its argument parsing. Since these are
    # internal functions, go with the flow.
    _ep_command_line_to_initial_cache(cmake_args "${cmake_args}" 0)
  endif ()
  _ep_write_initial_cache(${name} "${cache_file}" "${cmake_args}")
endfunction ()

function (_superbuild_fetch_cmake_args name var)
  # Get extra cmake args from every dependent project, if any.
  superbuild_get_project_depends("${name}" arg)
  set(cmake_params)
  foreach (dep IN LISTS arg_depends)
    get_property(cmake_args GLOBAL
      PROPERTY "${dep}_cmake_args")
    list(APPEND cmake_params
      ${cmake_args})
  endforeach ()

  set("${var}"
    ${cmake_params}
    PARENT_SCOPE)
endfunction ()

#------------------------------------------------------------------------------
# When passing string with ";" to add_external_project() macros, we need to
# ensure that the -+- is replaced with the LIST_SEPARATOR.
function (_superbuild_sanitize_lists_in_string out_var_prefix var)
  string(REPLACE ";" "${_superbuild_list_separator}" command "${${var}}")
  set("${out_var_prefix}${var}" "${command}"
    PARENT_SCOPE)
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

macro (superbuild_add_project_python _name)
  if (WIN32)
    set(_superbuild_python_path <INSTALL_DIR>/bin/Lib/site-packages)
    set(_superbuild_python_args
      "--prefix=bin")
  else ()
    set(_superbuild_python_path <INSTALL_DIR>/lib/python2.7/site-packages)
    set(_superbuild_python_args
      "--single-version-externally-managed"
      "--prefix=")
  endif ()

  superbuild_add_project("${_name}"
    BUILD_IN_SOURCE 1
    DEPENDS python ${ARGN}
    CONFIGURE_COMMAND
      ""
    BUILD_COMMAND
      "${superbuild_python_executable}"
        setup.py
        build
    INSTALL_COMMAND
      "${superbuild_python_executable}"
        setup.py
        install
        --skip-build
        --root=<INSTALL_DIR>
        ${_superbuild_python_args}
    PROCESS_ENVIRONMENT
      PYTHONPATH ${_superbuild_python_path})
endmacro ()
