option(python_FIND_LIBRARIES "Require system Python development files" ON)
mark_as_advanced(python_FIND_LIBRARIES)

find_package(PythonInterp 3 REQUIRED)

if (python_FIND_LIBRARIES)
  find_package(PythonLibs 3 REQUIRED)
  if (NOT PYTHON_VERSION_STRING VERSION_EQUAL PYTHONLIBS_VERSION_STRING AND
      NOT PYTHON_I_KNOW_WHAT_IM_DOING)
    message(FATAL_ERROR
      "Python interpreter version (${PYTHON_VERSION_STRING}) does "
      "not match the library version (${PYTHONLIBS_VERSION_STRING})")
  endif ()
endif()

# This will add PYTHON_LIBRARY, PYTHON_EXECUTABLE, PYTHON_INCLUDE_DIR
# variables. User can set/override these to change the Python being used.
superbuild_add_extra_cmake_args(
  -DPYTHON_EXECUTABLE:FILEPATH=${PYTHON_EXECUTABLE})

set(superbuild_python_version "${PYTHON_VERSION_MAJOR}.${PYTHON_VERSION_MINOR}"
  CACHE INTERNAL "")

if (python_FIND_LIBRARIES)
  superbuild_add_extra_cmake_args(
    -DPYTHON_INCLUDE_DIR:PATH=${PYTHON_INCLUDE_DIR}
    -DPYTHON_LIBRARY:FILEPATH=${PYTHON_LIBRARY})
endif()

set(superbuild_python_executable "${PYTHON_EXECUTABLE}"
  CACHE INTERNAL "")
if (WIN32)
  set(superbuild_python_pip "${PYTHON_EXECUTABLE};-m;pip"
    CACHE INTERNAL "")
else ()
  if (NOT EXISTS "${superbuild_python_pip}")
    unset(superbuild_python_pip CACHE)
  endif ()
  get_filename_component(python_executable_dir "${PYTHON_EXECUTABLE}" DIRECTORY)
  find_program(superbuild_python_pip
    NAMES pip
    HINTS "${python_executable_dir}")
endif ()
