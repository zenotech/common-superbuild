superbuild_python_version_check(pythonwheel
  "3.5" "0" # Unsupported
  "3.6" "0.37.1"
  "3.7" "0.41.2")

set(pythonwheel_license_info
  LICENSE_FILES
    LICENSE.txt
  SPDX_LICENSE_IDENTIFIER
    MIT
  SPDX_COPYRIGHT_TEXT
    "Copyright (c) 2012 Daniel Holth and contributors")

if (pythonwheel_SOURCE_SELECTION STREQUAL "0.37.1")
  superbuild_add_project_python(pythonwheel
    PACKAGE
      wheel
    DEPENDS
      pythonsetuptools
    ${pythonwheel_license_info})
else ()
  superbuild_add_project_python_pyproject(pythonwheel
    PACKAGE
      wheel
    DEPENDS
      pythonflitcore
    ${pythonwheel_license_info}
    PYPROJECT_TOML_NO_WHEEL
    )
endif ()
