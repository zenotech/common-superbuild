# Install headers
file(INSTALL
  "${source_location}/include/"
  DESTINATION "${install_location}/include"
  PATTERN "index.html" EXCLUDE)

# Install libraries
file(INSTALL
  "${source_location}/${libdir}/"
  DESTINATION "${install_location}/lib"
  FILES_MATCHING
    PATTERN "${libprefix}tbb*")

# Install CMake package
file(INSTALL
  "${source_location}/lib/cmake"
  DESTINATION "${install_location}/lib")

if (WIN32)
  # Install DLLs
  string(REPLACE "lib" "redist" bindir "${libdir}")
  file(INSTALL
    "${source_location}/${bindir}/"
    DESTINATION "${install_location}/bin"
    FILES_MATCHING
      PATTERN "*${libsuffixshared}")
endif ()

# Remove rpath junk
if (APPLE)
  file(GLOB libraries "${install_location}/lib/${libprefix}tbb*.dylib")
  foreach (library IN LISTS libraries)
    message("Fixing the library ID of ${library}")
    execute_process(
      COMMAND install_name_tool
              -id "${library}"
              "${library}"
      ERROR_VARIABLE  out
      OUTPUT_VARIABLE out
      RESULT_VARIABLE res)

    if (res)
      message(FATAL_ERROR "Failed to set the ID of ${library}:\n${out}")
    endif ()
  endforeach ()
endif ()
