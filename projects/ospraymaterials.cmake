superbuild_add_project(ospraymaterials
  LICENSE_FILES
    README.txt # CC0, could be omitted
  CONFIGURE_COMMAND
    ""
  BUILD_COMMAND
    ""
  INSTALL_COMMAND
    "${CMAKE_COMMAND}" -E copy_directory
      <SOURCE_DIR>
      <INSTALL_DIR>/materials)
