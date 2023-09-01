# This project is a grabbag of random things. We only need libuuid for
# fontconfig (as of now), so disable everything else.
superbuild_add_project(utillinux
  LICENSE_FILES
    libuuid/COPYING # This is the license of the code that is installed
    Documentation/licenses/COPYING.BSD-3-Clause
  CONFIGURE_COMMAND
    <SOURCE_DIR>/configure
      --prefix=<INSTALL_DIR>
      --disable-all-programs
      --disable-bash-completion
      --enable-libuuid
      --without-btrfs
      --without-cap-ng
      --without-ncurses
      --without-ncursesw
      --without-python
      --without-readline
      --without-selinux
      --without-slang
      --without-smack
      --without-systemd
      --without-tinfo
      --without-udev
      --without-user
      --without-utempter
  BUILD_COMMAND
    $(MAKE)
  INSTALL_COMMAND
    make install
  BUILD_IN_SOURCE 1)

superbuild_apply_patch(utillinux uuid-incdir
  "Fix uuid include dir for fontconfig")

superbuild_apply_patch(utillinux remove-terminal-colors
  "Remove terminal colors from installation as it is a GPL licensed file which we do net need at all")
