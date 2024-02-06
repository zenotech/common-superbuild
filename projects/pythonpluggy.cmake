superbuild_python_version_check(pythonpluggy
  "3.5" "0" # Unsupported
  "3.6" "1.0.0"
  "3.7" "1.2.0")

superbuild_add_project_python_pyproject(pythonpluggy
  PACKAGE
    pluggy
  DEPENDS
    pythonsetuptools
    pythonsetuptoolsscm
  LICENSE_FILES
    LICENSE
  SPDX_LICENSE_IDENTIFIER
    MIT
  SPDX_COPYRIGHT_TEXT
    "Copyright (c) 2015 holger krekel"
  )
