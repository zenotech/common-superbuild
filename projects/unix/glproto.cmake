superbuild_add_project(glproto
  LICENSE_FILES
    COPYING
  CONFIGURE_COMMAND
    <SOURCE_DIR>/configure
    --prefix=<INSTALL_DIR>
  BUILD_COMMAND
    $(MAKE)
  INSTALL_COMMAND
    make install
  BUILD_IN_SOURCE 1)
