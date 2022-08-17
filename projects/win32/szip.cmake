superbuild_add_project(szip
  LICENSE_FILES
    COPYING
  CMAKE_ARGS
    -DSZIP_ENABLE_ENCODING:BOOL=OFF # This option should not be changed as we do not distribute the encoding/compression license
    -DBUILD_SHARED_LIBS:BOOL=ON
    -DBUILD_TESTING:BOOL=OFF)

superbuild_apply_patch(szip remove_compression_license
  "Remove compression license from szip license file as szip is compiled without encoding support")
