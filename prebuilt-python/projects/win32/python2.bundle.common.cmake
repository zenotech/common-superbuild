if (NOT package_name OR NOT version)
  message(FATAL_ERROR "The package name and version must be specified.")
endif ()

set(CPACK_PACKAGE_NAME "${package_name}")
set(CPACK_PACKAGE_VENDOR "Kitware, Inc.")

set(CPACK_PACKAGE_INSTALL_DIRECTORY
  "${CPACK_PACKAGE_NAME} ${version}")
set(CPACK_SOURCE_PACKAGE_FILE_NAME
  "${CPACK_PACKAGE_NAME}-${version}")

set(CPACK_SYSTEM_NAME "win64")
if (NOT DEFINED CPACK_PACKAGE_FILE_NAME)
  set(CPACK_PACKAGE_FILE_NAME
    "${CPACK_SOURCE_PACKAGE_FILE_NAME}-${CPACK_SYSTEM_NAME}")
endif ()

# Skip installing the MSVC runtime.
set(superbuild_bundle_skip_system_libraries TRUE)

# Clear the manifest since only Python modules are installed.
file(WRITE "${CMAKE_CURRENT_BINARY_DIR}/install.manifest" "{}\n")
