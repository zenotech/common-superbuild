superbuild_add_project(zlib
  CAN_USE_SYSTEM
  LICENSE_FILES
    README
  SPDX_LICENSE_IDENTIFIER
    Zlib
  SPDX_COPYRIGHT_TEXT
    "(C) 1995-2022 Jean-loup Gailly and Mark Adler"
  CMAKE_ARGS
    -DCMAKE_MACOSX_RPATH:BOOL=FALSE
    -DCMAKE_INSTALL_NAME_DIR:PATH=<INSTALL_DIR>/lib
    -DBUILD_SHARED_LIBS:BOOL=${BUILD_SHARED_LIBS}
    -DINSTALL_BIN_DIR:STRING=bin
    -DINSTALL_INC_DIR:STRING=include
    -DINSTALL_MAN_DIR:STRING=share/man
    -DINSTALL_PKGCONFIG_DIR:STRING=lib/pkgconfig
    -DINSTALL_LIB_DIR:STRING=lib)

superbuild_apply_patch(zlib pcfile-rel-prefix
  "Use pcfiledir for prefix computation")
