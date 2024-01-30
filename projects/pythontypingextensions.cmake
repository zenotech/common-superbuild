superbuild_python_version_check(pythontypingextensions
  "3.5" "0" # Unsupported
  "3.6" "4.1.1"
  "3.7" "4.7.1")

set(pythontypingextensions_depends)
if (pythontypingextensions_SOURCE_SELECTION STREQUAL "4.1.1")
  list(APPEND pythontypingextensions_depends
    pythonflitcore)
endif ()

superbuild_add_project_python_pyproject(pythontypingextensions
  PACKAGE
    typing_extensions
  DEPENDS
    ${pythontypingextensions_depends}
  LICENSE_FILES
    LICENSE
  SPDX_LICENSE_IDENTIFIER
    PSF-2.0
  SPDX_COPYRIGHT_TEXT
    "Copyright Guido van Rossum, Jukka Lehtosalo, Łukasz Langa, Michael Lee"
  )
