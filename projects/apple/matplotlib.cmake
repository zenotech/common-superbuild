include("${CMAKE_CURRENT_LIST_DIR}/../matplotlib.cmake")

if (cxx11_enabled AND NOT (ENABLE_python3 OR python3_enabled))
  superbuild_apply_patch(matplotlib setupext
    "Use libc++ on OS X")
endif ()
