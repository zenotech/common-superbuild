# Inputs:
#   MATPLOTLIB_INSTALL_DIR
#   MATPLOTLIB_SOURCE_DIR
#   PYTHON_EXECUTABLE

set(pythonpath $ENV{PYTHONPATH})
if (WIN32)
  set(separator ";")
else ()
  set(separator ":")
endif ()

set(ENV{PKG_CONFIG_PATH} "${INSTALL_DIR}/lib/pkgconfig:$ENV{PKG_CONFIG_PATH}")

file(TO_NATIVE_PATH "${INSTALL_PREFIX}" INSTALL_PREFIX)

execute_process(
  COMMAND "${PYTHON_EXECUTABLE}"
          setup.py
          install
          "--prefix=${INSTALL_PREFIX}"
  RESULT_VARIABLE   rv
  WORKING_DIRECTORY ${SOURCE_DIR})
if (rv)
  message(FATAL_ERROR "Failed to build matplotlib")
endif ()
