set(pythonsetuptools_depends)
if (WIN32)
  list(APPEND pythonsetuptools_depends
    pywin32)
endif ()

superbuild_add_project_python_pyproject(pythonsetuptools
  PACKAGE
    setuptools
  DEPENDS
    ${pythonsetuptools_depends}
  LICENSE_FILES
    LICENSE
  SPDX_LICENSE_IDENTIFIER
    MIT
  SPDX_COPYRIGHT_TEXT
    # No explicit copyright statement in the project
    # https://github.com/pypa/setuptools/issues/4135
    "Copyright (c) The setuptools contributors"
  )
