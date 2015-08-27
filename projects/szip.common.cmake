# get_filename_component on line 10 is missing the 'component' (path).
# this patch fixes that.
superbuild_project_add_step(szip-patch-install
  COMMAND "${CMAKE_COMMAND}" -E copy_if_different
          "${CMAKE_CURRENT_LIST_DIR}/patches/szip.config.cmake.SZIP-config.cmake.install.in"
          <SOURCE_DIR>/config/cmake/SZIP-config.cmake.install.in
  DEPENDEES update # do after update
  DEPENDERS patch) # do before patch

superbuild_add_extra_cmake_args(
  -DSZIP_LIBRARY:FILEPATH=<INSTALL_DIR>/lib/${CMAKE_SHARED_LIBRARY_PREFIX}sz${CMAKE_SHARED_LIBRARY_SUFFIX}
  -DSZIP_INCLUDE_DIR:FILEPATH=<INSTALL_DIR>/include)
