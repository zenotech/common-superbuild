superbuild_add_project(numpy
  DEPENDS python pythonsetuptools
  BUILD_IN_SOURCE 1
  CONFIGURE_COMMAND ""
  BUILD_COMMAND
    ${superbuild_python_executable}
      setup.py
      build
      --fcompiler=no
  INSTALL_COMMAND
    "${CMAKE_COMMAND}"
      -Dinstall_location:PATH=<INSTALL_DIR>
      -Dpython_executable:FILEPATH=${superbuild_python_executable}
      -P "${CMAKE_CURRENT_LIST_DIR}/scripts/numpy.install.cmake")
