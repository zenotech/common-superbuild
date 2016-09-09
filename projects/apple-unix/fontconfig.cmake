if (BUILD_SHARED_LIBS)
  set(fontconfig_shared_args --enable-shared --disable-static)
else ()
  set(fontconfig_shared_args --disable-shared --enable-static)
endif ()

superbuild_add_project(fontconfig
  DEPENDS freetype libxml2
  BUILD_IN_SOURCE 1
  CONFIGURE_COMMAND
    <SOURCE_DIR>/configure
      --prefix=<INSTALL_DIR>
      --disable-docs
      --enable-libxml2
      ${fontconfig_shared_args}
      --with-freetype-config=<INSTALL_DIR>/bin/freetype-config

      # Use the system configuration and cachedirs.
      --sysconfdir=/etc
      --localstatedir=/var
  BUILD_COMMAND
    $(MAKE)
  INSTALL_COMMAND
    $(MAKE) install-exec
  PROCESS_ENVIRONMENT
    LIBXML2_CFLAGS -I<INSTALL_DIR>/include/libxml2
    LIBXML2_LIBS -lxml2)
