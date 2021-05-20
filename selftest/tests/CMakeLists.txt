set(install_dir "${CMAKE_BINARY_DIR}/install")

if (APPLE)
  add_test(
    NAME apple-check-binaries
    COMMAND
      "${CMAKE_COMMAND}"
      "-Dinstall_dir=${install_dir}"
      "-Ddeployment_target=${CMAKE_OSX_DEPLOYMENT_TARGET}"
      "-Darch=${CMAKE_HOST_SYSTEM_PROCESSOR}"
      -P "${CMAKE_CURRENT_SOURCE_DIR}/apple-check.cmake")
endif ()
