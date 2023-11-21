set(matplotlib_process_environment)
if (WIN32)
  list(APPEND matplotlib_process_environment
    FREETYPE_INCLUDE_DIRS "<INSTALL_DIR>/include${_superbuild_list_separator}<INSTALL_DIR>/include/freetype2"
    FREETYPE_LIBRARY_DIRS "<INSTALL_DIR>/lib"
    QHULL_INCLUDE_DIRS "<INSTALL_DIR>/include"
    QHULL_LIBRARY_DIRS "<INSTALL_DIR>/lib")
endif ()

set(matplotlib_depends)
if (NOT WIN32)
  list(APPEND matplotlib_depends
    pkgconf)

  if (pkgconf_enabled)
    list(APPEND matplotlib_process_environment
      PKG_CONFIG "${superbuild_pkgconf}")
  endif ()
endif ()

superbuild_add_project_python_pyproject(matplotlib
  PACKAGE matplotlib
  DEPENDS
    qhull pybind11 cxx11 numpy png freetype zlib ${matplotlib_depends}
    pythoncontourpy pythoncycler pythonfonttools pythonkiwisolver numpy
    pythonpackaging pythonpillow pythonpyparsing pythondateutil
    pythonsetuptoolsscm
  LICENSE_FILES
    # There are many licenses in matplotlib but it looks like only this file
    # applies to the installed files
    LICENSE/LICENSE
  PROCESS_ENVIRONMENT
    ${matplotlib_process_environment})

superbuild_append_flags(cpp_flags
  "-I<INSTALL_DIR>/include"
  PROJECT_ONLY)

superbuild_apply_patch(matplotlib no-certifi
  "Disable certifi dependency")

superbuild_apply_patch(matplotlib setup.cfg
  "Configure setup.cfg")

if (WIN32)
  superbuild_apply_patch(matplotlib deps-on-windows
    "Support finding dependencies on Windows")
endif ()
