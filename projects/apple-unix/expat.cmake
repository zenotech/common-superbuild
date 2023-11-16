if(BUILD_SHARED_LIBS)
  set(expat_args_shared --enable-shared --disable-static)
else()
  set(expat_args_shared --disable-shared --enable-static)
endif()

superbuild_add_project(expat
  CAN_USE_SYSTEM
  LICENSE_FILES
    COPYING
  SPDX_LICENSE_IDENTIFIER
    MIT
  SPDX_COPYRIGHT_TEXT
    "Copyright (c) 1998-2000 Thai Open Source Software Center Ltd and Clark Cooper"
    "Copyright (c) 2001-2022 Expat maintainers"
  CONFIGURE_COMMAND
    <SOURCE_DIR>/configure
      --prefix=<INSTALL_DIR>
      ${expat_args_shared}
      --without-docbook
  BUILD_COMMAND
    $(MAKE)
  INSTALL_COMMAND
    make install
  BUILD_IN_SOURCE 1)
