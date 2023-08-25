superbuild_add_project_python_wheel(scipy
  DEPENDS pythonsetuptools python3 numpy
  LICENSE_FILES_WHEEL
    scipy-${scipy_version}.dist-info/LICENSE.txt
    scipy/_lib/_uarray/LICENSE
    scipy/fft/_pocketfft/LICENSE.md
  )
