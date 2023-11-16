if (BUILD_SHARED_LIBS)
  set(xz_shared_args --enable-shared --disable-static)
else ()
  set(xz_shared_args --disable-shared --enable-static)
endif ()

superbuild_add_project(xz
  LICENSE_FILES
    COPYING.LGPLv2.1
  SPDX_LICENSE_IDENTIFIER
    LGPL-2.1-or-later
  SPDX_COPYRIGHT_TEXT
    NONE # The license intentionaly states there is no copyright claimed
  CONFIGURE_COMMAND
    <SOURCE_DIR>/configure
      --prefix=<INSTALL_DIR>
      --disable-assembler # the superbuild doesn't assume one
      --disable-doc
      --disable-nls
      # Disable executables
      --disable-scripts
      --disable-xz
      --disable-xzdec
      --disable-lzmadec
      --disable-lzmainfo
      --disable-lzma-links
      ${xz_shared_args}
  BUILD_COMMAND
    $(MAKE)
  INSTALL_COMMAND
    $(MAKE) install
  BUILD_IN_SOURCE 1)

if (APPLE AND CMAKE_OSX_DEPLOYMENT_TARGET)
  superbuild_append_flags(c_flags
    "-mmacosx-version-min=${CMAKE_OSX_DEPLOYMENT_TARGET}"
    PROJECT_ONLY)
endif ()
