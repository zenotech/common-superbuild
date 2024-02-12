superbuild_python_version_check(pythonchardet
  "3.5" "0" # Unsupported
  "3.6" "5.0.0"
  "3.7" "5.2.0")

superbuild_add_project_python_pyproject(pythonchardet
  PACKAGE
    chardet
  DEPENDS
    pythonsetuptools
  LICENSE_FILES
    LICENSE
  SPDX_LICENSE_IDENTIFIER
    LGPL-2.1-only
  SPDX_COPYRIGHT_TEXT
    # No explicit copyright statement in the project
    "Copyright The chardet developers"
  )
