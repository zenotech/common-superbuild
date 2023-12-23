superbuild_add_project_python_pyproject(pythonpandas
  PACKAGE
    pandas
  DEPENDS
    numpy
    pythoncython
    pythondateutil
    pythonsetuptools
    pythontzdata
    pythonversioneer
    pythonwheel
    pytz
    zlib
  DEPENDS_OPTIONAL
    matplotlib
  LICENSE_FILES
    # They are many license files in pythonpandas, but only this one applies
    LICENSE
  SPDX_LICENSE_IDENTIFIER
    BSD-3-Clause
  SPDX_COPYRIGHT_TEXT
    "Copyright (c) 2008-2011, AQR Capital Management, LLC, Lambda Foundry, Inc. and PyData Development Team"
  REMOVE_MODULES
    pandas.tests
  )
