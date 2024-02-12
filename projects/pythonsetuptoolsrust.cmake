superbuild_python_version_check(pythonsetuptoolsrust
  "3.5" "0" # Unsupported
  "3.6" "1.1.2"
  "3.7" "1.7.0")

superbuild_add_project_python_pyproject(pythonsetuptoolsrust
  PACKAGE
    setuptools_rust
  DEPENDS
    pythonsetuptools
    pythonsetuptoolsscm
    pythontoml
    pythonsemanticversion
  LICENSE_FILES
    LICENSE
  SPDX_LICENSE_IDENTIFIER
    MIT
  SPDX_COPYRIGHT_TEXT
    "Copyright (c) 2017-2018 PyO3 project & contributors"
  )
