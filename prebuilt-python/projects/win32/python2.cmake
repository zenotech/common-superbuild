if (superbuild_use_prebuilt_python)

include("${prebuilt-python_SOURCE_DIR}/../projects/win32/python.cmake")

else ()

if (superbuild_is_64bit)
  set(python_configuration "Release|x64")
  set(python_executable_dir "<SOURCE_DIR>/PC/VS9.0/amd64")
else ()
  set(python_configuration "Release|Win32")
  set(python_executable_dir "<SOURCE_DIR>/PC/VS9.0")
endif ()

find_program(DEVENV_EXE
  NAMES devenv
  DOC   "Path to the devenv executable")

if (NOT DEVENV_EXE)
  message(FATAL_ERROR
    "Could not find the devenv.exe program. This is required in order to "
    "compile the actual Python project itself.")
endif ()

superbuild_add_project(python2
  DEFAULT_ON
  DEPENDS bzip2 zlib
  BUILD_IN_SOURCE 1
  CONFIGURE_COMMAND
    ""
  BUILD_COMMAND
    "${DEVENV_EXE}"
      PC/VS9.0/pcbuild.sln
      /build "${python_configuration}"
      /project python
  # We need to copy pyconfig.h from PC/ to Include.
  INSTALL_COMMAND
    "${CMAKE_COMMAND}"
      -Dsource_location:PATH=<SOURCE_DIR>
      -Doutput_location:PATH=${python_executable_dir}
      -Dinstall_location:PATH=<INSTALL_DIR>
      -P "${CMAKE_CURRENT_LIST_DIR}/scripts/python2.install.cmake")

set(python_projects_to_build
  _ctypes
  _ctypes_test
  _elementtree
  _msi
  _multiprocessing
  _socket
  _testcapi
  kill_python
  make_buildinfo
  make_versioninfo
  pyexpat
  pythoncore
  pythonw
  select
  unicodedata
  w9xpopen
  winsound)

foreach (python_project IN LISTS python_projects_to_build)
  superbuild_project_add_step("build-${python_project}"
    COMMAND
      "${DEVENV_EXE}"
        <SOURCE_DIR>/PC/VS9.0/pcbuild.sln
        /build "${python_configuration}"
        /project "${python_project}"
    DEPENDEES build
    DEPENDERS install
    COMMENT   "Building the ${python_project} library"
    WORKING_DIRECTORY <BINARY_DIR>)
endforeach ()

set(superbuild_python_executable "${superbuild_install_location}/bin/python"
  CACHE INTERNAL "")

superbuild_add_extra_cmake_args(
  -DPYTHON_EXECUTABLE:FILEPATH=<INSTALL_DIR>/bin/python.exe
  -DPYTHON_INCLUDE_DIR:FILEPATH=<INSTALL_DIR>/include
  -DPYTHON_LIBRARY:FILEPATH=<INSTALL_DIR>/lib/python27.lib)

endif ()
