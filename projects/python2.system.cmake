option(python2_FIND_LIBRARIES "Require system Python2 development files" ON)
mark_as_advanced(python2_FIND_LIBRARIES)

set(python2_components
  Interpreter)
if (python2_FIND_LIBRARIES)
  list(APPEND python2_components
    Development)
endif()

find_package(Python2 REQUIRED COMPONENTS ${python2_components})

set(superbuild_python_version "${Python2_VERSION_MAJOR}.${Python2_VERSION_MINOR}"
  CACHE INTERNAL "")

# This will add PYTHON_LIBRARY, PYTHON_EXECUTABLE, PYTHON_INCLUDE_DIR
# variables. User can set/override these to change the Python being used.
superbuild_add_extra_cmake_args(
  -DPYTHON_EXECUTABLE:FILEPATH=${Python2_EXECUTABLE}
  -DPython2_EXECUTABLE:FILEPATH=${Python2_EXECUTABLE})

if (python2_FIND_LIBRARIES)
  superbuild_add_extra_cmake_args(
    -DPYTHON_INCLUDE_DIR:PATH=${Python2_INCLUDE_DIR}
    -DPYTHON_LIBRARY:FILEPATH=${Python2_LIBRARY}
    -DPython2_INCLUDE_DIR:PATH=${Python2_INCLUDE_DIR}
    -DPython2_LIBRARY:FILEPATH=${Python2_LIBRARY})
endif()

set(superbuild_python_executable "${Python2_EXECUTABLE}"
  CACHE INTERNAL "")
if (WIN32)
  set(superbuild_python_pip "${Python2_EXECUTABLE};-m;pip"
    CACHE INTERNAL "")
else ()
  if (NOT EXISTS "${superbuild_python_pip}")
    unset(superbuild_python_pip CACHE)
  endif ()
  get_filename_component(python2_executable_dir "${Python2_EXECUTABLE}" DIRECTORY)
  find_program(superbuild_python_pip
    NAMES pip
    HINTS "${python2_executable_dir}")
endif ()
