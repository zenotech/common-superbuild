set(tbb_libdir "lib")
include(tbb.common)

superbuild_apply_patch(tbb macos-cmake-relocate
  "Fix CMake configuration files for the install tree relocations")
