set(CPACK_PACKAGE_FILE_NAME "${osmesa_PACKAGE_FILE_NAME}-windows-${CMAKE_SYSTEM_PROCESSOR}")

set(library_paths
  "${superbuild_install_location}/lib")

set(mesa_libraries
  libglapi
  OSMesa)

foreach (mesa_library IN LISTS mesa_libraries)
  superbuild_windows_install_plugin("${superbuild_install_location}/bin/${mesa_library}.dll"
    "bin"
    "bin"
    LOCATION "bin")
endforeach ()

set(osmesa_sdk_files
  include/KHR/khrplatform.h
  include/GL/gl.h
  include/GL/glcorearb.h
  include/GL/glext.h
  include/GL/osmesa.h

  lib/libglapi.lib
  lib/osmesa.lib

  share/drirc.d/00-mesa-defaults.conf

  lib/pkgconfig/osmesa.pc)

foreach (osmesa_sdk_file IN LISTS osmesa_sdk_files)
  get_filename_component(osmesa_sdk_file_dir "${osmesa_sdk_file}" DIRECTORY)
  install(
    FILES       "${superbuild_install_location}/${osmesa_sdk_file}"
    DESTINATION "${osmesa_sdk_file_dir}"
    COMPONENT   superbuild)
endforeach ()

# Install licenses
set(license_projects
  llvm
  osmesa)
foreach (project IN LISTS license_projects)
  install(
    DIRECTORY "${superbuild_install_location}/share/licenses/${project}"
    DESTINATION "share/licenses"
    COMPONENT   "licenses")
endforeach ()
