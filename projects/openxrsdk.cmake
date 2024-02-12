set(openxrsdk_options)
if (UNIX AND NOT APPLE)
  list(APPEND openxrsdk_options
    -DCMAKE_INSTALL_RPATH:STRING=<INSTALL_DIR>/lib)
endif ()

superbuild_add_project(openxrsdk
  DEPENDS
    jsoncpp
    cxx17
  LICENSE_FILES
    LICENSE
    README.md
  SPDX_LICENSE_IDENTIFIER
    Apache-2.0
  SPDX_COPYRIGHT_TEXT
    "Copyright (c) 2017-2023, The Khronos Group Inc."
  CMAKE_ARGS
    -DDYNAMIC_LOADER:BOOL=ON
    -DBUILD_WITH_STD_FILESYSTEM:BOOL=OFF
    -DCMAKE_INSTALL_PREFIX:PATH=<INSTALL_DIR>
    -DCMAKE_INSTALL_LIBDIR:STRING=lib
    ${openxrsdk_options}
  )
