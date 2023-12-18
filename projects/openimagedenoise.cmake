set(openimagedenoise_options)
if (UNIX AND NOT APPLE)
  list(APPEND openimagedenoise_options
    -DCMAKE_INSTALL_RPATH:STRING=<INSTALL_DIR>/lib)
endif ()

superbuild_add_project(openimagedenoise
  DEPENDS tbb cxx11 ispc python3
  LICENSE_FILES
    LICENSE.txt
  SPDX_LICENSE_IDENTIFIER
    Apache-2.0
  SPDX_COPYRIGHT_TEXT
    "Copyright Intel Corporation"
  CMAKE_ARGS
    -DOIDN_APPS:BOOL=OFF
    -DCMAKE_INSTALL_NAME_DIR:PATH=<INSTALL_DIR>/lib
    -DCMAKE_INSTALL_LIBDIR:STRING=lib
    ${openimagedenoise_options}
)
