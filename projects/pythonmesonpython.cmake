set(pythonmesonpython_env)
if (WIN32)
  list(APPEND pythonmesonpython_env
    PATH <INSTALL_DIR>/Python/Scripts)
endif ()

superbuild_add_project_python_pyproject(pythonmesonpython
  PACKAGE
    mesonpy
  DEPENDS
    meson
    pythontomli
    pythonpyprojectmetadata
    pythonpackaging
  LICENSE_FILES
    LICENSES/MIT.txt
  SPDX_LICENSE_IDENTIFIER
    MIT
  SPDX_COPYRIGHT_TEXT
    "Copyright © 2022 the meson-python contributors"
    "Copyright © 2021 Quansight Labs and Filipe Laíns"
  PROCESS_ENVIRONMENT
    ${pythonmesonpython_env})
