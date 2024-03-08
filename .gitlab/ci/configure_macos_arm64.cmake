set(CMAKE_OSX_DEPLOYMENT_TARGET "11.0" CACHE STRING "")

# Add the rpath for fortran libraries.
set(_superbuild_fortran_ld_flags "-Wl,-rpath,$ENV{CI_PROJECT_DIR}/.gitlab/gfortran/lib" CACHE STRING "")

set(qt5_ENABLE_MULTIMEDIA "OFF" CACHE STRING "") # Not installed on MacOS CI
set(qt5_ENABLE_WEBENGINE "OFF" CACHE STRING "") # Not installed on MacOS CI

include("${CMAKE_CURRENT_LIST_DIR}/configure_common.cmake")
