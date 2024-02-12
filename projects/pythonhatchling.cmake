superbuild_python_version_check(pythonhatchling
  "3.6" "0" # Unsupported
  "3.7" "1.17.1")

superbuild_add_project_python_pyproject(pythonhatchling
  PACKAGE
    hatchling
  DEPENDS
    pythonpathspec
    pythonpluggy
    pythontroveclassifiers
  LICENSE_FILES
    LICENSE.txt
  SPDX_LICENSE_IDENTIFIER
    MIT
  SPDX_COPYRIGHT_TEXT
    "Copyright (c) 2021-present Ofek Lev"
  )
