superbuild_add_project(pkgconf
  CAN_USE_SYSTEM
  LICENSE_FILES
    COPYING
  SPDX_LICENSE_IDENTIFIER
    MIT
  SPDX_COPYRIGHT_TEXT
    "Copyright (c) 2011, 2012, 2013, 2014, 2015, 2016, 2017, 2018 pkgconf authors"
  CONFIGURE_COMMAND
    <SOURCE_DIR>/configure
      --prefix=<INSTALL_DIR>
  BUILD_COMMAND
    $(MAKE)
  INSTALL_COMMAND
    make install
  BUILD_IN_SOURCE 1)

set(superbuild_pkgconf "<INSTALL_DIR>/bin/pkgconf")

superbuild_project_add_step(pkg-config-symlink
  COMMAND   "${CMAKE_COMMAND}"
            -E create_symlink
            pkgconf
            <INSTALL_DIR>/bin/pkg-config
  DEPENDEES install
  COMMENT   "Create `pkg-config` symlink"
  WORKING_DIRECTORY <SOURCE_DIR>)
