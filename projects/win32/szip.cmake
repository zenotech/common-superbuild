superbuild_add_project(szip
  CMAKE_ARGS
    -DBUILD_SHARED_LIBS:BOOL=ON
    -DBUILD_TESTING:BOOL=OFF)

superbuild_apply_patch(szip install-ricehdf.h
  "Fix CMake script to install ricehdf5.h")

include(szip.common)
