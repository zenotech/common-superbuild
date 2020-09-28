superbuild_add_project_python(pythonpandas
  PACKAGE pandas
  DEPENDS
    numpy
    pythoncython
    pythondateutil
    pythonsetuptools
    pytz
    zlib
  DEPENDS_OPTIONAL
    matplotlib)
