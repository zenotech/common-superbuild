superbuild_python_version_check(pythonpyprojectmetadata
  "3.6" "0" # Unsupported
  "3.7" "0.7.1")

superbuild_add_project_python_pyproject(pythonpyprojectmetadata
  PACKAGE
    pyproject_metadata
  DEPENDS
    pythonsetuptools
  LICENSE_FILES
    LICENSE
  SPDX_LICENSE_IDENTIFIER
    MIT
  SPDX_COPYRIGHT_TEXT
    "Copyright © 2019 Filipe Laíns"
  )
