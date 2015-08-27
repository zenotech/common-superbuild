if (python_enabled)
  superbuild_add_dummy_project(zlib
    DEPENDS python)

  superbuild_add_extra_cmake_args(
    -DZLIB_LIBRARY:FILEPATH=<INSTALL_DIR>/lib/zlib.lib
    -DZLIB_INCLUDE_DIR:PATH=<INSTALL_DIR>/include)
else ()
  include("${CMAKE_CURRENT_LIST_DIR}/../zlib.cmake")
endif ()
