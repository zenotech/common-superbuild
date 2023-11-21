superbuild_add_project(flexbison
  LICENSE_FILES
    README.md
  CONFIGURE_COMMAND ""
  BUILD_COMMAND ""
  INSTALL_COMMAND
    "${CMAKE_COMMAND}"
      -Dinstall_location=<INSTALL_DIR>
      -P "${CMAKE_CURRENT_LIST_DIR}/scripts/flexbison.install.cmake"
  INSTALL_DEPENDS
    "${CMAKE_CURRENT_LIST_DIR}/scripts/flexbison.install.cmake"
  BUILD_IN_SOURCE 1)
