if (MSVC AND (MSVC_VERSION LESS 1900) AND pybind11_enabled)
  message(FATAL_ERROR
    "Visual Studio 2015 or later is required to use pybind11.")
endif ()

superbuild_add_project(pybind11
  DEFAULT_ON
  DEPENDS python3 cxx11 pythonsetuptools
  LICENSE_FILES
    LICENSE
  CMAKE_ARGS
    -DPYBIND11_TEST:BOOL=OFF
    -Dprefix_for_pc_file:STRING=\\\${pcfiledir}/../..)

if (WIN32)
  set(pybind11_python_args
    --root=<INSTALL_DIR>
    "--prefix=Python")
else ()
  set(pybind11_python_args
    "--prefix=<INSTALL_DIR>")
endif ()

superbuild_project_add_step(pybind11-pip-install
  COMMAND   ${superbuild_python_pip}
            install
            --no-index
            --no-deps
            --no-build-isolation
            ${pybind11_python_args}
            <SOURCE_DIR>
  DEPENDEES install
  COMMENT   "Install pybind11 for pip"
  WORKING_DIRECTORY <SOURCE_DIR>)
