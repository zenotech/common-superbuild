set(_superbuild_install_cmake_scripts_dir "${CMAKE_CURRENT_LIST_DIR}")

function (superbuild_windows_install_python_module destination module search_paths location)
  foreach (search_path IN LISTS search_paths)
    if (EXISTS "${search_path}/${module}.py")
      file(INSTALL
        FILES       "${search_path}/${module}.py"
        DESTINATION "${destination}/${location}")
    endif ()

    if (EXISTS "${search_path}/${module}.pyd")
      set(module_pyd "${search_path}/${module}.pyd")
    else ()
      # some modules have names that are prefixed with build specific extension
      # e.g. `kiwisolver.cpython-37m-x86_64.pyd`, so we do a glob if
      # direct lookup fails.
      file(GLOB module_pyd LIST_DIRECTORIES false "${search_path}/${module}.*.pyd")
      if (module_pyd)
        list(GET module_pyd 0 module_pyd)
      endif()
    endif ()

    if (EXISTS "${module_pyd}")
      execute_process(
        COMMAND "${superbuild_python_executable}"
                "${_superbuild_install_cmake_scripts_dir}/fixup_bundle.windows.py"
                --destination "${bundle_destination}"
                ${fixup_bundle_arguments}
                --location    "${location}"
                --manifest    "${bundle_manifest}"
                --type        module
                --libdir      "${location}"
                "${module_pyd}"
        RESULT_VARIABLE res
        ERROR_VARIABLE  err)

      if (res)
        message(FATAL_ERROR "Failed to install Python module ${module}:\n${err}")
      endif ()
    endif ()
    if (IS_DIRECTORY "${search_path}/${module}")
      file(GLOB modules "${search_path}/${module}/*.py" "${search_path}/${module}/*.pyd")
      foreach (submodule IN LISTS modules)
        get_filename_component(submodule_name "${submodule}" NAME)
        string(REGEX REPLACE "\\.(py|pyd)$" "" submodule_name "${submodule_name}")
        superbuild_windows_install_python_module("${destination}"
          "${submodule_name}" "${search_path}/${module}" "${location}/${module}")
      endforeach ()
      file(GLOB packages "${search_path}/${module}/*")
      foreach (subpackage IN LISTS packages)
        if (IS_DIRECTORY "${subpackage}" AND NOT subpackage STREQUAL "__pycache__")
          get_filename_component(subpackage_name "${subpackage}" NAME)
          superbuild_windows_install_python_module("${destination}"
            "${subpackage_name}" "${search_path}/${module}" "${location}/${module}")
        endif ()
      endforeach ()
    endif ()
  endforeach ()
endfunction ()
