set(pythoncontourpy_env)
if (WIN32)
  list(APPEND pythoncontourpy_env
    PATH <INSTALL_DIR>/Python/Scripts)
endif ()

superbuild_add_project_python_pyproject(pythoncontourpy
  PACKAGE
    contourpy
  DEPENDS
    pythonmesonpython
    meson
    pybind11
    numpy
  LICENSE_FILES
    LICENSE
  SPDX_LICENSE_IDENTIFIER
    BSD-3-Clause
  SPDX_COPYRIGHT_TEXT
    "Copyright (c) 2021-2023, ContourPy Developers"
  PROCESS_ENVIRONMENT
    ${pythoncontourpy_env})
