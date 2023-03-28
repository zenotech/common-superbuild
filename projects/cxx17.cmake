superbuild_add_dummy_project(cxx17)

if (cxx17_enabled)
  set(CMAKE_CXX_STANDARD 17)
  set(CMAKE_CXX_STANDARD_REQUIRED TRUE)

  add_library(cxx17_check
    "${CMAKE_CURRENT_LIST_DIR}/scripts/cxx17.cxx")
endif ()

superbuild_add_extra_cmake_args(
  -DCMAKE_CXX_STANDARD:STRING=17
  -DCMAKE_CXX_STANDARD_REQUIRED:STRING=TRUE)

superbuild_append_flags(cxx_flags "${CMAKE_CXX17_STANDARD_COMPILE_OPTION}")
