set(ispc_fix_lib64 0)
if (UNIX AND NOT APPLE)
  set(ispc_fix_lib64 1)
endif ()

superbuild_add_project(ispc
  LICENSE_FILES
    LICENSE.txt
  CONFIGURE_COMMAND ""
  BUILD_COMMAND ""
  INSTALL_COMMAND
    "${CMAKE_COMMAND}"
      -Dinstall_location=<INSTALL_DIR>
      -Dsource_dir=<SOURCE_DIR>
      -Dbinary_dir=<BINARY_DIR>
      -Dexe_suffix=${CMAKE_EXECUTABLE_SUFFIX}
      -Dfix_lib64=${ispc_fix_lib64}
      -P "${CMAKE_CURRENT_LIST_DIR}/scripts/ispc.install.cmake"
  INSTALL_DEPENDS
      "${CMAKE_CURRENT_LIST_DIR}/scripts/ispc.install.cmake")
