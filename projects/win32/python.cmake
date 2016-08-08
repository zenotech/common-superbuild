superbuild_add_project(python
  BUILD_IN_SOURCE 1
  CONFIGURE_COMMAND ""
  BUILD_COMMAND     ""
  INSTALL_COMMAND
    "${CMAKE_COMMAND}"
      "-Dinstall_location:PATH=<INSTALL_DIR>"
      -P "${CMAKE_CURRENT_LIST_DIR}/scripts/python.install.cmake")

set(superbuild_python_executable "${superbuild_install_location}/bin/python"
  CACHE INTERNAL "")
