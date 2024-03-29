if (BUILD_SHARED_LIBS)
  set(ffi_shared_args --enable-shared --disable-static)
else ()
  set(ffi_shared_args --disable-shared --enable-static)
endif ()

set(ffi_args)
if (APPLE AND CMAKE_HOST_SYSTEM_PROCESSOR STREQUAL "arm64")
  list(APPEND ffi_args
    # See: https://github.com/libffi/libffi/issues/571
    --build=aarch64-apple-darwin)
endif ()

superbuild_add_project(ffi
  LICENSE_FILES
    LICENSE
  SPDX_LICENSE_IDENTIFIER
    MIT
  SPDX_COPYRIGHT_TEXT
    "Copyright (c) 1996-2022  Anthony Green, Red Hat, Inc and others"
  CONFIGURE_COMMAND
    <SOURCE_DIR>/configure
      --prefix=<INSTALL_DIR>
      --disable-multi-os-directory
      --disable-docs
      ${ffi_shared_args}
      ${ffi_args}
  BUILD_COMMAND
    $(MAKE)
  INSTALL_COMMAND
    make install)

superbuild_apply_patch(ffi pcfiledir
  "Use a pkgconf-compatible prefix setting")
