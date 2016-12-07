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
      set(option_name "${name}_${key}")
      set(cache_type STRING)
      if (name STREQUAL "SOURCE_DIR")
        set(cache_type PATH)
      endif ()
      superbuild_deprecated_setting(option_default "${option_name}" "${name_UPPER}_${key}" "${_args_${key}}")
      set("${option_name}" "${option_default}"
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
      SOURCE_DIR "${CMAKE_SOURCE_DIR}/source-${name}")
  else ()
    set(args
      URL     "${tarball_url}"
      URL_MD5 "${tarball_md5}")
  endif ()

  superbuild_set_customizable_revision("${name}"
    ${args})

  # Push the cmake_dependent_option to the parent scope.
  set("${name}_FROM_SOURCE_DIR"
    "${${name}_FROM_SOURCE_DIR}"
    PARENT_SCOPE)
endfunction ()

# A way to provide selections for a project's source.
#
# Usage:
#
#   superbuild_set_selectable_source(<name>
#     [SELECTS_WITH <parent_name>]
#     <SELECT <selection_name> [DEFAULT] [CUSTOMIZABLE] [FALLBACK]
#       <args...>>...)
#
# This may be used to provide multiple ways to build a project:
#
#   superbuild_set_selectable_source(myproject
#     SELECT v1.0
#       URL     "https://hostname/path/to/myproject-1.0.tar.gz"
#       URL_MD5 00000000000000000000000000000000
#     SELECT v2.0 DEFAULT
#       URL     "https://hostname/path/to/myproject-2.0.tar.gz"
#       URL_MD5 00000000000000000000000000000000
#     SELECT git CUSTOMIZABLE
#       GIT_REPOSITORY  "https://path/to/myproject.git"
#       GIT_TAG         "origin/master"
#     SELECT source CUSTOMIZABLE
#       SOURCE_DIR  "path/to/local/directory")
#
#   superbuild_set_selectable_source(myprojectdocs
#     SELECTS_WITH myproject
#     SELECT v1.0
#       URL     "https://hostname/path/to/myprojectdocs-1.0.tar.gz"
#       URL_MD5 00000000000000000000000000000000
#     SELECT v2.0
#       URL     "https://hostname/path/to/myprojectdocs-2.0.tar.gz"
#       URL_MD5 00000000000000000000000000000000
#     SELECT git FALLBACK
#       GIT_REPOSITORY  "https://path/to/myprojectdocs.git"
#       GIT_TAG         "origin/master")
#
# This will create a variable in the cache named ``${name}_SOURCE_SELECTION``
# which may be used to select one of the sources.
#
# If ``SELECTS_WITH`` is given, the selection of the ``<parent_name>`` will be
# used as the selection for this project as well. The ``DEFAULT`` keyword may
# not be used in projects which use ``SELECTS_WITH``. Instead, the ``FALLBACK``
# keyword may be used to indicate that that selection should be used if there
# is not a matching selection in this project.
function (superbuild_set_selectable_source name)
  set(selections)
  set(customizable_selections)

  set(selection_name)
  set(selection_args)
  set(default_selection)
  set(fallback_selection)
  set(first_selection)
  set(selects_with)

  set(grab)

  foreach (arg IN LISTS ARGN)
    if (arg STREQUAL "SELECTS_WITH")
      if (selects_with)
        message(FATAL_ERROR
          "The ${name} package may only select with a single other project.")
      endif ()

      if (selections)
        message(FATAL_ERROR
          "The `SELECTS_WITH` specifier must occur first.")
      endif ()

      set(grab selects_with)
    elseif (arg STREQUAL "SELECT")
      if (selection_name)
        # Store the first selection.
        if (NOT first_selection)
          set(first_selection "${selection_name}")
        endif ()

        # Make sure there are arguments.
        if (NOT selection_args)
          message(FATAL_ERROR
            "The ${selection_name} is missing arguments")
        endif ()

        list(APPEND selections
          "${selection_name}")
        set("selection_${selection_name}_args"
          "${selection_args}")
      endif ()

      # Clear the selection data.
      set(selection_name)
      set(selection_args)

      set(grab selection_name)
    elseif (arg STREQUAL "DEFAULT")
      # Error out on duplicate defaults.
      if (default_selection)
        message(FATAL_ERROR
          "The ${name} package may only have one default source selection.")
      endif ()

      # Error out if DEFAULT is not after a name.
      if (NOT selection_name)
        message(FATAL_ERROR
          "A `DEFAULT` specifier must come after a selection name.")
      endif ()

      # Error out if DEFAULT is not before the args.
      if (selection_args)
        message(FATAL_ERROR
          "A `DEFAULT` specifier must come before the selection args.")
      endif ()

      # Error out if we're using a separate selection.
      if (selects_with)
        message(FATAL_ERROR
          "A `DEFAULT` selection is not allowed with `SELECTS_WITH`.")
      endif ()

      set(default_selection "${selection_name}")
    elseif (arg STREQUAL "FALLBACK")
      # Error out on duplicate fallbacks.
      if (fallback_selection)
        message(FATAL_ERROR
          "The ${name} package may only have one fallback source selection.")
      endif ()

      # Error out if FALLBACK is not after a name.
      if (NOT selection_name)
        message(FATAL_ERROR
          "A `FALLBACK` specifier must come after a selection name.")
      endif ()

      # Error out if FALLBACK is not before the args.
      if (selection_args)
        message(FATAL_ERROR
          "A `FALLBACK` specifier must come before the selection args.")
      endif ()

      # Error out if we're using a separate selection.
      if (NOT selects_with)
        message(FATAL_ERROR
          "A `FALLBACK` selection is only allowed with `SELECTS_WITH`.")
      endif ()

      set(fallback_selection "${selection_name}")
    elseif (arg STREQUAL "CUSTOMIZABLE")
      # Error out if CUSTOMIZABLE is not after a name.
      if (NOT selection_name)
        message(FATAL_ERROR
          "A `CUSTOMIZABLE` specifier must come after a selection name.")
      endif ()

      # Error out if CUSTOMIZABLE is not before the args.
      if (selection_args)
        message(FATAL_ERROR
          "A `CUSTOMIZABLE` specifier must come before the selection args.")
      endif ()

      list(APPEND customizable_selections
        "${selection_name}")
    elseif (grab)
      # Store the argument.
      list(APPEND "${grab}"
        "${arg}")

      # If we just got the name, store future arguments in the arguments.
      if (grab STREQUAL "selection_name")
        set(grab selection_args)
      # If we just got the "selects with" project, drop future arguments.
      elseif (grab STREQUAL "selects_with")
        set(grab)
      endif ()
    endif ()
  endforeach ()

  if (selection_name)
    # Store the first selection.
    if (NOT first_selection)
      set(first_selection "${selection_name}")
    endif ()

    # Make sure there are arguments.
    if (NOT selection_args)
      message(FATAL_ERROR
        "The ${selection_name} is missing arguments")
    endif ()

    list(APPEND selections
      "${selection_name}")
    set("selection_${selection_name}_args"
      "${selection_args}")

    set(selection_name)
    set(selection_args)
  endif ()

  # Check that there's at least one selection.
  if (NOT selections)
    message(FATAL_ERROR
      "The ${name} project did not provide any selections")
  endif ()

  # Use the first as the default if one was not specified.
  if (NOT selects_with AND NOT default_selection)
    message(WARNING
      "Using the ${first_selection} selection as the default for ${name} "
      "because no default was specified.")
    set(default_selection "${first_selection}")
  endif ()

  if (selects_with)
    set(selection "${${selects_with}_SOURCE_SELECTION}")

    if (NOT selection_${selection}_args AND fallback_selection)
      set(selection "${fallback_selection}")
    endif ()

    set("${name}_SOURCE_SELECTION" "${selection}"
      CACHE INTERNAL "The source selection for ${name}; based off of ${selects_with}")
  else ()
    set("${name}_SOURCE_SELECTION" "${default_selection}"
      CACHE STRING "The source selection for ${name}")
    set_property(CACHE "${name}_SOURCE_SELECTION"
      PROPERTY
        STRINGS "${selections}")
    set(selection "${${name}_SOURCE_SELECTION}")
  endif ()

  if (NOT selection_${selection}_args)
    message(FATAL_ERROR
      "The ${selection} source selection for ${name} does not exist.")
  endif ()

  # See if the selection is customizable.
  list(FIND customizable_selections "${selection}" idx)

  if (idx EQUAL "-1")
    superbuild_set_revision("${name}"
      ${selection_${selection}_args})
  else ()
    superbuild_set_customizable_revision("${name}"
      ${selection_${selection}_args})
  endif ()
endfunction ()
