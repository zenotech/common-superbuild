set(_superbuild_install_cmake_scripts_dir "${CMAKE_CURRENT_LIST_DIR}")

function (superbuild_unix_install_python_module destination module search_paths location)
  foreach (search_path IN LISTS search_paths)
    if (EXISTS "${search_path}/${module}.py")
      file(INSTALL
        FILES       "${search_path}/${module}.py"
        DESTINATION "${destination}/${location}")
    endif ()
    if (EXISTS "${search_path}/${module}.so")
      execute_process(
        COMMAND "${superbuild_python_executable}"
                "${_superbuild_install_cmake_scripts_dir}/fixup_bundle.unix.py"
                --destination "${bundle_destination}"
                ${fixup_bundle_arguments}
                --location    "${location}"
                --manifest    "${bundle_manifest}"
                --type        module
                --libdir      "${libdir}"
                --source      "${superbuild_install_location}"
                "${search_path}/${module}.so"
        RESULT_VARIABLE res
        ERROR_VARIABLE  err)

      if (res)
        message(FATAL_ERROR "Failed to install Python module ${module}:\n${err}")
      endif ()
    endif ()
    if (EXISTS "${search_path}/${module}/__init__.py")
      file(GLOB modules "${search_path}/${module}/*.py" "${search_path}/${module}/*.so")
      foreach (submodule IN LISTS modules)
        get_filename_component(submodule_name "${submodule}" NAME)
        string(REGEX REPLACE "\\.(py|so)$" "" submodule_name "${submodule_name}")
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
