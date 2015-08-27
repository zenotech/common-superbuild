superbuild_add_project(szip
  CMAKE_ARGS
    -DBUILD_SHARED_LIBS:BOOL=ON
    -DBUILD_TESTING:BOOL=OFF
  PATCH_COMMAND
    # BUG: szip does not install ricehdf.h
    # replace the file with an appropriate version.
    "${CMAKE_COMMAND}" -E copy_if_different
      "${CMAKE_CURRENT_LIST_DIR}/patches/szip.src.CMakeLists.txt"
      <SOURCE_DIR>/src/CMakeLists.txt)

include(szip.common)
