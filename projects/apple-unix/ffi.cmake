if (BUILD_SHARED_LIBS)
  set(ffi_shared_args --enable-shared --disable-static)
else ()
  set(ffi_shared_args --disable-shared --enable-static)
endif ()

superbuild_add_project(ffi
  CONFIGURE_COMMAND
    <SOURCE_DIR>/configure
      --prefix=<INSTALL_DIR>
      --disable-multi-os-directory
      --disable-docs
      ${ffi_shared_args}
  BUILD_COMMAND
    $(MAKE)
  INSTALL_COMMAND
    make install
  BUILD_IN_SOURCE 1)

superbuild_apply_patch(ffi powerpc.h-fix-build-failure-with-powerpc7
  "Check for __HAVE_FLOAT128 before using _Float128")
