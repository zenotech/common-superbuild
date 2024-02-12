superbuild_python_version_check(pythontomli
  "3.5" "0" # Unsupported
  "3.6" "1.2.3"
  "3.7" "2.0.1")

superbuild_add_project_python_pyproject(pythontomli
  PACKAGE
    tomli
  DEPENDS
    pythonflitcore
  LICENSE_FILES
    LICENSE
  SPDX_LICENSE_IDENTIFIER
    MIT
  SPDX_COPYRIGHT_TEXT
    "Copyright (c) 2021 Taneli Hukkinen"
  )
