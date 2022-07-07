string(TOUPPER sqlite_upper_config "${CMAKE_BUILD_TYPE}")
set(sqlite_c_flags
  ${CMAKE_C_FLAGS}
  ${CMAKE_C_FLAGS_${sqlite_upper_config}}
  # Export symbols from the library.
  "-DSQLITE_API=__declspec(dllexport)"
  # Enable RTree support
  "-DSQLITE_ENABLE_RTREE=1")
set(sqlite_shared_flags
  ${CMAKE_SHARED_LINKER_FLAGS}
  ${CMAKE_SHARED_LINKER_FLAGS_${sqlite_upper_config}})
set(sqlite_exe_flags
  ${CMAKE_EXE_LINKER_FLAGS}
  ${CMAKE_EXE_LINKER_FLAGS_${sqlite_upper_config}})

if (CMAKE_C_COMPILER_ID STREQUAL "MSVC" OR
    CMAKE_C_SIMULATE_ID STREQUAL "MSVC")
  set(sqlite_lib_build_command
    ${CMAKE_C_COMPILER_LAUNCHER}
    "${CMAKE_C_COMPILER}"
      ${sqlite_c_flags}
      ${sqlite_shared_flags}
      -nologo
      sqlite3.c
      -link
      -dll
      -out:sqlite3.dll
      -implib:sqlite3.lib)
  set(sqlite_bin_build_command
    ${CMAKE_C_COMPILER_LAUNCHER}
    "${CMAKE_C_COMPILER}"
      ${sqlite_c_flags}
      ${sqlite_exe_flags}
      -nologo
      shell.c
      sqlite3.lib
      -Fesqlite3.exe)
elseif (CMAKE_C_COMPILER_ID STREQUAL "MinGW")
  set(sqlite_lib_build_command
    ${CMAKE_C_COMPILER_LAUNCHER}
    "${CMAKE_C_COMPILER}"
      ${sqlite_c_flags}
      ${sqlite_shared_flags}
      -shared
      sqlite3.c
      -o sqlite3.dll)
  set(sqlite_bin_build_command
    ${CMAKE_C_COMPILER_LAUNCHER}
    "${CMAKE_C_COMPILER}"
      ${sqlite_c_flags}
      ${sqlite_exe_flags}
      -DSQLITE_THREADSAFE=0 # the binary is never threaded
      shell.c
      sqlite3.lib
      -ldl
      -lm
      -o sqlite3.exe)
else ()
  message(FATAL_ERROR
    "sqlite on Windows requires an MSVC or MinGW compiler.")
endif ()

superbuild_add_project(sqlite
  LICENSE_FILES
    tea/license.terms # There is no license file in sqlite, only headers.
  CONFIGURE_COMMAND ""
  BUILD_COMMAND ""
  INSTALL_COMMAND
    "${CMAKE_COMMAND}"
      -Dinstall_location=<INSTALL_DIR>
      -P "${CMAKE_CURRENT_LIST_DIR}/scripts/sqlite.install.cmake"
  BUILD_IN_SOURCE 1)

superbuild_apply_patch(sqlite dllimport
  "Add `dllimport` to function declarations")

superbuild_project_add_step(sqlite-build-lib
  COMMAND ${sqlite_lib_build_command}
  DEPENDERS install
  COMMENT "Building sqlite library"
  WORKING_DIRECTORY <SOURCE_DIR>)
superbuild_project_add_step(sqlite-build-bin
  COMMAND ${sqlite_bin_build_command}
  DEPENDEES sqlite-build-lib
  DEPENDERS install
  COMMENT "Building sqlite binary"
  WORKING_DIRECTORY <SOURCE_DIR>)
