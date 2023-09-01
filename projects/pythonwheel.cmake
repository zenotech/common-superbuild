superbuild_add_project_python_pyproject(pythonwheel
  PACKAGE wheel
  DEPENDS pythonflitcore
  PYPROJECT_TOML_NO_WHEEL
  LICENSE_FILES LICENSE.txt)
