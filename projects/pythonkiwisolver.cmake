superbuild_python_version_check(pythonkiwisolver
  "3.5" "0" # Unsupported
  "3.6" "1.2.0"
  "3.7" "1.4.5")

set(pythonkiwisolver_license_info
  LICENSE_FILES
    LICENSE
  SPDX_LICENSE_IDENTIFIER
    BSD-3-Clause
  SPDX_COPYRIGHT_TEXT
    "Copyright (c) 2013, Nucleic Development Team")

if (pythonkiwisolver_SOURCE_SELECTION STREQUAL "1.2.0")
  superbuild_add_project_python(pythonkiwisolver
    PACKAGE
      kiwisolver
    DEPENDS
      pythonsetuptools
      pythoncppy
    ${pythonkiwisolver_license_info})
else ()
  superbuild_add_project_python_pyproject(pythonkiwisolver
    PACKAGE
      kiwisolver
    DEPENDS
      pythonsetuptools
      pythonsetuptoolsscm
      pythoncppy
    ${pythonkiwisolver_license_info})
endif ()
