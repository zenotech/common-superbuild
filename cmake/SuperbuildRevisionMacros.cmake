include(CMakeParseArguments)

#------------------------------------------------------------------------------
# Macro to be used to register versions for any module. This makes it easier to
# consolidate versions for all modules in a single file, if needed.
function (superbuild_set_revision name)
  set_property(GLOBAL
    PROPERTY
      "${name}_revision" "${ARGN}")
endfunction ()

#------------------------------------------------------------------------------
# Use this macro instead of the superbuild_set_revision() macro when adding a
# source repo to expose advanced options to the user to change the default
# selections. Currently advanced options are added for GIT_REPOSITORY,
# GIT_TAG, URL, URL_HASH, URL_MD5, and SOURCE_DIR.
#------------------------------------------------------------------------------
function (superbuild_add_customizable_revision name)
  set(keys
    GIT_REPOSITORY GIT_TAG
    URL URL_HASH URL_MD5
    SOURCE_DIR)
  cmake_parse_arguments(_args "" "${keys}" "" ${ARGN})
  set(customized_args)
  string(TOUPPER "${name}" name_UPPER)

  foreach (key IN LISTS keys)
    if (_args_${key})
      set(option_name "${name_UPPER}_${key}")
      set(option_default "${_args_${key}}")
      set(${option_name} "${option_default}"
        CACHE STRING "${key} for project '${name}'")
      mark_as_advanced(${option_name})
      list(APPEND customized_args
        "${key}" "${${option_name}}")
    endif ()
  endforeach ()

  superbuild_add_revision("${name}"
    ${customized_args}
    ${_args_UNPARSED_ARGUMENTS})
endfunction ()

function (superbuild_add_external_source name git_repo git_tag tarball_url tarball_md5)
  option("${name}_FROM_GIT" "If enabled, fetch sources from GIT" ON)
  cmake_dependent_option("${name}_FROM_SOURCE_DIR" "Use an existing source directory" OFF
    "NOT ${name}_FROM_GIT" OFF)

  set(args)
  if (${name}_FROM_GIT)
    set(args
      GIT_REPOSITORY "${git_repo}"
      GIT_TAG        "${git_tag}")
  elseif (${name}_FROM_SOURCE_DIR)
    set(args
      SOURCE_DIR "source-${name}")
  else ()
    set(args
      URL     "${tarball_url}"
      URL_MD5 "${tarball_md5}")
  endif ()

  superbuild_add_customizable_revision("${name}"
    ${args})
endfunction ()
