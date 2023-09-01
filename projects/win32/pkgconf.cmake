superbuild_add_project(pkgconf
  DEPENDS meson
  LICENSE_FILES
    COPYING
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
