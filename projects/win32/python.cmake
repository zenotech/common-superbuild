superbuild_add_project(python
  BUILD_IN_SOURCE 1
  CONFIGURE_COMMAND ""
  BUILD_COMMAND     ""
  INSTALL_COMMAND
    "${CMAKE_COMMAND}"
      "-Dinstall_location:PATH=<INSTALL_DIR>"
      -P "${CMAKE_CURRENT_LIST_DIR}/scripts/python.install.cmake")

if (python_enabled)
  set(superbuild_python_executable "${superbuild_install_location}/bin/python.exe"
    CACHE INTERNAL "")
else ()
  set(superbuild_python_executable ""
    CACHE INTERNAL "")
endif ()

superbuild_add_extra_cmake_args(
  -DPython2_EXECUTABLE:FILEPATH=<INSTALL_DIR>/bin/python.exe
  -DPython2_INCLUDE_DIR:PATH=<INSTALL_DIR>/Include/python2.7
  -DPython2_LIBRARY:FILEPATH=<INSTALL_DIR>/lib/python27.lib

  -DPYTHON_EXECUTABLE:FILEPATH=<INSTALL_DIR>/bin/python.exe
  -DPYTHON_INCLUDE_DIR:PATH=<INSTALL_DIR>/Include/python2.7
  -DPYTHON_LIBRARY:FILEPATH=<INSTALL_DIR>/lib/python27.lib)
