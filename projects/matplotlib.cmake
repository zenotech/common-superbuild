superbuild_add_project(matplotlib
  CAN_USE_SYSTEM
  DEPENDS python numpy png freetype
  BUILD_IN_SOURCE 1
  CONFIGURE_COMMAND
    "${CMAKE_COMMAND}"
      "-DPATCHES_DIR:PATH=${CMAKE_CURRENT_LIST_DIR}/patches/"
      "-DSOURCE_DIR:PATH=<SOURCE_DIR>"
      "-DINSTALL_DIR:PATH=<INSTALL_DIR>"
      -P "${CMAKE_CURRENT_LIST_DIR}/scripts/matplotlib.patch.cmake"
  BUILD_COMMAND
    "${CMAKE_COMMAND}"
      "-DPYTHON_EXECUTABLE:PATH=${superbuild_python_executable}"
      "-DMATPLOTLIB_SOURCE_DIR:PATH=<SOURCE_DIR>"
      "-DMATPLOTLIB_INSTALL_DIR:PATH=<INSTALL_DIR>"
      "-DNUMPY_INSTALL_DIR:PATH=<INSTALL_DIR>"
      -P "${CMAKE_CURRENT_LIST_DIR}/scripts/matplotlib.build.cmake"
  INSTALL_COMMAND "")
