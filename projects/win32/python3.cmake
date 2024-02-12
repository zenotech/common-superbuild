set(python3_optional_depends)
if (_superbuild_enable_openssl)
  list(APPEND python3_optional_depends
    openssl)
endif ()

superbuild_add_project(python3
  DEPENDS_OPTIONAL sqlite xz ${python3_optional_depends}
  CAN_USE_SYSTEM
  BUILD_IN_SOURCE 1
  LICENSE_FILES
    LICENSE.txt
  SPDX_LICENSE_IDENTIFIER
    Python-2.0
  SPDX_COPYRIGHT_TEXT
    "Copyright (c) 2001, 2002, 2003, 2004, 2005, 2006, 2007, 2008, 2009, 2010, 2011, 2012, 2013, 2014, 2015, 2016, 2017, 2018, 2019, 2020, 2021, 2022, 2023 Python Software Foundation"
  CONFIGURE_COMMAND ""
  BUILD_COMMAND ""
  INSTALL_COMMAND
    "${CMAKE_COMMAND}"
      "-Dinstall_location:PATH=<INSTALL_DIR>/Python"
      "-Dkeep_openssl:BOOL=${openssl_enabled}"
      -P "${CMAKE_CURRENT_LIST_DIR}/scripts/python3.install.cmake"
  INSTALL_DEPENDS
    "${CMAKE_CURRENT_LIST_DIR}/scripts/python3.install.cmake")

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

set(superbuild_python_version "${python3_SOURCE_SELECTION}"
  CACHE INTERNAL "")

# strip the "." from the version to get a number for the library name
string(REPLACE "." "" libver "${python3_SOURCE_SELECTION}")
set(superbuild_python_lib "python${libver}.lib")

superbuild_add_extra_cmake_args(
  -DPython3_EXECUTABLE:FILEPATH=<INSTALL_DIR>/Python/python.exe
  -DPython3_INCLUDE_DIR:PATH=<INSTALL_DIR>/Python/include/
  -DPython3_LIBRARY:FILEPATH=<INSTALL_DIR>/Python/libs/${superbuild_python_lib}
  -DPython3_LIBRARY_RELEASE:FILEPATH=<INSTALL_DIR>/Python/libs/${superbuild_python_lib}
  -DPython3_FIND_REGISTRY:STRING=NEVER

  -DPython_EXECUTABLE:FILEPATH=<INSTALL_DIR>/Python/python.exe
  -DPython_INCLUDE_DIR:PATH=<INSTALL_DIR>/Python/include/
  -DPython_LIBRARY:FILEPATH=<INSTALL_DIR>/Python/libs/${superbuild_python_lib}
  -DPython_LIBRARY_RELEASE:FILEPATH=<INSTALL_DIR>/Python/libs/${superbuild_python_lib}
  -DPython_FIND_REGISTRY:STRING=NEVER

  -DPYTHON_EXECUTABLE:FILEPATH=<INSTALL_DIR>/Python/python.exe
  -DPYTHON_INCLUDE_DIR:PATH=<INSTALL_DIR>/Python/include/
  -DPYTHON_LIBRARY:FILEPATH=<INSTALL_DIR>/Python/libs/${superbuild_python_lib}
  -DPYTHON_LIBRARY_RELEASE:FILEPATH=<INSTALL_DIR>/Python/libs/${superbuild_python_lib}
  -DPYTHON_FIND_REGISTRY:STRING=NEVER
)

set(modules_to_remove
  ctypes.test
  distutils.tests
  lib2to3.tests
  unittest.test
  )
_superbuild_remove_python_modules("${modules_to_remove}")
