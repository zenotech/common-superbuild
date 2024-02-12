superbuild_add_project(bzip2
  CAN_USE_SYSTEM
  LICENSE_FILES
    LICENSE
  SPDX_LICENSE_IDENTIFIER
    BSD-4-Clause
  SPDX_COPYRIGHT_TEXT
    "copyright (C) 1996-2019 Julian R Seward"
  CMAKE_ARGS
    -DBUILD_SHARED_LIBS:BOOL=${BUILD_SHARED_LIBS}
    -DCMAKE_INSTALL_LIBDIR:PATH=lib)

superbuild_apply_patch(bzip2 add-cmake
  "Add a CMake build system to bzip2")
