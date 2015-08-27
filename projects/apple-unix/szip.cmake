if (BUILD_SHARED_LIBS)
  set(szip_shared_args --enable-shared --disable-static)
else ()
  set(szip_shared_args --disable-shared --enable-static)
endif ()

superbuild_add_project(szip
  CONFIGURE_COMMAND
    <SOURCE_DIR>/configure
      ${szip_shared_args}
      --enable-encoding
      --prefix=<INSTALL_DIR>
  BUILD_COMMAND
    $(MAKE)
  INSTALL_COMMAND
    make install)

include(szip.common)
