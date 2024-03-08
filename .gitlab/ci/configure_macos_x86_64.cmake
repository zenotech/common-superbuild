set(CMAKE_OSX_DEPLOYMENT_TARGET "10.13" CACHE STRING "")

# Add the rpath for fortran libraries.
set(_superbuild_fortran_ld_flags "-Wl,-rpath,$ENV{CI_PROJECT_DIR}/.gitlab/gfortran/lib" CACHE STRING "")

set(qt5_ENABLE_MULTIMEDIA "OFF" CACHE STRING "") # Not installed on macOS CI
set(qt5_ENABLE_WEBENGINE "OFF" CACHE STRING "") # Not installed on macOS CI

include("${CMAKE_CURRENT_LIST_DIR}/configure_common.cmake")
