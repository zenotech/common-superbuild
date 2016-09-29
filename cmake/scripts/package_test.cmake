execute_process(
  COMMAND "${CMAKE_COMMAND}"
          -G "${cmake_generator}"
          "${source_directory}"
  RESULT_VARIABLE   res
  WORKING_DIRECTORY "${build_directory}")

if (res)
  message(FATAL_ERROR "CMake failed with exit code ${res}")
endif ()

execute_process(
  COMMAND "${CMAKE_CPACK_COMMAND}"
          -V
          -G "${cpack_generator}"
          -B "${output_directory}"
  RESULT_VARIABLE   res
  WORKING_DIRECTORY "${build_directory}")

if (res)
  message(FATAL_ERROR "CPack failed with exit code ${res}")
endif ()
