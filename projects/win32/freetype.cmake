find_program(JAM_EXECUTABLE
  NAMES jam
  DOC   "Path to the jam build tool")

if (superbuild_build_phase AND NOT JAM_EXECUTABLE)
  message(FATAL_ERROR "Freetype requires jam to build")
endif ()

superbuild_add_project(freetype
  DEPENDS zlib
  BUILD_IN_SOURCE 1
  CONFIGURE_COMMAND
    ""
  BUILD_COMMAND
    "${CMAKE_COMMAND}"
      -Djam_executable:FILEPATH=${JAM_EXECUTABLE}
      -Dsource_dir:PATH=<SOURCE_DIR>
      -P "${CMAKE_CURRENT_LIST_DIR}/scripts/freetype.build.cmake"
  INSTALL_COMMAND
    "${CMAKE_COMMAND}"
      -Dsource_dir:PATH=<SOURCE_DIR>
      -Dinstall_dir:PATH=<INSTALL_DIR>
      -P "${CMAKE_CURRENT_LIST_DIR}/scripts/freetype.install.cmake"
  PROCESS_ENVIRONMENT
    JAM_TOOLSET VISUALC)
