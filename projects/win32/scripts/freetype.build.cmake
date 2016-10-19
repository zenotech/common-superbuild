set(ENV{JAM_TOOLSET} "VISUALC")
execute_process(
  COMMAND "${jam_executable}"
  RESULT_VARIABLE   res
  WORKING_DIRECTORY "${source_location}")

if (res)
  message(FATAL_ERROR "Failed to build freetype")
endif ()
