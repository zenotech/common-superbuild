# get_filename_component on is missing the 'component' (path)
if (WIN32)
  superbuild_apply_patch(szip add-filename-component-win32
    "Fix get_filename_component call")
else ()
  superbuild_apply_patch(szip add-filename-component
    "Fix get_filename_component call")
endif ()

superbuild_add_extra_cmake_args(
  -DSZIP_LIBRARY:FILEPATH=<INSTALL_DIR>/lib/${CMAKE_SHARED_LIBRARY_PREFIX}sz${CMAKE_SHARED_LIBRARY_SUFFIX}
  -DSZIP_INCLUDE_DIR:FILEPATH=<INSTALL_DIR>/include)
