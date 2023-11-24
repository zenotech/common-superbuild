superbuild_add_project(flexbison
  LICENSE_FILES
    # Actual license files are missing from the archive
    # https://github.com/lexxmark/winflexbison/issues/94
    README.md
  SPDX_LICENSE_IDENTIFIER
    "BSD-3-Clause AND GPL-3.0-or-later"
  SPDX_COPYRIGHT_TEXT
    # Copyright information extracted from the github repository as license files are missing
    # https://github.com/lexxmark/winflexbison/blob/master/flex/src/COPYING
    # https://github.com/lexxmark/winflexbison/blob/master/bison/src/COPYING
    "Copyright (c) 2001, 2002, 2003, 2004, 2005, 2006, 2007 The Flex Project."
    "Copyright (c) 1990, 1997 The Regents of the University of California."
    "Copyright Free Software Foundation, Inc."
  CONFIGURE_COMMAND ""
  BUILD_COMMAND ""
  INSTALL_COMMAND
    "${CMAKE_COMMAND}"
      -Dinstall_location=<INSTALL_DIR>
      -P "${CMAKE_CURRENT_LIST_DIR}/scripts/flexbison.install.cmake"
  INSTALL_DEPENDS
    "${CMAKE_CURRENT_LIST_DIR}/scripts/flexbison.install.cmake"
  BUILD_IN_SOURCE 1)
