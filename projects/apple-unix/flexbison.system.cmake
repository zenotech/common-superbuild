find_program(FLEX_EXECUTABLE
  NAMES
    flex
    lex
  DOC "flex binary")
mark_as_advanced(FLEX_EXECUTABLE)

if (NOT FLEX_EXECUTABLE)
  message(FATAL_ERROR
    "Missing `flex` executable")
endif ()

find_program(BISON_EXECUTABLE
  NAMES
    bison
    yacc
  DOC "bison binary")
mark_as_advanced(BISON_EXECUTABLE)

if (NOT BISON_EXECUTABLE)
  message(FATAL_ERROR
    "Missing `bison` executable")
endif ()
