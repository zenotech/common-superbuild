set(ispc_fix_lib64 0)
if (UNIX AND NOT APPLE)
  set(ispc_fix_lib64 1)
endif ()

set(ispc_fix_library_ids 0)
if (APPLE AND ospray_SOURCE_SELECTION STREQUAL "2.12.0")
  set(ispc_fix_library_ids 1)
endif ()

set(ispc_install_ispcrt 0)
if (ospray_SOURCE_SELECTION STREQUAL "2.12.0")
  set(ispc_install_ispcrt 1)
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
      -Dfix_library_ids=${ispc_fix_library_ids}
      -Dinstall_ispcrt=${ispc_install_ispcrt}
      -P "${CMAKE_CURRENT_LIST_DIR}/scripts/ispc.install.cmake"
  INSTALL_DEPENDS
      "${CMAKE_CURRENT_LIST_DIR}/scripts/ispc.install.cmake")
