superbuild_add_project(gperf
  LICENSE_FILES
    COPYING # This a GPL license, package only if actually needed
  BUILD_IN_SOURCE 1
  CONFIGURE_COMMAND
    <SOURCE_DIR>/configure --prefix=<INSTALL_DIR>
  BUILD_COMMAND
    $(MAKE)
  INSTALL_COMMAND
    $(MAKE) install
)
