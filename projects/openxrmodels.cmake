superbuild_add_project(openxrmodels
  LICENSE_FILES
    htc_vive/license.txt
    valve_index/left/license.txt
    valve_index/right/license.txt
  SPDX_LICENSE_IDENTIFIER
    CC0-1.0
  SPDX_COPYRIGHT_TEXT
    NONE
  CONFIGURE_COMMAND
    ""
  BUILD_COMMAND
    ""
  INSTALL_COMMAND
    "${CMAKE_COMMAND}" -E copy_directory
      <SOURCE_DIR>
      <INSTALL_DIR>/share/paraview-${paraview_version}/openxrmodels)
