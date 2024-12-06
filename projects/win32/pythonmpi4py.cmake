superbuild_add_project_python_wheel(pythonmpi4py
  DEPENDS
    mpi
  LICENSE_FILES_WHEEL
    mpi4py-${mpi4py_ver}.dist-info/LICENSE.rst
  SPDX_LICENSE_IDENTIFIER
    BSD-2-Clause
  SPDX_COPYRIGHT_TEXT
    "Copyright (c) 2021, Lisandro Dalcin"
  )

superbuild_project_add_step(pythonmpi4py-remove-impi-module
  COMMAND
    "${CMAKE_COMMAND}"
      -Dinstall_location=${superbuild_install_location}
      -P "${CMAKE_CURRENT_LIST_DIR}/scripts/pythonmpi4py.remove-impi-module.cmake"
  DEPENDEES install
  COMMENT "Removing Intel MPI implementation module"
  WORKING_DIRECTORY <SOURCE_DIR>)
