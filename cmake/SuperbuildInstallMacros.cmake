set(_superbuild_install_cmake_dir "${CMAKE_CURRENT_LIST_DIR}")
set_property(GLOBAL PROPERTY
  superbuild_has_cleaned FALSE)

include(CMakeParseArguments)

function (_superbuild_unix_install_binary)
  set(options
    CLEAN)
  set(values
    DESTINATION
    LIBDIR
    LOCATION
    BINARY
    TYPE)
  set(multivalues
    INCLUDE_REGEXES
    EXCLUDE_REGEXES
    SEARCH_DIRECTORIES)
  cmake_parse_arguments(_install_binary "${options}" "${values}" "${multivalues}" ${ARGN})

  if (NOT _install_binary_BINARY)
    message(FATAL_ERROR "Cannot install a binary without a path.")
  endif ()

  if (NOT IS_ABSOLUTE "${_install_binary_BINARY}")
    message(FATAL_ERROR "Cannot install a binary without an absolute path (${_install_binary_BINARY}).")
  endif ()

  if (NOT _install_binary_DESTINATION)
    set(_install_binary_DESTINATION
      "\$ENV{DESTDIR}\${CMAKE_INSTALL_PREFIX}")
  endif ()

  if (NOT _install_binary_LIBDIR)
    message(FATAL_ERROR "Cannot install ${_install_binary_BINARY} without knowing where to put dependent libraries.")
  endif ()

  if (NOT _install_binary_TYPE)
    message(FATAL_ERROR "Cannot install ${_install_binary_BINARY} without knowing its type.")
  endif ()

  if (_install_binary_TYPE STREQUAL "module" AND NOT _install_binary_LOCATION)
    message(FATAL_ERROR "Cannot install ${_install_binary_BINARY} as a module without knowing where to place it.")
  endif ()

  set(fixup_bundle_arguments)
  set(fixup_bundle_arguments
    "${fixup_bundle_arguments} --destination ${_install_binary_DESTINATION}")
  set(fixup_bundle_arguments
    "${fixup_bundle_arguments} --type ${_install_binary_TYPE}")
  set(fixup_bundle_arguments
    "${fixup_bundle_arguments} --libdir ${_install_binary_LIBDIR}")

  get_property(superbuild_has_cleaned GLOBAL PROPERTY
    superbuild_has_cleaned)
  if (_install_binary_CLEAN OR NOT superbuild_has_cleaned)
    set_property(GLOBAL PROPERTY
      superbuild_has_cleaned TRUE)
    set(fixup_bundle_arguments
      "${fixup_bundle_arguments} --clean")
  endif ()

  if (_install_binary_LOCATION)
    set(fixup_bundle_arguments
      "${fixup_bundle_arguments} --location \"${_install_binary_LOCATION}\"")
  endif ()

  foreach (include_regex IN LISTS _install_binary_INCLUDE_REGEXES)
    set(fixup_bundle_arguments
      "${fixup_bundle_arguments} --include \"${include_regex}\"")
  endforeach ()

  foreach (exclude_regex IN LISTS _install_binary_EXCLUDE_REGEXES)
    set(fixup_bundle_arguments
      "${fixup_bundle_arguments} --exclude \"${exclude_regex}\"")
  endforeach ()

  foreach (search_directory IN LISTS _install_binary_SEARCH_DIRECTORIES)
    set(fixup_bundle_arguments
      "${fixup_bundle_arguments} --search \"${search_directory}\"")
  endforeach ()

  install(CODE
    "execute_process(
      COMMAND \"${_superbuild_install_cmake_dir}/scripts/fixup_bundle.unix.py\"
              ${fixup_bundle_arguments}
              --manifest    \"${CMAKE_BINARY_DIR}/install.manifest\"
              \"${_install_binary_BINARY}\"
      RESULT_VARIABLE res
      ERROR_VARIABLE  err)

    if (res)
      message(FATAL_ERROR \"Failed to install ${name}:\n\${err}\")
    endif ()"
    COMPONENT superbuild)
endfunction ()

function (_superbuild_unix_install_executable path libdir)
  _superbuild_unix_install_binary(
    BINARY      "${path}"
    LIBDIR      "${libdir}"
    TYPE        executable
    ${ARGN})
endfunction ()

function (_superbuild_unix_install_module path subdir libdir)
  _superbuild_unix_install_binary(
    BINARY      "${path}"
    LOCATION    "${subdir}"
    LIBDIR      "${libdir}"
    TYPE        module
    ${ARGN})
endfunction ()

