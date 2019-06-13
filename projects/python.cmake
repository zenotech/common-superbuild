if (python_enabled AND NOT (python2_enabled OR python3_enabled))
  message(FATAL_ERROR
    "Python is enabled, but neither Python2 nor Python3 has been enabled.")
endif ()

superbuild_add_dummy_project(python
  DEPENDS_OPTIONAL python2 python3)

set(python_version)
if (python2_enabled)
  set(python_version 2)
elseif (python3_enabled)
  set(python_version 3)
endif ()
