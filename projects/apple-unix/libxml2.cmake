if(BUILD_SHARED_LIBS)
  set(libxml2_shared_args --enable-shared --disable-static)
else()
  set(libxml2_shared_args --disable-shared --enable-static)
endif()

superbuild_add_project(libxml2
  CAN_USE_SYSTEM
  CONFIGURE_COMMAND
    <SOURCE_DIR>/configure
      --prefix=<INSTALL_DIR>
      ${libxml2_shared_args}
  BUILD_COMMAND
    $(MAKE)
  INSTALL_COMMAND
    $(MAKE) install
  BUILD_IN_SOURCE 1)
