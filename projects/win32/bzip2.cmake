if (python_enabled)
  superbuild_add_dummy_project(bzip2
    DEPENDS python)
else ()
  include("${CMAKE_CURRENT_LIST_DIR}/../bzip2.cmake")
endif ()
