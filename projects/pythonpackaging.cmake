superbuild_python_version_check(pythonpackaging
  "3.5" "0" # Unsupported
  "3.6" "21.3"
  "3.7" "23.1")

set(pythonpackaging_depends)
if (pythonpackaging_SOURCE_SELECTION STREQUAL "21.3")
  list(APPEND pythonpackaging_depends
    pythonpyparsing)
endif ()

superbuild_add_project_python_pyproject(pythonpackaging
  PACKAGE
    packaging
  DEPENDS
    pythonflitcore
    ${pythonpackaging_depends}
  LICENSE_FILES
    LICENSE
    LICENSE.BSD
  SPDX_LICENSE_IDENTIFIER
    BSD-2-Clause
  SPDX_COPYRIGHT_TEXT
    "Copyright (c) Donald Stufft and individual contributors"
  )
