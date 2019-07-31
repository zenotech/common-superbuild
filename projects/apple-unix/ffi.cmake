if (BUILD_SHARED_LIBS)
  set(ffi_shared_args --enable-shared --disable-static)
else ()
  set(ffi_shared_args --disable-shared --enable-static)
endif ()

superbuild_add_project(ffi
  CONFIGURE_COMMAND
    <SOURCE_DIR>/configure
      --prefix=<INSTALL_DIR>
      --disable-docs
      ${ffi_shared_args}
  BUILD_COMMAND
    $(MAKE)
  INSTALL_COMMAND
    make install
  BUILD_IN_SOURCE 1)
