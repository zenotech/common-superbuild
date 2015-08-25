include(PVExternalProject)
include(CMakeParseArguments)

#------------------------------------------------------------------------------
macro(process_dependencies)
  set (CM_PROJECTS_ENABLED "")
  foreach(cm-project IN LISTS CM_PROJECTS_ALL)
    set(${cm-project}_ENABLED FALSE)
    if (ENABLE_${cm-project})
      list(APPEND CM_PROJECTS_ENABLED ${cm-project})
    endif()
  endforeach()
  list(SORT CM_PROJECTS_ENABLED) # Deterministic order.

  # Order list to satisfy dependencies.
  # First only use the non-optional dependencies.
  include(TopologicalSort)
  topological_sort(CM_PROJECTS_ENABLED "" _DEPENDS)

  # Now generate a project order using both, optional and non-optional
  # dependencies.
  set (CM_PROJECTS_ORDER ${CM_PROJECTS_ENABLED})
  topological_sort(CM_PROJECTS_ORDER "" _DEPENDS_ANY)

  # Update CM_PROJECTS_ENABLED to be in the correct order taking into
  # consideration optional dependencies.
  set (new_order)
  foreach (cm-project IN LISTS CM_PROJECTS_ORDER)
    list(FIND CM_PROJECTS_ENABLED "${cm-project}" found)
    if (found GREATER -1)
      list(APPEND new_order "${cm-project}")
    endif()
  endforeach()
  set (CM_PROJECTS_ENABLED ${new_order})

  # build information about what project needs what.
  foreach (cm-project IN LISTS CM_PROJECTS_ENABLED)
    enable_project(${cm-project} "")
    foreach (dependency IN LISTS ${cm-project}_DEPENDS)
      enable_project(${dependency} "${cm-project}")
    endforeach()
  endforeach()

  foreach (cm-project IN LISTS CM_PROJECTS_ENABLED)
    if (ENABLE_${cm-project})
      message(STATUS "Enabling ${cm-project} as requested.")
      set_property(CACHE ENABLE_${cm-project} PROPERTY TYPE BOOL)
    else()
      list(SORT ${cm-project}_NEEDED_BY)
      list(REMOVE_DUPLICATES ${cm-project}_NEEDED_BY)
      message(STATUS "Enabling ${cm-project} since needed by: ${${cm-project}_NEEDED_BY}")
      set_property(CACHE ENABLE_${cm-project} PROPERTY TYPE INTERNAL)
    endif()
  endforeach()
  message(STATUS "PROJECTS_ENABLED ${CM_PROJECTS_ENABLED}")
  set (build-projects 1)
  foreach (cm-project IN LISTS CM_PROJECTS_ENABLED)
    get_property(is_dummy GLOBAL PROPERTY ${cm-project}_IS_DUMMY_PROJECT)
    if (${cm-project}_CAN_USE_SYSTEM)
      # for every enabled project that can use system, expose the option to the
      # user.
      set_property(CACHE USE_SYSTEM_${cm-project} PROPERTY TYPE BOOL)
      if (USE_SYSTEM_${cm-project})
        add_external_dummy_project_internal(${cm-project})
        include(${cm-project}.use.system OPTIONAL RESULT_VARIABLE rv)
        if (rv STREQUAL "NOTFOUND")
          message(AUTHOR_WARNING "${cm-project}.use.system not found!!!")
        endif()
      else()
        include(${cm-project})
        add_external_project_internal(${cm-project} "${${cm-project}_ARGUMENTS}")
      endif()
    elseif(is_dummy)
      #this project isn't built, just used as a graph node to
      #represent a group of dependencies
      include(${cm-project})
      add_external_dummy_project_internal(${cm-project})
    else()
      include(${cm-project})
      add_external_project_internal(${cm-project} "${${cm-project}_ARGUMENTS}")
    endif()
  endforeach()
  unset (build-projects)
endmacro()
#------------------------------------------------------------------------------
macro(enable_project name needed-by)
  set (${name}_ENABLED TRUE CACHE INTERNAL "" FORCE)
  list (APPEND ${name}_NEEDED_BY "${needed-by}")
endmacro()

#------------------------------------------------------------------------------
function(add_external_dummy_project_internal name)
  set(arg_DEPENDS)
  get_project_depends(${name} arg)
  ExternalProject_Add(${name}
  DEPENDS ${arg_DEPENDS}
  DOWNLOAD_COMMAND ""
  SOURCE_DIR ""
  UPDATE_COMMAND ""
  CONFIGURE_COMMAND ""
  BUILD_COMMAND ""
  INSTALL_COMMAND ""
  )
endfunction()

