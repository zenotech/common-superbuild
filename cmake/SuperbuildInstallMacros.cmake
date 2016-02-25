set(_superbuild_install_cmake_dir "${CMAKE_CURRENT_LIST_DIR}")

function (_superbuild_unix_install_executable name destination paths)
  install(CODE
    "execute_process(
      COMMAND \"${CMAKE_COMMAND}\"
              \"-Dexecutable_name:PATH=${name}\"
              \"-Dsuperbuild_install_location:PATH=${superbuild_install_location}\"
              \"-Dtarget_path:PATH=${destination}\"
              \"-Dextra_paths:STRING=${paths}\"
              \"-DCMAKE_INSTALL_PREFIX:STRING=\${CMAKE_INSTALL_PREFIX}\"
              -P \"${_superbuild_install_cmake_dir}/superbuild_unix_install_dependencies.cmake\"
      RESULT_VARIABLE res
      ERROR_VARIABLE  err)

    if (res)
      message(FATAL_ERROR \"Failed to install ${name}:\n${err}\")
    endif ()"
    COMPONENT superbuild)
endfunction ()

function (superbuild_unix_install_program name paths)
  foreach (path IN LISTS paths)
    if (EXISTS "${superbuild_install_location}/lib/${path}/${name}")
      install(
        PROGRAMS    "${superbuild_install_location}/lib/${path}/${name}"
        DESTINATION "lib/${path}"
        COMPONENT   superbuild)
      set(binary_path "${path}")
      break ()
    endif ()
  endforeach ()

  _superbuild_unix_install_executable("${name}" "${binary_path}" "${paths}" ${ARGN})

  install(
    PROGRAMS    "${superbuild_install_location}/bin/${name}"
    DESTINATION "bin"
    COMPONENT   superbuild)
endfunction ()

function (superbuild_unix_install_plugin name destination paths subdir dest_subdir)
  _superbuild_unix_install_executable("${name}" "${destination}" "${paths}" ${ARGN})

  install(
    FILES       "${superbuild_install_location}/lib/${subdir}${name}"
    DESTINATION "lib/${dest_subdir}"
    COMPONENT   superbuild)
endfunction ()
