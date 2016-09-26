set(_superbuild_testing_cmake_dir "${CMAKE_CURRENT_LIST_DIR}")

# Adds a test which extracts a CPack artifact.
function (superbuild_add_extract_test name glob_prefix generator output)
  set(_ZIP_test_glob "${glob_prefix}*.zip")
  set(_NSIS_test_glob "${glob_prefix}*.exe")
  set(_DragNDrop_test_glob "${glob_prefix}*.dmg")
  set(_TGZ_test_glob "${glob_prefix}*.tar.gz")

  add_test(
    NAME    "extract-${name}-${generator}"
    COMMAND "${CMAKE_COMMAND}"
            "-Dname:STRING=${name}"
            "-Dtest_dir:PATH=${CMAKE_BINARY_DIR}"
            "-Dbinary_glob:STRING=${_${generator}_test_glob}"
            "-Doutput_dir:PATH=${output}"
            -P "${_superbuild_testing_cmake_dir}/scripts/extract_test.cmake")
  set_tests_properties("extract-${name}-${generator}"
    PROPERTIES
      DEPENDS "cpack-${name}-${generator}"
      ${ARGN})
endfunction ()

# TODO: Add support for extracting a specific CPack's output.
