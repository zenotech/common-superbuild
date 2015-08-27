find_package(Boost REQUIRED
  COMPONENTS
    ${boost_libraries})

superbuild_add_extra_cmake_args(
  -DBoost_NO_SYSTEM_PATHS:BOOL=ON
  -DBOOST_INCLUDEDIR:PATH=${Boost_INCLUDE_DIR})
