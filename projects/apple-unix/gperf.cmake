superbuild_add_project(gperf
  BUILD_IN_SOURCE 1
  CAN_USE_SYSTEM
  CONFIGURE_COMMAND
    <SOURCE_DIR>/configure --prefix=<INSTALL_DIR>
  BUILD_COMMAND
    $(MAKE)
  INSTALL_COMMAND
    $(MAKE) install
)
