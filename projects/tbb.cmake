superbuild_add_project(tbb
  CAN_USE_SYSTEM
  LICENSE_FILES
    LICENSE.txt
  SPDX_LICENSE_IDENTIFIER
    Apache-2.0
  SPDX_COPYRIGHT_TEXT
    "Copyright (c) 2005-2023 Intel Corporation"
  CMAKE_ARGS
    -DCMAKE_INSTALL_NAME_DIR:PATH=<INSTALL_DIR>/lib
    -DCMAKE_INSTALL_LIBDIR:STRING=lib
    -DTBB_TEST:BOOL=OFF)

superbuild_add_extra_cmake_args(
  -DTBB_ROOT:PATH=<INSTALL_DIR>)
