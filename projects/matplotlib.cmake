# BUILD_COMMAND can't handle spaces in the executable name. Worse, for
# Makefile builds, it writes out a cmake script where ${CMAKE_COMMAND} can
# be expanded, while on ninja builds it just adds a new build rule to
# the build.ninja file, where ${CMAKE_COMMAND} cannot be interpreted. This
# should work if either (a) A Makefile generator is used with or without
# spaces in the CMake command path, or (b) Ninja is used with no spaces
# in the path.
set(matplotlib_cmake_command "\\\${CMAKE_COMMAND}")
if (CMAKE_GENERATOR STREQUAL "Ninja")
  set(matplotlib_cmake_command "${CMAKE_COMMAND}")
endif ()

superbuild_add_project(matplotlib
  CAN_USE_SYSTEM
  DEPENDS python numpy png freetype
  BUILD_IN_SOURCE 1
  CONFIGURE_COMMAND
    "${matplotlib_cmake_command}"
      "-DPATCHES_DIR:PATH=${CMAKE_CURRENT_LIST_DIR}/patches/"
      "-DPATCH_OUTPUT_DIR:PATH=${CMAKE_BINARY_DIR}"
      "-DSOURCE_DIR:PATH=<SOURCE_DIR>"
      "-DINSTALL_DIR:PATH=<INSTALL_DIR>"
      -P "${CMAKE_CURRENT_LIST_DIR}/scripts/matplotlib.patch.cmake"
  BUILD_COMMAND
    "${matplotlib_cmake_command}"
      "-DPYTHON_EXECUTABLE:PATH=${superbuild_python_executable}"
      "-DMATPLOTLIB_SOURCE_DIR:PATH=<SOURCE_DIR>"
      "-DMATPLOTLIB_INSTALL_DIR:PATH=<INSTALL_DIR>"
      "-DNUMPY_INSTALL_DIR:PATH=<INSTALL_DIR>"
      -P "${CMAKE_CURRENT_LIST_DIR}/scripts/matplotlib.build.cmake"
  INSTALL_COMMAND "")
