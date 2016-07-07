superbuild_add_project(matplotlib
  CAN_USE_SYSTEM
  DEPENDS python numpy png freetype
  BUILD_IN_SOURCE 1
  CONFIGURE_COMMAND
    "${CMAKE_COMMAND}"
      "-DPATCHES_DIR:PATH=${common-superbuild_SOURCE_DIR}/projects/patches"
      "-DSOURCE_DIR:PATH=<SOURCE_DIR>"
      "-DINSTALL_DIR:PATH=<INSTALL_DIR>"
      -P "${common-superbuild_SOURCE_DIR}/projects/scripts/matplotlib.patch.cmake"
  BUILD_COMMAND
    "${CMAKE_COMMAND}"
      "-DPYTHON_EXECUTABLE:PATH=${superbuild_python_executable}"
      "-DSOURCE_DIR:PATH=<SOURCE_DIR>"
      "-DINSTALL_DIR:PATH=<INSTALL_DIR>"
      "-DINSTALL_PREFIX:PATH=<INSTALL_DIR>/bin"
      -P "${common-superbuild_SOURCE_DIR}/projects/scripts/matplotlib.build.cmake"
  INSTALL_COMMAND "")
