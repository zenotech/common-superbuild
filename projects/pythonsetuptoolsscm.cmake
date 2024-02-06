superbuild_python_version_check(pythonsetuptoolsscm
  "3.5" "0" # Unsupported
  "3.6" "6.4.2"
  "3.7" "7.1.0")

superbuild_add_project_python_pyproject(pythonsetuptoolsscm
  PACKAGE
    setuptools_scm
  DEPENDS
    pythonsetuptools
    pythonpackaging
    pythontomli
    pythontypingextensions
  LICENSE_FILES
    LICENSE
  SPDX_LICENSE_IDENTIFIER
    MIT
  SPDX_COPYRIGHT_TEXT
    "Copyright 2010-2015 by Ronny Pfannschmidt"
  )
