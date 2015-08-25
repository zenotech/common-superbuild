include(PVExternalProject)
include(CMakeParseArguments)

#------------------------------------------------------------------------------
# When passing string with ";" to add_external_project() macros, we need to
# ensure that the -+- is replaced with the LIST_SEPARATOR.
macro(sanitize_lists_in_string out_var_prefix var)
  string(REPLACE ";" "${ep_list_separator}" command "${${var}}")
  set (${out_var_prefix}${var} "${command}")
endmacro()
