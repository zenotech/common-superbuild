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

      # Use the system configuration and cachedirs.
      --sysconfdir=/etc
      --localstatedir=/var
  BUILD_COMMAND
    $(MAKE)
  INSTALL_COMMAND
    $(MAKE) install-exec install-pkgconfigDATA
  PROCESS_ENVIRONMENT
    PKG_CONFIG_PATH <INSTALL_DIR/lib/pkgconfig)
