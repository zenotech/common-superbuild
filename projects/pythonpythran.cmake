superbuild_python_version_check(pythonpythran
  "3.5" "0" # Unsupported
  "3.6" "0.13.1")

superbuild_add_project_python_pyproject(pythonpythran
  PACKAGE
    pythran
  DEPENDS
    pythonsetuptools
    pythongast
    pythonbeniget
    pythonply
  LICENSE_FILES
    LICENSE
  SPDX_LICENSE_IDENTIFIER
    BSD-3-Clause
  SPDX_COPYRIGHT_TEXT
    "Copyright (c) 2012, HPC Project and Serge Guelton"
  )
