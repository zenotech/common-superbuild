set(_superbuild_install_cmake_scripts_dir "${CMAKE_CURRENT_LIST_DIR}")

function (superbuild_unix_install_python_module destination module search_paths location)
  foreach (search_path IN LISTS search_paths)
    if (EXISTS "${search_path}/${module}.py")
      file(INSTALL
        FILES       "${search_path}/${module}.py"
        DESTINATION "${destination}/${location}")
    elseif (EXISTS "${search_path}/${module}.so")
      execute_process(
        COMMAND "${CMAKE_COMMAND}"
                "-Dexecutable_name:PATH=${module}.so"
                "-Dsuperbuild_install_location:PATH=${superbuild_install_location}"
                "-Dtarget_path:PATH=cmb-${target_path}"
                "-Dextra_paths:STRING=${search_path};${search_directories}"
                "-DCMAKE_INSTALL_PREFIX:STRING=${CMAKE_INSTALL_PREFIX}"
                -P "${_superbuild_install_cmake_scripts_dir}/install_dependencies.unix.cmake"
        RESULT_VARIABLE res
        ERROR_VARIABLE  err)

      if (res)
        message(FATAL_ERROR "Failed to install Python module ${module}:\n${err}")
      endif ()

      file(INSTALL
        FILES       "${search_path}/${module}.so"
        DESTINATION "${CMAKE_INSTALL_PREFIX}/${location}")
    elseif (EXISTS "${search_path}/${module}/__init__.py")
      file(GLOB modules "${search_path}/${module}/*.py" "${search_path}/${module}/*.so")
      foreach (submodule IN LISTS modules)
        get_filename_component(submodule_name "${submodule}" NAME_WE)
        superbuild_unix_install_python_module("${destination}"
          "${submodule_name}" "${search_path}/${module}" "${location}/${module}")
      endforeach ()
      file(GLOB packages "${search_path}/${module}/*/__init__.py")
      foreach (subpackage IN LISTS packages)
        get_filename_component(subpackage "${subpackage}" DIRECTORY)
        get_filename_component(subpackage_name "${subpackage}" NAME)
        superbuild_unix_install_python_module("${destination}"
          "${subpackage_name}" "${search_path}/${module}" "${location}/${module}")
      endforeach ()
    endif ()
  endforeach ()
endfunction ()
