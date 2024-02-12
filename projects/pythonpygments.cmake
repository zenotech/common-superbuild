superbuild_python_version_check(pythonpygments
  "3.5" "0" # Unsupported
  "3.6" "2.14.0"
  "3.7" "2.16.1")

set(pythonpygments_license_info
  LICENSE_FILES
    LICENSE
    AUTHORS
  SPDX_LICENSE_IDENTIFIER
    BSD-2-Clause
  SPDX_COPYRIGHT_TEXT
    "Copyright (c) 2006-2022 by the respective pythonpygments authors")

if (pythonpygments_SOURCE_SELECTION STREQUAL "2.14.0")
  superbuild_add_project_python(pythonpygments
    PACKAGE
      pygments
    DEPENDS
      pythonsetuptools
    ${pythonpygments_license_info})
else ()
  superbuild_add_project_python_pyproject(pythonpygments
    PACKAGE
      pygments
    DEPENDS
      pythonsetuptools
    ${pythonpygments_license_info})
endif ()
