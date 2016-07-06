# CMake learned how to enable C++11 for the Intel compiler in 3.6.
if (superbuild_build_phase AND
    CMAKE_CXX_COMPILER_ID MATCHES "Intel" AND
    CMAKE_VERSION VERSION_LESS "3.6")
  message(FATAL_ERROR "Building C++11 with the Intel compiler requires CMake >= 3.6")
endif ()

superbuild_add_dummy_project(cxx11)

superbuild_add_extra_cmake_args(
  -DCMAKE_CXX_STANDARD:STRING=11
  -DCMAKE_CXX_STANDARD_REQUIRED:STRING=TRUE)

superbuild_append_flags(cxx_flags "${CMAKE_CXX11_STANDARD_COMPILE_OPTION}")
