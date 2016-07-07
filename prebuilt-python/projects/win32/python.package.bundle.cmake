if (NOT modules)
  message(FATAL_ERROR "No modules to install given.")
endif ()

superbuild_windows_install_python(
  "${CMAKE_INSTALL_PREFIX}"
  MODULES ${modules}
  MODULE_DIRECTORIES
          "${superbuild_install_location}/bin/Lib/site-packages")
