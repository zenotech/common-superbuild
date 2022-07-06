cmake_minimum_required(VERSION 3.14)
project(sqlite-check C)

message(CTEST_FULL_OUTPUT)

function (check_target target)
  if (NOT TARGET "${target}")
    message(SEND_ERROR
      "Target `${target}` not defined.")
  endif ()
endfunction ()

find_package(SQLite3 REQUIRED)
find_program(SQLite3_EXECUTABLE
  NAMES sqlite3
  DOC "sqlite3 binary")
if (NOT SQLite3_EXECUTABLE)
  message(SEND_ERROR
    "Failed to find sqlite3 binary")
endif ()

check_target(SQLite::SQLite3)

add_executable(sqlitetest sqlite.c)
target_link_libraries(sqlitetest PRIVATE SQLite::SQLite3)

include(CTest)
enable_testing()

add_test(NAME sqlitetest COMMAND sqlitetest)
string(REPLACE ";" "\;" curpath "$ENV{PATH}")
set_property(TEST sqlitetest APPEND PROPERTY ENVIRONMENT "PATH=${curpath}\;${CMAKE_PREFIX_PATH}/bin")
