superbuild_add_project_python(pythonpkgconfig
  DEPENDS pythonsetuptools)

superbuild_apply_patch(pythonpkgconfig no-nose
  "Remove nose as a dependency")
