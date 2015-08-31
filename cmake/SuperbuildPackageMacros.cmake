function (superbuild_add_package_test generator)
  add_test(
    NAME    "cpack-${generator}"
    COMMAND "${CMAKE_CPACK_COMMAND}"
            -V
            -G "${generator}"
    WORKING_DIRECTORY
            "${CMAKE_BINARY_DIR}")

  if (ARGN)
    set_tests_properties("cpack-${generator}"
      PROPERTIES ${ARGN})
  endif ()
endfunction ()
