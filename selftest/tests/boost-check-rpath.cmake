message("Avoid CTest truncation: CTEST_FULL_OUTPUT")

file(GLOB boost_libraries "${install_dir}/lib/libboost_*.dylib")

foreach (boost_library IN LISTS boost_libraries)
  message("Checking ${boost_library}")

  execute_process(
    COMMAND otool -L "${boost_library}"
    OUTPUT_VARIABLE out
    ERROR_VARIABLE  err
    RESULT_VARIABLE res
    OUTPUT_STRIP_TRAILING_WHITESPACE)

  if (res)
    message(SEND_ERROR
      "Failed to run `otool -L` on ${boost_library}: ${err}")
    continue ()
  endif ()

  string(REPLACE "\n" ";" out "${out}")

  foreach (line IN LISTS out)
    if (line MATCHES "@rpath/")
      message(SEND_ERROR
        "Found an rpath entry in ${boost_library}: ${line}")
    endif ()
  endforeach ()
endforeach ()
