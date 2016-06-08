superbuild_add_dummy_project(cxx11)

superbuild_add_extra_cmake_args(
  -DCMAKE_CXX_STANDARD:STRING=11
  -DCMAKE_CXX_STANDARD_REQUIRED:STRING=11)

superbuild_append_flags(cxx_flags "${CMAKE_CXX11_STANDARD_COMPILE_OPTION}")
