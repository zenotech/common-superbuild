superbuild_python_version_check(pythonfrozenlist
  "3.5" "0" # Unsupported
  "3.6" "1.2.0"
  "3.7" "1.3.3")

superbuild_add_project_python_pyproject(pythonfrozenlist
  PACKAGE
    frozenlist
  DEPENDS
    pythonsetuptools
    pythonwheel
  LICENSE_FILES
    LICENSE
  SPDX_LICENSE_IDENTIFIER
    Apache-2.0
  SPDX_COPYRIGHT_TEXT
    "Copyright 2013-2019 Nikolay Kim and Andrew Svetlov"
  )
