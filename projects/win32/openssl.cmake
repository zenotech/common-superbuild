include(openssl.common)

superbuild_add_project(openssl
  BUILD_IN_SOURCE 1
  LICENSE_FILES
    LICENSE
  SPDX_LICENSE_IDENTIFIER
    OpenSSL
  SPDX_COPYRIGHT_TEXT
    "Copyright (c) 1998-2019 The OpenSSL Project"
  CONFIGURE_COMMAND ""
  BUILD_COMMAND ""
  INSTALL_COMMAND
    "${CMAKE_COMMAND}"
      "-Dinstall_location:PATH=<INSTALL_DIR>"
      -P "${CMAKE_CURRENT_LIST_DIR}/scripts/openssl.install.cmake"
  INSTALL_DEPENDS
    "${CMAKE_CURRENT_LIST_DIR}/scripts/openssl.install.cmake")
