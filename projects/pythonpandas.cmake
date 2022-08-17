superbuild_add_project_python(pythonpandas
  PACKAGE pandas
  DEPENDS
    numpy
    pythoncython
    pythondateutil
    pythonsetuptools
    pythonsix
    pytz
    zlib
  DEPENDS_OPTIONAL
    matplotlib
  LICENSE_FILES
    # They are many license files in pythonpandas, but only this one applies
    LICENSE
  )
