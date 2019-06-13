if (python_enabled AND NOT python2_enabled)
  message(FATAL_ERROR
    "Python is enabled, but Python2 has not been enabled.")
endif ()

superbuild_add_dummy_project(python
  DEPENDS_OPTIONAL python2)

set(python_version)
if (python2_enabled)
  set(python_version 2)
endif ()
