set(pythonsetuptools_depends)
if (WIN32)
  list(APPEND pythonsetuptools_depends
    pywin32)
endif ()

superbuild_python_version_check(pythonsetuptools
  "3.5" "0" # Unsupported
  "3.6" "58.5.3"
  "3.7" "67.8.0")

set(setuptools_license
  LICENSE_FILES
    LICENSE
  SPDX_LICENSE_IDENTIFIER
    MIT
  SPDX_COPYRIGHT_TEXT
    # No explicit copyright statement in the project
    # https://github.com/pypa/setuptools/issues/4135
    "Copyright (c) The setuptools contributors")

if (pythonsetuptools_SOURCE_SELECTION STREQUAL "58.5.3")
  superbuild_add_project_python(pythonsetuptools
    PACKAGE
      setuptools
    DEPENDS
      ${pythonsetuptools_depends}
    ${setuptools_license})
else ()
  superbuild_add_project_python_pyproject(pythonsetuptools
    PACKAGE
      setuptools
    DEPENDS
      ${pythonsetuptools_depends}
    ${setuptools_license})
endif ()
