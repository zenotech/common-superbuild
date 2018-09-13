superbuild_add_project(pythonzope
  CONFIGURE_COMMAND
    ""
  BUILD_COMMAND
    ""
  INSTALL_COMMAND
    "${CMAKE_COMMAND}"
      "-Dinstall_dir=<INSTALL_DIR>"
      -P "${CMAKE_CURRENT_LIST_DIR}/scripts/pythonzope.install.cmake")
