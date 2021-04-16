set(sqlite_extra_build_flags
  # Needed for external Qt builds.
  "-DSQLITE_ENABLE_COLUMN_METADATA=1")

string(REPLACE ";" " " sqlite_extra_build_flags "${sqlite_extra_build_flags}")
superbuild_add_project(sqlite
  CAN_USE_SYSTEM
  CONFIGURE_COMMAND
    <SOURCE_DIR>/configure
      --prefix=<INSTALL_DIR>
  BUILD_COMMAND
    $(MAKE)
      "CFLAGS=${sqlite_extra_build_flags}"
  INSTALL_COMMAND
    make install)
