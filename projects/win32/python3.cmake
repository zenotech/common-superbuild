superbuild_add_project(python3
  CAN_USE_SYSTEM
  BUILD_IN_SOURCE 1
  CONFIGURE_COMMAND ""
  BUILD_COMMAND ""
  INSTALL_COMMAND
    "${CMAKE_COMMAND}"
      "-Dinstall_location:PATH=<INSTALL_DIR>/Python"
      -P "${CMAKE_CURRENT_LIST_DIR}/scripts/python3.install.cmake")

if (python3_enabled)
  set(superbuild_python_executable "${superbuild_install_location}/Python/python.exe"
    CACHE INTERNAL "")
  set(superbuild_python_pip "${superbuild_python_executable}" -m pip
    CACHE INTERNAL "")
else ()
  set(superbuild_python_executable ""
    CACHE INTERNAL "")
  set(superbuild_python_pip ""
    CACHE INTERNAL "")
endif ()

set(superbuild_python_version "3.8"
  CACHE INTERNAL "")

superbuild_add_extra_cmake_args(
  -DPython3_EXECUTABLE:FILEPATH=<INSTALL_DIR>/Python/python.exe
  -DPython3_INCLUDE_DIR:PATH=<INSTALL_DIR>/Python/include/
  -DPython3_LIBRARY:FILEPATH=<INSTALL_DIR>/Python/libs/python38.lib
  -DPython3_LIBRARY_RELEASE:FILEPATH=<INSTALL_DIR>/Python/libs/python38.lib
  -DPython3_FIND_REGISTRY:STRING=NEVER

  -DPYTHON_EXECUTABLE:FILEPATH=<INSTALL_DIR>/Python/python.exe
  -DPYTHON_INCLUDE_DIR:PATH=<INSTALL_DIR>/Python/include/
  -DPYTHON_LIBRARY:FILEPATH=<INSTALL_DIR>/Python/libs/python38.lib
  -DPYTHON_LIBRARY_RELEASE:FILEPATH=<INSTALL_DIR>/Python/libs/python38.lib
  -DPYTHON_FIND_REGISTRY:STRING=NEVER
)
