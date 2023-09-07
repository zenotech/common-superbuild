# Install compiler.
file(INSTALL
  "${source_dir}/bin/ispc${exe_suffix}"
  DESTINATION "${install_location}/bin"
  USE_SOURCE_PERMISSIONS)

# Install runtime SDK.
file(INSTALL
  "${source_dir}/bin/"
  DESTINATION "${install_location}/bin"
  USE_SOURCE_PERMISSIONS
  PATTERN "*.dll")
file(INSTALL
  "${source_dir}/include/ispcrt"
  DESTINATION "${install_location}/include"
  USE_SOURCE_PERMISSIONS)

if (fix_lib64)
  file(INSTALL
    "${source_dir}/lib64/" # Trailing slash for "contents of"
    DESTINATION "${install_location}/lib"
    USE_SOURCE_PERMISSIONS
    # Exclude the package.
    PATTERN "cmake" EXCLUDE)

  # Replace "lib64" with "lib" in package configuration.
  file(GLOB_RECURSE cmake_files "${source_dir}/lib64/cmake/*")
  file(REMOVE_RECURSE "${binary_dir}/cmake-fixups")
  file(MAKE_DIRECTORY "${binary_dir}/cmake-fixups")
  set(cmake_package_dir)
  foreach (file IN LISTS cmake_files)
    if (NOT cmake_package_dir)
      get_filename_component(cmake_package_dir "${file}" DIRECTORY)
      get_filename_component(cmake_package_dir "${cmake_package_dir}" NAME)
    endif ()
    file(READ "${file}" contents)
    string(REPLACE "lib64" "lib" contents "${contents}")
    get_filename_component(file_name "${file}" NAME)
    file(WRITE "${binary_dir}/cmake-fixups/${file_name}" "${contents}")
  endforeach ()

  file(INSTALL
    "${binary_dir}/cmake-fixups/"
    DESTINATION "${install_location}/lib/cmake/${cmake_package_dir}")
else ()
  file(INSTALL
    "${source_dir}/lib/"
    DESTINATION "${install_location}/lib"
    USE_SOURCE_PERMISSIONS)

  if (APPLE)
    set(libraries
      libispcrt.1.dylib
      libispcrt_device_cpu.1.dylib)
    foreach (library IN LISTS libraries)
      execute_process(
        COMMAND
          install_name_tool
          -id "${install_location}/lib/${library}"
          "${install_location}/lib/${library}"
        RESULT_VARIABLE res
        OUTPUT_VARIABLE out
        ERROR_VARIABLE err)
      if (res)
        message(FATAL_ERROR
          "Failed to update the library id of ${library}")
      endif ()
    endforeach ()
  endif ()
endif ()
