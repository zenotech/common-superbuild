if (ENABLE_python3 OR python3_enabled)
  include(projects/numpy.cmake)
else ()
  superbuild_add_project(numpy
    DEPENDS python python2
    BUILD_IN_SOURCE 1
    CONFIGURE_COMMAND ""
    BUILD_COMMAND     ""
    INSTALL_COMMAND
      "${CMAKE_COMMAND}"
        "-Dinstall_location:PATH=<INSTALL_DIR>"
        -P "${CMAKE_CURRENT_LIST_DIR}/scripts/prebuilt.python2.install.cmake")
endif ()
