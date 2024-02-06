superbuild_python_version_check(pythonmako
  "3.5" "0" # Unsupported
  "3.6" "1.1.6"
  "3.7" "1.2.4")

# TODO: mako is a build dep and can't be deferred to requirements.txt
superbuild_add_project_python_pyproject(pythonmako
  PACKAGE
    mako
  DEPENDS
    pythonsetuptools
    pythonmarkupsafe
  LICENSE_FILES
    LICENSE
  SPDX_LICENSE_IDENTIFIER
    MIT
  SPDX_COPYRIGHT_TEXT
    "Copyright 2006-2022 the Mako authors and contributors"
  )
