set(boost_platform_options)
if (CMAKE_CXX_COMPILER_ID MATCHES "Clang" AND NOT
    (CMAKE_CXX_COMPILER_ID STREQUAL "AppleClang" AND
      CMAKE_CXX_COMPILER_VERSION VERSION_GREATER_EQUAL 10.0.1.10010046))
  # Set the platform to be clang if using it.
  list(APPEND boost_platform_options
    toolset=clang)
endif ()

if (cxx11_enabled)
  list(APPEND boost_platform_options
    cxxflags=${CMAKE_CXX11_STANDARD_COMPILE_OPTION})
endif ()

include(boost.common)

if (APPLE)
  superbuild_apply_patch(boost osx-rpath
    "Remove @rpath from the install name of Boost's libraries")

  superbuild_project_add_step(fix-install-names
    COMMAND   "${CMAKE_COMMAND}"
              "-Dlibdir:PATH=<INSTALL_DIR>/lib"
              -P "${CMAKE_CURRENT_LIST_DIR}/scripts/boost.fix-install-names.cmake"
    DEPENDEES install
    COMMENT   ""
    WORKING_DIRECTORY <INSTALL_DIR>/lib)
endif ()
