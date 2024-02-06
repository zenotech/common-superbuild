if (superbuild_build_phase AND
    NOT superbuild_python_version STREQUAL scipy_SOURCE_SELECTION)
  message(FATAL_ERROR
    "`scipy` requires a matching Python version. `scipy` "
    "${scipy_SOURCE_SELECTION} selected but Python "
    "${superbuild_python_version} is in use.")
endif ()

superbuild_add_project_python_wheel(scipy
  DEPENDS pythonsetuptools python3 numpy
  LICENSE_FILES_WHEEL
    scipy-${scipy_version}.dist-info/LICENSE.txt
    scipy/_lib/_uarray/LICENSE
    scipy/fft/_pocketfft/LICENSE.md
  SPDX_LICENSE_IDENTIFIER
    BSD-3-Clause
  SPDX_COPYRIGHT_TEXT
    "Copyright (c) 2001-2002 Enthought, Inc. 2003-2023, SciPy Developers"
  )
