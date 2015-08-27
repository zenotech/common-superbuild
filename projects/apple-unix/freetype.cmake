if (BUILD_SHARED_LIBS)
  set(freetype_shared_args --enable-shared --disable-static)
else ()
  set(freetype_shared_args --disable-shared --enable-static)
endif ()

superbuild_add_project(freetype
  CAN_USE_SYSTEM
  DEPENDS zlib
  CONFIGURE_COMMAND
    <SOURCE_DIR>/configure
      --prefix=<INSTALL_DIR>
      ${shared_args}
      --with-sysroot=<INSTALL_DIR>
  BUILD_COMMAND
    $(MAKE)
  INSTALL_COMMAND
    $(MAKE) install)
