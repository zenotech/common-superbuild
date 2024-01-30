superbuild_python_version_check(pythonfonttools
  "3.5" "0" # Unsupported
  "3.6" "4.27.1"
  "3.7" "4.38.0"
  "3.8" "4.42.1")

superbuild_add_project_python(pythonfonttools
  PACKAGE
    fonttools
  DEPENDS
    pythonsetuptools
  LICENSE_FILES
    LICENSE
  SPDX_LICENSE_IDENTIFIER
    MIT
  SPDX_COPYRIGHT_TEXT
    "Copyright (c) 2017 Just van Rossum"
  )
