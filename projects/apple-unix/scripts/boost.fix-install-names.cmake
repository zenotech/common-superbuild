file(GLOB boost_libraries "libboost_*.dylib")

foreach (boost_library IN LISTS boost_libraries)
  # Fix the ID of the library to be a full path.
  execute_process(
    COMMAND install_name_tool
            -id "${boost_library}"
            "${boost_library}"
    RESULT_VARIABLE res)

  if (res)
    message(FATAL_ERROR "Failed to update library ID of ${boost_library}")
  endif ()

  # Find the other Boost libraries linked to fix them.
  execute_process(
    COMMAND otool
            -L
            "${boost_library}"
    OUTPUT_VARIABLE out
    RESULT_VARIABLE res)

  if (res)
    message(FATAL_ERROR "Failed to update library ID of ${boost_library}")
  endif ()

  # Extract out the Boost libraries.
  string(REGEX MATCHALL "@rpath/libboost_[^.]*\\.dylib" linked_libraries "${out}")
  set(args)
  foreach (linked_library IN LISTS linked_libraries)
    string(REPLACE "@rpath/" "" linked_library_filename "${linked_library}")
    list(APPEND args
      -change "${linked_library}" "${libdir}/${linked_library_filename}")
  endforeach ()

  # If there are any libraries to change, do so.
  if (args)
    execute_process(
      COMMAND install_name_tool
              ${args}
              "${boost_library}"
      RESULT_VARIABLE res)

    if (res)
      message(FATAL_ERROR "Failed to update linked library IDs of ${boost_library}")
    endif ()
  endif ()
endforeach ()
