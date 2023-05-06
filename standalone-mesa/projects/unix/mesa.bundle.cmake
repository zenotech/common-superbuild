set(CPACK_PACKAGE_FILE_NAME "${mesa_PACKAGE_FILE_NAME}-linux-${CMAKE_SYSTEM_PROCESSOR}")

set(library_paths
  "${superbuild_install_location}/lib")

set(mesa_libraries
  GL)
if (mesa_USE_SWR)
  string(REPLACE "," ";" _mesa_SWR_ARCH "${mesa_SWR_ARCH}")
  list(LENGTH _mesa_SWR_ARCH mesa_num_swr_archs)
  if (mesa_num_swr_archs GREATER 1)
    foreach (arch IN LISTS _mesa_SWR_ARCH)
      string(TOUPPER "${arch}" ARCH)
      list(APPEND mesa_libraries swr${ARCH})
    endforeach ()
  endif ()
endif ()

foreach (mesa_library IN LISTS mesa_libraries)
  file(GLOB mesa_library_filenames
    RELATIVE "${superbuild_install_location}/lib"
    "${superbuild_install_location}/lib/lib${mesa_library}.so*")

  foreach (mesa_library_filename IN LISTS mesa_library_filenames)
    superbuild_unix_install_module("${mesa_library_filename}"
      "lib"
      "lib"
      LOADER_PATHS  "${library_paths}"
      LOCATION      "lib")
  endforeach ()
endforeach ()

# Install licenses
set(license_projects
  llvm
  mesa)
foreach (project IN LISTS license_projects)
  install(
    DIRECTORY "${superbuild_install_location}/share/licenses/${project}"
    DESTINATION "share/licenses"
    COMPONENT   "licenses")
endforeach ()
