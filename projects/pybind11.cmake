if (MSVC AND (MSVC_VERSION LESS 1900) AND pybind11_enabled)
  message(FATAL_ERROR
    "Visual Studio 2015 or later is required to use pybind11.")
endif ()

superbuild_add_project(pybind11
  DEPENDS python3 cxx11 pythonsetuptools
  LICENSE_FILES
    LICENSE
  SPDX_LICENSE_IDENTIFIER
    BSD-3-Clause
  SPDX_COPYRIGHT_TEXT
    "Copyright (c) 2016 Wenzel Jakob"
  CMAKE_ARGS
    -DPYBIND11_TEST:BOOL=OFF
    -Dprefix_for_pc_file:STRING=\\\${pcfiledir}/../..)

if (WIN32)
  set(pybind11_pythonpath
    "<INSTALL_DIR>/Python/Lib/site-packages")
  set(pybind11_python_args
    --root=<INSTALL_DIR>
    "--prefix=Python")
else ()
  set(pybind11_pythonpath
    "<INSTALL_DIR>/lib/python${superbuild_python_version}/site-packages")
  set(pybind11_python_args
    "--prefix=<INSTALL_DIR>")
endif ()

superbuild_project_add_step(pybind11-pip-install
  COMMAND   "${CMAKE_COMMAND}"
            -E env
            --modify
            "PYTHONPATH=path_list_prepend:${pybind11_pythonpath}"
            --
            ${superbuild_python_pip}
            install
            --no-index
            --no-deps
            --no-build-isolation
            ${pybind11_python_args}
            <SOURCE_DIR>
  DEPENDEES install
  COMMENT   "Install pybind11 for pip"
  WORKING_DIRECTORY <SOURCE_DIR>)
