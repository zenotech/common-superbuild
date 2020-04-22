if (ENABLE_python3 OR python3_enabled)
  set(matplotlib_args)
  if (WIN32)
    set(matplotlib_args
      CONFIGURE_COMMAND
        "${CMAKE_COMMAND}"
        "-Dinstall_location=<INSTALL_DIR>"
        "-Dskip_configure=TRUE"
        -P "${CMAKE_CURRENT_LIST_DIR}/scripts/matplotlib.patch.cmake"

      PROCESS_ENVIRONMENT
        CL "/I<INSTALL_DIR>/include"
        LINK "/LIBPATH:<INSTALL_DIR>/lib")
  endif()

  set(matplotlib_depends)
  if (APPLE)
    list(APPEND matplotlib_depends
      pkgconf)
  endif ()

  if (pkgconf_enabled)
    list(APPEND matplotlib_process_environment
      PKG_CONFIG "${superbuild_pkgconf}")
  endif ()

  superbuild_add_project_python(matplotlib
    PACKAGE matplotlib
    DEPENDS numpy png freetype zlib pythondateutil pytz pythonpyparsing pythoncycler pythonsetuptools cxx11 pythonkiwisolver
            ${matplotlib_depends}
    PROCESS_ENVIRONMENT
      "${matplotlib_process_environment}"
    ${matplotlib_args})
  superbuild_apply_patch(matplotlib nostatic
    "Disable static builds")
  superbuild_apply_patch(matplotlib no-jquery
    "Disable jquery download")
else ()
  set(matplotlib_process_environment)
  if (NOT WIN32)
    list(APPEND matplotlib_process_environment
      PYTHONPATH "<INSTALL_DIR>/lib/python${superbuild_python_version}/site-packages")
  endif ()

  superbuild_add_project(matplotlib
    CAN_USE_SYSTEM
    DEPENDS python numpy png freetype zlib pythondateutil pytz pythonpyparsing pythoncycler pythonsetuptools
    DEPENDS_OPTIONAL cxx11
    BUILD_IN_SOURCE 1
    CONFIGURE_COMMAND
      "${CMAKE_COMMAND}"
        "-Dpatches_location:PATH=${CMAKE_CURRENT_LIST_DIR}/patches"
        "-Dsource_location:PATH=<SOURCE_DIR>"
        "-Dinstall_location:PATH=<INSTALL_DIR>"
        -P "${CMAKE_CURRENT_LIST_DIR}/scripts/matplotlib.patch.cmake"
    BUILD_COMMAND
      "${CMAKE_COMMAND}"
        "-DPYTHON_EXECUTABLE:PATH=${superbuild_python_executable}"
        "-Dsource_location:PATH=<SOURCE_DIR>"
        "-Dinstall_location:PATH=<INSTALL_DIR>"
        -P "${CMAKE_CURRENT_LIST_DIR}/scripts/matplotlib.build.cmake"
    INSTALL_COMMAND ""
    PROCESS_ENVIRONMENT
      "${matplotlib_process_environment}")
endif ()
