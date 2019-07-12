if (ENABLE_python3 OR python3_enabled)
  superbuild_require_python_package(pythonzope "zope")
else ()
  superbuild_add_project(pythonzope
    CONFIGURE_COMMAND
      ""
    BUILD_COMMAND
      ""
    INSTALL_COMMAND
      "${CMAKE_COMMAND}"
        "-Dinstall_dir=<INSTALL_DIR>"
        "-Dsuperbuild_python_version=${superbuild_python_version}"
        -P "${CMAKE_CURRENT_LIST_DIR}/scripts/pythonzope.install.cmake")
endif ()
