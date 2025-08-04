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

# https://git.savannah.gnu.org/gitweb/?p=gperf.git;a=commit;h=a63b830554920476881837eeacd4a6b507632b19
superbuild_apply_patch(gperf cpp17-support
  "Support C++17")
