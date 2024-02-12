if (SUPERBUILD_SKIP_PYTHON_PROJECTS)
  superbuild_add_project_python(pywin32
    PACKAGE
      pywin32
    DEPENDS
      pythonsetuptools
    SPDX_LICENSE_IDENTIFIER
      BSD-3-Clause
    SPDX_COPYRIGHT_TEXT
      "Copyright (c) 1994-2008, Mark Hammond"
    )
else ()
  superbuild_add_project_python_wheel(pywin32
    LICENSE_FILES_WHEEL
      win32com/License.txt
    SPDX_LICENSE_IDENTIFIER
      BSD-3-Clause
    SPDX_COPYRIGHT_TEXT
      "Copyright (c) 1994-2008, Mark Hammond"
    REMOVE_MODULE
      adodbapi.examples
      adodbapi.test
      win32.Demos
      win32.test
      win32comext.bits.test
      win32comext.taskscheduler.test
    )
endif()
