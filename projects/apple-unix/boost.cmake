if (CMAKE_CXX_COMPILER_ID STREQUAL "Clang")
  # Set the platform to be clang if using it.
  list(APPEND boost_extra_options
    --with-toolset=clang)
endif ()

include(boost.common)