#------------------------------------------------------------------------------
function(add_external_project_internal name)
  set (cmake_params)
  foreach (flag CMAKE_BUILD_TYPE
                CMAKE_C_FLAGS_DEBUG
                CMAKE_C_FLAGS_MINSIZEREL
                CMAKE_C_FLAGS_RELEASE
                CMAKE_C_FLAGS_RELWITHDEBINFO
                CMAKE_CXX_FLAGS_DEBUG
                CMAKE_CXX_FLAGS_MINSIZEREL
                CMAKE_CXX_FLAGS_RELEASE
                CMAKE_CXX_FLAGS_RELWITHDEBINFO)
    if (flag)
      list (APPEND cmake_params -D${flag}:STRING=${${flag}})
    endif()
  endforeach()

  if (APPLE)
    list (APPEND cmake_params
      -DCMAKE_OSX_ARCHITECTURES:STRING=${CMAKE_OSX_ARCHITECTURES}
      -DCMAKE_OSX_DEPLOYMENT_TARGET:STRING=${CMAKE_OSX_DEPLOYMENT_TARGET}
      -DCMAKE_OSX_SYSROOT:PATH=${CMAKE_OSX_SYSROOT})
  endif()

  #get extra-cmake args from every dependent project, if any.
  set(arg_DEPENDS)
  get_project_depends(${name} arg)
  foreach(dependency IN LISTS arg_DEPENDS)
    get_property(args GLOBAL PROPERTY ${dependency}_CMAKE_ARGS)
    list(APPEND cmake_params ${args})
  endforeach()

  # get extra flags added using append_flags(), if any.
  set (extra_c_flags)
  set (extra_cxx_flags)
  set (extra_ld_flags)

  # scan project flags.
  set (_tmp)
  get_property(_tmp GLOBAL PROPERTY ${name}_APPEND_PROJECT_ONLY_FLAGS_CMAKE_C_FLAGS)
  set (extra_c_flags ${extra_c_flags} ${_tmp})
  get_property(_tmp GLOBAL PROPERTY ${name}_APPEND_PROJECT_ONLY_FLAGS_CMAKE_CXX_FLAGS)
  set (extra_cxx_flags ${extra_cxx_flags} ${_tmp})
  get_property(_tmp GLOBAL PROPERTY ${name}_APPEND_PROJECT_ONLY_FLAGS_LDFLAGS)
  set (extra_ld_flags ${extra_ld_flags} ${_tmp})
  unset(_tmp)

  # scan dependecy flags.
  foreach(dependency IN LISTS arg_DEPENDS)
    get_property(_tmp GLOBAL PROPERTY ${dependency}_APPEND_FLAGS_CMAKE_C_FLAGS)
    set (extra_c_flags ${extra_c_flags} ${_tmp})
    get_property(_tmp GLOBAL PROPERTY ${dependency}_APPEND_FLAGS_CMAKE_CXX_FLAGS)
    set (extra_cxx_flags ${extra_cxx_flags} ${_tmp})
    get_property(_tmp GLOBAL PROPERTY ${dependency}_APPEND_FLAGS_LDFLAGS)
    set (extra_ld_flags ${extra_ld_flags} ${_tmp})
  endforeach()

  set (project_c_flags "${cflags}")
  if (extra_c_flags)
    set (project_c_flags "${cflags} ${extra_c_flags}")
  endif()
  set (project_cxx_flags "${cxxflags}")
  if (extra_cxx_flags)
    set (project_cxx_flags "${cxxflags} ${extra_cxx_flags}")
  endif()
  set (project_ld_flags "${ldflags}")
  if (extra_ld_flags)
    set (project_ld_flags "${ldflags} ${extra_ld_flags}")
  endif()

  #message("ARGS ${name} ${ARGN}")

  # refer to documentation for PASS_LD_LIBRARY_PATH_FOR_BUILDS in
  # in root CMakeLists.txt.
  set (ld_library_path_argument)
  if (PASS_LD_LIBRARY_PATH_FOR_BUILDS)
    set (ld_library_path_argument
      LD_LIBRARY_PATH "${ld_library_path}")
  endif ()


  #args needs to be quoted so that empty list items aren't removed
  #if that happens options like INSTALL_COMMAND "" won't work
  set(args "${ARGN}")
  PVExternalProject_Add(${name} "${args}"
    PREFIX ${name}
    DOWNLOAD_DIR ${download_location}
    INSTALL_DIR ${install_location}

    # add url/mdf/git-repo etc. specified in versions.cmake
    ${${name}_revision}

    PROCESS_ENVIRONMENT
      LDFLAGS "${project_ld_flags}"
      CPPFLAGS "${cppflags}"
      CXXFLAGS "${project_cxx_flags}"
      CFLAGS "${project_c_flags}"
# disabling this since it fails when building numpy.
#      MACOSX_DEPLOYMENT_TARGET "${CMAKE_OSX_DEPLOYMENT_TARGET}"
      ${ld_library_path_argument}
      CMAKE_PREFIX_PATH "${prefix_path}"
    CMAKE_ARGS
      -DCMAKE_INSTALL_PREFIX:PATH=${prefix_path}
      -DCMAKE_PREFIX_PATH:PATH=${prefix_path}
      -DCMAKE_C_FLAGS:STRING=${project_c_flags}
      -DCMAKE_CXX_FLAGS:STRING=${project_cxx_flags}
      -DCMAKE_SHARED_LINKER_FLAGS:STRING=${project_ld_flags}
      ${cmake_params}

    LIST_SEPARATOR "${ep_list_separator}"
    )

  get_property(additional_steps GLOBAL PROPERTY ${name}_STEPS)
  if (additional_steps)
     foreach (step ${additional_steps})
       get_property(step_contents GLOBAL PROPERTY ${name}-STEP-${step})
       ExternalProject_Add_Step(${name} ${step} ${step_contents})
     endforeach()
  endif()
endfunction()

#------------------------------------------------------------------------------
# When passing string with ";" to add_external_project() macros, we need to
# ensure that the -+- is replaced with the LIST_SEPARATOR.
macro(sanitize_lists_in_string out_var_prefix var)
  string(REPLACE ";" "${ep_list_separator}" command "${${var}}")
  set (${out_var_prefix}${var} "${command}")
endmacro()
