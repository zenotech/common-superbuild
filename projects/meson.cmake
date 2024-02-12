superbuild_python_version_check(meson
  "3.5" "0" # Unsupported
  "3.6" "0.61.5"
  "3.7" "1.2.1")

superbuild_add_project_python(meson
  PACKAGE
    meson
  DEPENDS
    pythonsetuptools
    ninja
  LICENSE_FILES
    COPYING
  SPDX_LICENSE_IDENTIFIER
    Apache-2.0
  SPDX_COPYRIGHT_TEXT
    "Copyright 2012-2023 The Meson development team"
  )

if (UNIX)
  superbuild_project_add_step(meson-postinstall
    COMMAND   "${CMAKE_COMMAND}"
              "-Dsuperbuild_python_executable:STRING=${superbuild_python_executable}"
              "-Dinstall_dir:PATH=<INSTALL_DIR>"
              -P "${CMAKE_CURRENT_LIST_DIR}/scripts/meson.postinstall.cmake"
    DEPENDEES install
    DEPENDS    "${CMAKE_CURRENT_LIST_DIR}/scripts/meson.postinstall.cmake"
    COMMENT   "Make meson safe against long paths")
endif ()

if (WIN32)
  set(meson_command
    "<INSTALL_DIR>/Python/Scripts/meson.exe")
else ()
  set(meson_command
    "<INSTALL_DIR>/bin/meson")
endif ()
