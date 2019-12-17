# This project is a grabbag of random things. We only need libuuid for
# fontconfig (as of now), so disable everything else.
superbuild_add_project(utillinux
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
