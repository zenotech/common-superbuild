option(python_FIND_LIBRARIES "Require system Python development files" ON)
mark_as_advanced(python_FIND_LIBRARIES)

find_package(PythonInterp 2.7 REQUIRED)

if (python_FIND_LIBRARIES)
  find_package(PythonLibs   2.7 REQUIRED)
  if (NOT PYTHON_VERSION_STRING STREQUAL PYTHONLIBS_VERSION_STRING AND
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

if (python_FIND_LIBRARIES)
  superbuild_add_extra_cmake_args(
    -DPYTHON_INCLUDE_DIR:PATH=${PYTHON_INCLUDE_DIR}
    -DPYTHON_LIBRARY:FILEPATH=${PYTHON_LIBRARY})
endif()

set(superbuild_python_executable "${PYTHON_EXECUTABLE}"
  CACHE INTERNAL "")
