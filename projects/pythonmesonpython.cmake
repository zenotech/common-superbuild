set(pythonmesonpython_env)
if (WIN32)
  list(APPEND pythonmesonpython_env
    PATH <INSTALL_DIR>/Python/Scripts)
endif ()

superbuild_add_project_python_pyproject(pythonmesonpython
  PACKAGE mesonpy
  DEPENDS meson pythontomli pythonpyprojectmetadata pythonpackaging
  LICENSE_FILES LICENSES/MIT.txt
  PROCESS_ENVIRONMENT
    ${pythonmesonpython_env})
