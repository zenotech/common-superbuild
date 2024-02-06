superbuild_python_version_check(pythonpathspec
  "3.5" "0" # Unsupported
  "3.6" "0.9.0"
  "3.7" "0.11.2")

superbuild_add_project_python_pyproject(pythonpathspec
  PACKAGE
    pathspec
  DEPENDS
    pythonflitcore
  LICENSE_FILES
    LICENSE
  SPDX_LICENSE_IDENTIFIER
    MPL-2.0
  SPDX_COPYRIGHT_TEXT
    "Copyright © 2013-2023 Caleb P. Burns"
  )