function (superbuild_unix_install_program_fwd name paths)
  set(found FALSE)
  foreach (path IN LISTS paths)
    if (EXISTS "${superbuild_install_location}/${path}/${name}")
      _superbuild_unix_install_module("${superbuild_install_location}/${path}/${name}" "${path}" "${path}" ${ARGN})
      set(found TRUE)
      break ()
    endif ()
  endforeach ()

  if (NOT found)
    message(FATAL_ERROR "Unable to find the actual executable for ${name}")
  endif ()

  _superbuild_unix_install_executable("${superbuild_install_location}/bin/${name}" "lib")
endfunction ()

function (superbuild_unix_install_program name libdir)
  _superbuild_unix_install_executable("${name}" "${libdir}" ${ARGN})
endfunction ()

function (superbuild_unix_install_plugin name libdir paths)
  set(found FALSE)
  foreach (path IN LISTS paths)
    if (EXISTS "${superbuild_install_location}/${path}/${name}")
      _superbuild_unix_install_module("${superbuild_install_location}/${path}/${name}" "${path}" "${libdir}" ${ARGN})
      set(found TRUE)
      break ()
    endif ()
  endforeach ()

  if (NOT found)
    string(REPLACE ";" ", " paths_list "${paths}")
    message(FATAL_ERROR "Unable to find the ${name} plugin in ${paths_list}")
  endif ()
endfunction ()

