# Inputs:
#   MATPLOTLIB_INSTALL_DIR
#   MATPLOTLIB_SOURCE_DIR
#   NUMPY_INSTALL_DIR
#   PYTHON_EXECUTABLE

# Find numpy.
file(GLOB_RECURSE numpy_eggs "${NUMPY_INSTALL_DIR}/lib*/*.egg-info")
if (NOT numpy_eggs)
  message(FATAL_ERROR "Failed to locate numpy-egg")
endif ()

set(pythonpath $ENV{PYTHONPATH})
if (WIN32)
  set(separator ";")
else ()
  set(separator ":")
endif ()

set(ENV{PKG_CONFIG_PATH} "${MATPLOTLIB_INSTALL_DIR}/lib/pkgconfig:$ENV{PKG_CONFIG_PATH}")

# Since we may find multiple eggs, loop over all of them.
foreach (egg IN LISTS numpy_eggs)
  get_filename_component(dir "${egg}" PATH)
  if (pythonpath)
    set(pythonpath "${pythonpath}${separator}${dir}")
  else ()
    set(pythonpath "${dir}")
  endif ()
endforeach ()

set(ENV{PYTHONPATH} "${pythonpath}")
message("PYTHONPATH: ${pythonpath}")

file(TO_NATIVE_PATH "${INSTALL_PREFIX}" INSTALL_PREFIX)

execute_process(
  COMMAND "${PYTHON_EXECUTABLE}"
          setup.py
          install
          "--prefix=${MATPLOTLIB_INSTALL_DIR}"
  RESULT_VARIABLE   rv
  WORKING_DIRECTORY ${MATPLOTLIB_SOURCE_DIR})
if (rv)
  message(FATAL_ERROR "Failed to build matplot lib")
endif ()
