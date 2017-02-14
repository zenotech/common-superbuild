if (NOT package_name OR NOT version)
  message(FATAL_ERROR "The package name and version must be specified.")
endif ()

set(CPACK_PACKAGE_NAME "${package_name}")
set(CPACK_PACKAGE_VENDOR "Kitware, Inc.")

set(CPACK_PACKAGE_INSTALL_DIRECTORY
  "${CPACK_PACKAGE_NAME} ${version}")
set(CPACK_SOURCE_PACKAGE_FILE_NAME
  "${CPACK_PACKAGE_NAME}-${version}")

if (superbuild_is_64bit)
  set(CPACK_SYSTEM_NAME "win64")
else ()
  set(CPACK_SYSTEM_NAME "win32")
endif ()
if (NOT DEFINED CPACK_PACKAGE_FILE_NAME)
  set(CPACK_PACKAGE_FILE_NAME
    "${CPACK_SOURCE_PACKAGE_FILE_NAME}-${CPACK_SYSTEM_NAME}")
endif ()