function (superbuild_unix_install_python)
  set(values
    MODULE_DESTINATION
    LIBDIR)
  set(multivalues
    INCLUDE_REGEXES
    EXCLUDE_REGEXES
    SEARCH_DIRECTORIES
    MODULE_DIRECTORIES
    MODULES)
  cmake_parse_arguments(_install_python "${options}" "${values}" "${multivalues}" ${ARGN})

  set(fixup_bundle_arguments)

  if (NOT _install_python_LIBDIR)
    message(FATAL_ERROR "Cannot install Python modules without knowing where to put dependent libraries.")
  endif ()

  if (NOT _install_python_MODULE_DESTINATION)
    set(_install_python_MODULE_DESTINATION "/site-packages")
  endif ()

  foreach (include_regex IN LISTS _install_python_INCLUDE_REGEXES)
    set(fixup_bundle_arguments
      "${fixup_bundle_arguments} --include \"${include_regex}\"")
  endforeach ()

  foreach (exclude_regex IN LISTS _install_python_EXCLUDE_REGEXES)
    set(fixup_bundle_arguments
      "${fixup_bundle_arguments} --exclude \"${exclude_regex}\"")
  endforeach ()

  foreach (search_directory IN LISTS _install_python_SEARCH_DIRECTORIES)
    list(APPEND fixup_bundle_arguments
      --search "${search_directory}")
  endforeach ()

  install(CODE
    "include(\"${_superbuild_install_cmake_dir}/scripts/fixup_python.unix.cmake\")
    set(python_modules \"${_install_python_MODULES}\")
    set(module_directories \"${_install_python_MODULE_DIRECTORIES}\")

    set(fixup_bundle_arguments \"${fixup_bundle_arguments}\")
    set(bundle_destination \"\$ENV{DESTDIR}\${CMAKE_INSTALL_PREFIX}\")
    set(bundle_manifest \"${CMAKE_BINARY_DIR}/install.manifest\")
    set(libdir \"${_install_python_LIBDIR}\")

    foreach (python_module IN LISTS python_modules)
      superbuild_unix_install_python_module(\"\${CMAKE_INSTALL_PREFIX}\"
        \"\${python_module}\" \"\${module_directories}\" \"lib/python2.7${_install_python_MODULE_DESTINATION}\")
    endforeach ()"
    COMPONENT superbuild)
endfunction ()

function (superbuild_apple_create_app destination name binary)
  set(options
    CLEAN
    FAKE_PLUGIN_PATHS)
  set(multivalues
    INCLUDE_REGEXES
    EXCLUDE_REGEXES
    SEARCH_DIRECTORIES
    PLUGINS)
  cmake_parse_arguments(_create_app "${options}" "" "${multivalues}" ${ARGN})

  set(fixup_bundle_arguments)

  if (_create_app_CLEAN)
    set(fixup_bundle_arguments
      "${fixup_bundle_arguments} --clean")
  endif ()

  if (_create_app_FAKE_PLUGIN_PATHS)
    set(fixup_bundle_arguments
      "${fixup_bundle_arguments} --fake-plugin-paths")
  endif ()

  foreach (include_regex IN LISTS _create_app_INCLUDE_REGEXES)
    set(fixup_bundle_arguments
      "${fixup_bundle_arguments} --include \"${include_regex}\"")
  endforeach ()

  foreach (exclude_regex IN LISTS _create_app_EXCLUDE_REGEXES)
    set(fixup_bundle_arguments
      "${fixup_bundle_arguments} --exclude \"${exclude_regex}\"")
  endforeach ()

  foreach (search_directory IN LISTS _create_app_SEARCH_DIRECTORIES)
    set(fixup_bundle_arguments
      "${fixup_bundle_arguments} --search \"${search_directory}\"")
  endforeach ()

  foreach (plugin IN LISTS _create_app_PLUGINS)
    set(fixup_bundle_arguments
      "${fixup_bundle_arguments} --plugin \"${plugin}\"")
  endforeach ()

  install(CODE
    "execute_process(
      COMMAND \"${_superbuild_install_cmake_dir}/scripts/fixup_bundle.apple.py\"
              --bundle      \"${name}\"
              --destination \"${destination}\"
              ${fixup_bundle_arguments}
              --manifest    \"${CMAKE_BINARY_DIR}/${name}.manifest\"
              --type        executable
              \"${binary}\"
      RESULT_VARIABLE res
      ERROR_VARIABLE  err)

    if (res)
      message(FATAL_ERROR \"Failed to install ${name}:\n\${err}\")
    endif ()"
    COMPONENT superbuild)
endfunction ()

function (superbuild_apple_install_utility destination name binary)
  set(multivalues
    INCLUDE_REGEXES
    EXCLUDE_REGEXES
    SEARCH_DIRECTORIES)
  cmake_parse_arguments(_install_utility "" "" "${multivalues}" ${ARGN})

  set(fixup_bundle_arguments)

  foreach (include_regex IN LISTS _install_utility_INCLUDE_REGEXES)
    set(fixup_bundle_arguments
      "${fixup_bundle_arguments} --include \"${include_regex}\"")
  endforeach ()

  foreach (exclude_regex IN LISTS _install_utility_EXCLUDE_REGEXES)
    set(fixup_bundle_arguments
      "${fixup_bundle_arguments} --exclude \"${exclude_regex}\"")
  endforeach ()

  foreach (search_directory IN LISTS _install_utility_SEARCH_DIRECTORIES)
    set(fixup_bundle_arguments
      "${fixup_bundle_arguments} --search \"${search_directory}\"")
  endforeach ()

  install(CODE
    "execute_process(
      COMMAND \"${_superbuild_install_cmake_dir}/scripts/fixup_bundle.apple.py\"
              --bundle      \"${name}\"
              --destination \"${destination}\"
              ${fixup_bundle_arguments}
              --manifest    \"${CMAKE_BINARY_DIR}/${name}.manifest\"
              --type        utility
              \"${binary}\"
      RESULT_VARIABLE res
      ERROR_VARIABLE  err)

    if (res)
      message(FATAL_ERROR \"Failed to install ${name}:\n\${err}\")
    endif ()"
    COMPONENT superbuild)
endfunction ()

function (superbuild_apple_install_module destination name binary location)
  set(multivalues
    INCLUDE_REGEXES
    EXCLUDE_REGEXES
    SEARCH_DIRECTORIES)
  cmake_parse_arguments(_install_module "" "" "${multivalues}" ${ARGN})

  set(fixup_bundle_arguments)

  foreach (include_regex IN LISTS _install_module_INCLUDE_REGEXES)
    set(fixup_bundle_arguments
      "${fixup_bundle_arguments} --include \"${include_regex}\"")
  endforeach ()

  foreach (exclude_regex IN LISTS _install_module_EXCLUDE_REGEXES)
    set(fixup_bundle_arguments
      "${fixup_bundle_arguments} --exclude \"${exclude_regex}\"")
  endforeach ()

  foreach (search_directory IN LISTS _install_module_SEARCH_DIRECTORIES)
    set(fixup_bundle_arguments
      "${fixup_bundle_arguments} --search \"${search_directory}\"")
  endforeach ()

  install(CODE
    "execute_process(
      COMMAND \"${_superbuild_install_cmake_dir}/scripts/fixup_bundle.apple.py\"
              --bundle      \"${name}\"
              --destination \"${destination}\"
              ${fixup_bundle_arguments}
              --manifest    \"${CMAKE_BINARY_DIR}/${name}.manifest\"
              --location    \"${location}\"
              --type        module
              \"${binary}\"
      RESULT_VARIABLE res
      ERROR_VARIABLE  err)

    if (res)
      message(FATAL_ERROR \"Failed to install ${name}:\n\${err}\")
    endif ()"
    COMPONENT superbuild)
endfunction ()

function (superbuild_apple_install_python destination name)
  set(multivalues
    SEARCH_DIRECTORIES
    MODULE_DIRECTORIES
    MODULES)
  cmake_parse_arguments(_install_python "" "" "${multivalues}" ${ARGN})

  set(fixup_bundle_arguments)

  foreach (search_directory IN LISTS _install_python_SEARCH_DIRECTORIES)
    list(APPEND fixup_bundle_arguments
      --search "${search_directory}")
  endforeach ()

  install(CODE
    "include(\"${_superbuild_install_cmake_dir}/scripts/fixup_python.apple.cmake\")
    set(python_modules \"${_install_python_MODULES}\")
    set(module_directories \"${_install_python_MODULE_DIRECTORIES}\")

    set(fixup_bundle_arguments \"${fixup_bundle_arguments}\")
    set(bundle_destination \"${destination}\")
    set(bundle_name \"${name}\")
    set(bundle_manifest \"${CMAKE_BINARY_DIR}/${name}.manifest\")

    foreach (python_module IN LISTS python_modules)
      superbuild_apple_install_python_module(\"\${bundle_destination}/\${bundle_name}\"
        \"\${python_module}\" \"\${module_directories}\" \"Contents/Python\")
    endforeach ()"
    COMPONENT superbuild)
endfunction ()

function (_superbuild_windows_install_executable name destination paths)
  install(CODE
    "execute_process(
      COMMAND \"${CMAKE_COMMAND}\"
              \"-Dexecutable_name:PATH=${name}\"
              \"-Dsuperbuild_install_location:PATH=${superbuild_install_location}\"
              \"-Dextra_paths:STRING=${paths}\"
              \"-Ddestination:STRING=\${CMAKE_INSTALL_PREFIX}/${destination}\"
              \"-DCMAKE_INSTALL_PREFIX:STRING=\${CMAKE_INSTALL_PREFIX}\"
              -P \"${_superbuild_install_cmake_dir}/scripts/install_dependencies.windows.cmake\"
      RESULT_VARIABLE res
      ERROR_VARIABLE  err)

    if (res)
      message(FATAL_ERROR \"Failed to install ${name}:\n\${err}\")
    endif ()"
    COMPONENT superbuild)
endfunction ()

function (superbuild_windows_install_program name paths)
  _superbuild_windows_install_executable("${name}.exe" "bin" "${paths}" ${ARGN})

  install(
    PROGRAMS    "${superbuild_install_location}/bin/${name}.exe"
    DESTINATION "bin"
    COMPONENT   superbuild)
endfunction ()

function (superbuild_windows_install_plugin name destination paths)
  set(bin_var "bin")
  foreach (path IN LISTS bin_var paths)
    if (EXISTS "${superbuild_install_location}/${path}/${name}")
      install(
        FILES       "${superbuild_install_location}/${path}/${name}"
        DESTINATION "${destination}"
        COMPONENT   superbuild)
      break ()
    endif ()
  endforeach ()

  _superbuild_windows_install_executable("${name}" "${destination}" "${paths}" ${ARGN})
endfunction ()

function (superbuild_windows_install_python)
  set(singlevalues
    NAMESPACE
    DESTINATION)
  set(multivalues
    SEARCH_DIRECTORIES
    MODULE_DIRECTORIES
    MODULES)
  cmake_parse_arguments(_install_python "" "${singlevalues}" "${multivalues}" ${ARGN})

  set(subdir "")
  if (_install_python_NAMESPACE)
    set(subdir "${_install_python_NAMESPACE}")
  endif ()

  set(destination "bin/Lib/site-packages${subdir}")
  if (_install_python_DESTINATION)
    message(AUTHOR_WARNING "The DESTINATION option is deprecated; use NAMESPACE instead.")
    if (subdir)
      message(FATAL_ERROR "The DESTINATION and NAMESPACE options are incompatible!")
    endif ()
    set(destination "${_install_python_DESTINATION}")
  endif ()

  install(CODE
    "include(\"${_superbuild_install_cmake_dir}/scripts/fixup_python.windows.cmake\")
    set(python_modules \"${_install_python_MODULES}\")
    set(module_directories \"${_install_python_MODULE_DIRECTORIES}\")
    set(search_directories \"${_install_python_SEARCH_DIRECTORIES}\")

    set(superbuild_install_location \"${superbuild_install_location}\")

    foreach (python_module IN LISTS python_modules)
      superbuild_windows_install_python_module(\"\${CMAKE_INSTALL_PREFIX}\"
        \"\${python_module}\" \"\${module_directories}\" \"${destination}\")
    endforeach ()"
    COMPONENT superbuild)
endfunction ()
