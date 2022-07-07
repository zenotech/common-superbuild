set(sqlite_extra_build_flags
  # Needed for external Qt builds.
  "-DSQLITE_ENABLE_COLUMN_METADATA=1"
  # Needed for GDAL builds
  "-DSQLITE_ENABLE_RTREE=1")

string(REPLACE ";" " " sqlite_extra_build_flags "${sqlite_extra_build_flags}")
superbuild_add_project(sqlite
  CAN_USE_SYSTEM
  LICENSE_FILES
    tea/license.terms # There is no license file in sqlite, only headers.
  CONFIGURE_COMMAND
    <SOURCE_DIR>/configure
      --prefix=<INSTALL_DIR>
  BUILD_COMMAND
    $(MAKE)
      "CFLAGS=${sqlite_extra_build_flags}"
  INSTALL_COMMAND
    make install)

if (APPLE AND CMAKE_OSX_DEPLOYMENT_TARGET)
  superbuild_append_flags(c_flags
    "-mmacosx-version-min=${CMAKE_OSX_DEPLOYMENT_TARGET}"
    PROJECT_ONLY)
  superbuild_append_flags(ld_flags
    "-mmacosx-version-min=${CMAKE_OSX_DEPLOYMENT_TARGET}"
    PROJECT_ONLY)
endif ()
