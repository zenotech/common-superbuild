set(CMAKE_OSX_DEPLOYMENT_TARGET "11.0" CACHE STRING "")

# Turn off projects which need patches to work with newer Xcode versions.
set(ENABLE_numpy OFF CACHE BOOL "")
set(ENABLE_scipy OFF CACHE BOOL "")

# Add the rpath for fortran libraries.
set(_superbuild_fortran_ld_flags "-Wl,-rpath,$ENV{CI_PROJECT_DIR}/.gitlab/gfortran/lib" CACHE STRING "")

include("${CMAKE_CURRENT_LIST_DIR}/configure_common.cmake")
