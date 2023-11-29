option(python3_FIND_LIBRARIES "Require system Python development files" ON)
mark_as_advanced(python3_FIND_LIBRARIES)

set(python3_components
  Interpreter)
if (python3_FIND_LIBRARIES)
  list(APPEND python3_components
    Development)
endif()

find_package(Python3 3.3 REQUIRED COMPONENTS ${python3_components})

set(superbuild_python_version "${Python3_VERSION_MAJOR}.${Python3_VERSION_MINOR}"
  CACHE INTERNAL "")

# This will add PYTHON_LIBRARY, PYTHON_EXECUTABLE, PYTHON_INCLUDE_DIR
# variables. User can set/override these to change the Python being used.
superbuild_add_extra_cmake_args(
  -DPYTHON_EXECUTABLE:FILEPATH=${Python3_EXECUTABLE}
  -DPython_EXECUTABLE:FILEPATH=${Python3_EXECUTABLE}
  -DPython3_EXECUTABLE:FILEPATH=${Python3_EXECUTABLE})

# FindPython3.cmake only set plural variables
if (NOT Python3_INCLUDE_DIR AND NOT Python3_LIBRARY)
  list(JOIN Python3_INCLUDE_DIRS "${_superbuild_list_separator}" Python3_INCLUDE_DIR)
  list(JOIN Python3_LIBRARIES "${_superbuild_list_separator}" Python3_LIBRARY)
endif()

if (python3_FIND_LIBRARIES)
  superbuild_add_extra_cmake_args(
    -DPYTHON_INCLUDE_DIR:PATH=${Python3_INCLUDE_DIR}
    -DPYTHON_LIBRARY:FILEPATH=${Python3_LIBRARY}
    -DPython_INCLUDE_DIR:PATH=${Python3_INCLUDE_DIR}
    -DPython_LIBRARY:FILEPATH=${Python3_LIBRARY}
    -DPython3_INCLUDE_DIR:PATH=${Python3_INCLUDE_DIR}
    -DPython3_LIBRARY:FILEPATH=${Python3_LIBRARY})
endif()

set(superbuild_python_executable "${Python3_EXECUTABLE}"
  CACHE INTERNAL "")
if (WIN32)
  set(superbuild_python_pip "${Python3_EXECUTABLE};-m;pip"
    CACHE INTERNAL "")
else ()
  if (NOT EXISTS "${superbuild_python_pip}")
    unset(superbuild_python_pip CACHE)
  endif ()
  get_filename_component(python3_executable_dir "${Python3_EXECUTABLE}" DIRECTORY)
  find_program(superbuild_python_pip
    NAMES "pip-${superbuild_python_version}" "pip${superbuild_python_version}"
          pip-3 pip3
          pip
    HINTS "${python3_executable_dir}")
endif ()
