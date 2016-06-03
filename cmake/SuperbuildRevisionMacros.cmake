include(CMakeParseArguments)

# Sets the arguments to ``ExternalProject_add`` to download the project.
#
# Usage:
#
#   superbuild_set_revision(<name> <args>...)
#
# If this is called multiple times for a single project, only the first one
# takes effect.
function (superbuild_set_revision name)
  get_property(have_revision GLOBAL
    PROPERTY
      "${name}_revision" SET)

  if (NOT have_revision)
    set_property(GLOBAL
      PROPERTY
        "${name}_revision" "${ARGN}")
  endif ()
endfunction ()

# Sets arguments to ``ExternalProject_add`` to download the project, but adds
# cache variables so that they may be changed by the user.
#
# Usage:
#
#   superbuild_set_customizable_revision(<name> <args>...)
#
# Adds advanced variables for the following keys:
#
#   GIT_REPOSITORY, GIT_TAG, URL, URL_HASH, URL_MD5, and SOURCE_DIR
#
# they are named ``${name_UPPER}_${key}``.
function (superbuild_set_customizable_revision name)
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
      set(cache_type STRING)
      if (name STREQUAL "SOURCE_DIR")
        set(cache_type PATH)
      endif ()
      set(${option_name} "${option_default}"
        CACHE "${cache_type}" "${key} for project '${name}'")
      mark_as_advanced(${option_name})
      list(APPEND customized_args
        "${key}" "${${option_name}}")
    endif ()
  endforeach ()

  superbuild_set_revision("${name}"
    ${customized_args}
    ${_args_UNPARSED_ARGUMENTS})
endfunction ()

# Convenient way to declare a main project's source.
#
# Usage:
#
#   superbuild_set_external_source(<name>
#     <git-url> <git-ref>
#     <tarball-url> <tarball-md5>)
#
# Adds options to build the project from a git repository, a tarball, or a
# source tree (linked from the source tree as
# ``${CMAKE_SOURCE_DIR}/source-${name}``). Usually relevant for the "primary"
# project(s) in a single superbuild.
function (superbuild_set_external_source name git_repo git_tag tarball_url tarball_md5)
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

  superbuild_set_customizable_revision("${name}"
    ${args})
endfunction ()
