superbuild_python_version_check(pythoncppy
  "3.5" "0" # Unsupported
  "3.6" "1.1.0"
  "3.7" "1.2.1")

set(pythoncppy_license_info
  LICENSE_FILES
    LICENSE
  SPDX_LICENSE_IDENTIFIER
    BSD-3-Clause
  SPDX_COPYRIGHT_TEXT
    "Copyright (c) 2014, Nucleic")

if (pythoncppy_SOURCE_SELECTION STREQUAL "1.1.0")
  superbuild_add_project_python(pythoncppy
    PACKAGE
      cppy
    DEPENDS
      pythonsetuptools
    ${pythoncppy_license_info})
else ()
  superbuild_add_project_python_pyproject(pythoncppy
    PACKAGE
      cppy
    DEPENDS
      pythonsetuptools
      pythonsetuptoolsscm
    ${pythoncppy_license_info})
endif ()
