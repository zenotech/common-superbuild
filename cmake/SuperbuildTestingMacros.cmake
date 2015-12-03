set(_superbuild_cmake_dir "${CMAKE_CURRENT_LIST_DIR}")

function (superbuild_add_extract_test generator output)
  set(_ZIP_test_glob "*.zip")
  set(_NSIS_test_glob "*.exe")
  set(_DragNDrop_test_glob "*.dmg")
  set(_TGZ_test_glob "*.tar.gz")

  add_test(
    NAME    "extract-${generator}"
    COMMAND "${CMAKE_COMMAND}"
            -Dtest_dir:PATH=${CMAKE_BINARY_DIR}
            -Dbinary_glob:STRING=${_${generator}_test_glob}
            -Doutput_dir:PATH=${output}
            -P "${_superbuild_cmake_dir}/superbuild_testing_extract_binary.cmake")
  set_tests_properties("extract-${generator}"
    PROPERTIES
      DEPENDS "cpack-${generator}"
      ${ARGN})
endfunction ()
