superbuild_python_version_check(pythonaiosignal
  "3.5" "0" # Unsupported
  "3.6" "1.2.0"
  "3.7" "1.3.1")

superbuild_add_project_python_pyproject(pythonaiosignal
  PACKAGE
    aiosignal
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
