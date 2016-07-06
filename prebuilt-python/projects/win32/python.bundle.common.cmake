if (NOT package_name OR NOT version)
  message(FATAL_ERROR "The package name and version must be specified.")
endif ()

set(CPACK_PACKAGE_VENDOR "Kitware, Inc.")

SET(CPACK_PACKAGE_INSTALL_DIRECTORY
  "${package_name} ${version}")
set(CPACK_SOURCE_PACKAGE_FILE_NAME
  "${package_name}-${version}")

if (NOT DEFINED CPACK_SYSTEM_NAME)
  set(CPACK_SYSTEM_NAME ${CMAKE_SYSTEM_NAME}-${CMAKE_SYSTEM_PROCESSOR})
endif ()
if (CPACK_SYSTEM_NAME MATCHES "Windows")
  if (superbuild_is_64bit)
    set(CPACK_SYSTEM_NAME win64)
  else ()
    set(CPACK_SYSTEM_NAME win32)
  endif ()
endif ()
if (NOT DEFINED CPACK_PACKAGE_FILE_NAME)
  set(CPACK_PACKAGE_FILE_NAME
    "${CPACK_SOURCE_PACKAGE_FILE_NAME}-${CPACK_SYSTEM_NAME}")
endif ()
