# Build and install:
superbuild_add_project(nlohmannjson
  DEPENDS cxx11
  LICENSE_FILES
    LICENSE.MIT
  SPDX_LICENSE_IDENTIFIER
    MIT
  SPDX_COPYRIGHT_TEXT
    "Copyright (c) 2013-2021 Niels Lohmann"
  CMAKE_ARGS
    -DENABLE_TESTING:BOOL=OFF
    -DBUILD_TESTING:BOOL=OFF
    -DJSON_BuildTests:BOOL=OFF
    -DCMAKE_INSTALL_LIBDIR:STRING=lib
)

# Provide our location to dependent projects:
superbuild_add_extra_cmake_args(
  -Dnlohmann_json_DIR:PATH=<INSTALL_DIR>/lib/cmake/nlohmann_json
)
