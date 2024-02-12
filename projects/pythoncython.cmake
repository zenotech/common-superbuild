superbuild_add_project_python(pythoncython
  PACKAGE
    cython
  DEPENDS
    pythonsetuptools
    pythonpythran
  LICENSE_FILES
    COPYING.txt
    LICENSE.txt
  SPDX_LICENSE_IDENTIFIER
    Apache-2.0
  SPDX_COPYRIGHT_TEXT
    "Copyright Stefan Behnel, Robert Bradshaw, Dag Sverre Seljebotn, Greg Ewing, William Stein, Gabriel Gellner, et al."
  )
