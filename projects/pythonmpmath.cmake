superbuild_add_project_python(pythonmpmath
  PACKAGE
    mpmath
  DEPENDS
    pythonsetuptools
    pythonsetuptoolsscm
  LICENSE_FILES
    LICENSE
  SPDX_LICENSE_IDENTIFIER
    BSD-3-Clause
  SPDX_COPYRIGHT_TEXT
    "Copyright (c) 2005-2021 Fredrik Johansson and mpmath contributors"
  REMOVE_MODULES
    mpmath.tests
  )
