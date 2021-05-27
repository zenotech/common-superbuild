if (ENABLE_python3 OR python3_enabled)
  if (SUPERBUILD_SKIP_PYTHON_PROJECTS)
    superbuild_add_project_python(pywin32
      PACKAGE pywin32
      DEPENDS pythonsetuptools)
  else ()
    superbuild_add_project_python_wheel(pywin32)
  endif()
else ()
  superbuild_add_project(pywin32
    DEPENDS python python2
    BUILD_IN_SOURCE 1
    CONFIGURE_COMMAND ""
    BUILD_COMMAND     ""
    INSTALL_COMMAND
      "${CMAKE_COMMAND}"
        "-Dinstall_location:PATH=<INSTALL_DIR>"
        -P "${CMAKE_CURRENT_LIST_DIR}/scripts/prebuilt.python2.install.cmake")
endif ()
