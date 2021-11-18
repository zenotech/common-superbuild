set(tbb_archdir intel64)
set(tbb_libdir "lib/${tbb_archdir}/gcc4.8")
set(tbb_libsuffix "${CMAKE_SHARED_LIBRARY_SUFFIX}*")
include(tbb.common)

superbuild_apply_patch(tbb linux-cmake-relocate
  "Fix CMake configuration files for the install tree relocations")
