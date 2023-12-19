superbuild_add_project_python(pythoncftime
  PACKAGE
    cftime
  DEPENDS
    pythonsetuptools
    pythoncython
    pythonwheel
    numpy
  LICENSE_FILES
    LICENSE
  SPDX_LICENSE_IDENTIFIER
    "MIT"
  SPDX_COPYRIGHT_TEXT
    "Copyright 2008 Jeffrey Whitaker"
  )
