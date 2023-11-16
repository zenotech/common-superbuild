superbuild_add_project(gperf
  LICENSE_FILES
    COPYING # This a GPL license, package only if actually needed
  SPDX_LICENSE_IDENTIFIER
    GPL-3.0
  SPDX_COPYRIGHT_TEXT
    "Copyright (C) 1989-2017 Free Software Foundation, Inc."
  BUILD_IN_SOURCE 1
  CONFIGURE_COMMAND
    <SOURCE_DIR>/configure --prefix=<INSTALL_DIR>
  BUILD_COMMAND
    $(MAKE)
  INSTALL_COMMAND
    $(MAKE) install
)
