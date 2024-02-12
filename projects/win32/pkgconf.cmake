superbuild_add_project(pkgconf
  DEPENDS meson
  LICENSE_FILES
    COPYING
  SPDX_LICENSE_IDENTIFIER
    MIT
  SPDX_COPYRIGHT_TEXT
    "Copyright (c) 2011, 2012, 2013, 2014, 2015, 2016, 2017, 2018 pkgconf authors"
  CONFIGURE_COMMAND
    ${meson_command}
      setup
      build
      --prefix=<INSTALL_DIR>
      -Dtests=disabled
  BUILD_COMMAND
    ${superbuild_ninja_command} -C build
  INSTALL_COMMAND
    ${superbuild_ninja_command} -C build install
  BUILD_IN_SOURCE 1)

set(superbuild_pkgconf "<INSTALL_DIR>/bin/pkgconf.exe")
