# TODO: mako is a build dep and can't be deferred to requirements.txt
superbuild_add_project_python(pythonmako
  DEPENDS pythonsetuptools)
