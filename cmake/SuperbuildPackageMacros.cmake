set(_superbuild_packaging_cmake_dir "${CMAKE_CURRENT_LIST_DIR}")

function (superbuild_add_extra_package_test name generator)
  set(cpack_working_dir "${CMAKE_BINARY_DIR}/cpack/${name}/${generator}")
  configure_file(
    "${_superbuild_packaging_cmake_dir}/superbuild_package_cmakelists.cmake.in"
    "${cpack_working_dir}/CMakeLists.txt"
    @ONLY)

  add_test(
    NAME    "cpack-${name}-${generator}"
    COMMAND "${CMAKE_COMMAND}"
            -Dname=${name}
            -Dcmake_generator=${CMAKE_GENERATOR}
            -Dcpack_generator=${generator}
            -Doutput_directory=${CMAKE_BINARY_DIR}
            -Dworking_directory=${cpack_working_dir}
            -P "${_superbuild_packaging_cmake_dir}/scripts/package_test.cmake"
    WORKING_DIRECTORY "${cpack_working_dir}")

  set_tests_properties("cpack-${name}-${generator}"
    PROPERTIES
      RESOURCE_LOCK cpack
      ${ARGN})
endfunction ()

function (superbuild_add_package_test generator)
  add_test(
    NAME    "cpack-${generator}"
    COMMAND "${CMAKE_CPACK_COMMAND}"
            -V
            -G "${generator}"
    WORKING_DIRECTORY "${CMAKE_BINARY_DIR}")

  set_tests_properties("cpack-${generator}"
    PROPERTIES
      RESOURCE_LOCK cpack
      ${ARGN})
endfunction ()
