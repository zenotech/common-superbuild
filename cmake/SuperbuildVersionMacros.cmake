#=========================================================================
#
#  Program:   ParaView
#
#  Copyright (c) Kitware, Inc.
#  All rights reserved.
#  See Copyright.txt or http://www.paraview.org/HTML/Copyright.html for details.
#
#     This software is distributed WITHOUT ANY WARRANTY; without even
#     the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
#     PURPOSE.  See the above copyright notice for more information.
#
#=========================================================================

find_package(Git)

#-------------------------------------------------------------------------
# Used to determine the version for a git repository using "git describe", if
# git is found. On success sets following variables in caller's scope:
#
#   ${var_prefix}_VERSION
#   ${var_prefix}_VERSION_MAJOR
#   ${var_prefix}_VERSION_MINOR
#   ${var_prefix}_VERSION_PATCH
#   ${var_prefix}_VERSION_PATCH_EXTRA
#   ${var_prefix}_VERSION_FULL
#   ${var_prefix}_VERSION_IS_RELEASE is PATCH_EXTRA is empty.
#
# If git is not found, or git describe cannot be run successfully, then these
# variables are left unchanged and status message is printed.
#
# Arguments are:
#   var:        prefix for variables e.g. "PARAVIEW".
#   source_dir: Source directory.
#   default:    Default value for the version.
function (superbuild_detect_version_git var source_dir default)
  set(major)
  set(minor)
  set(patch)
  set(full)
  set(patch_extra)
  set(result -1)

  if (GIT_FOUND AND source_dir)
    execute_process(
      COMMAND         "${GIT_EXECUTABLE}"
                      rev-parse
                      --is-inside-work-tree
      RESULT_VARIABLE result
      OUTPUT_VARIABLE output
      WORKING_DIRECTORY "${source_dir}"
      ERROR_QUIET
      OUTPUT_STRIP_TRAILING_WHITESPACE)

    if (NOT result)
      execute_process(
        COMMAND         "${GIT_EXECUTABLE}"
                        describe
        RESULT_VARIABLE result
        OUTPUT_VARIABLE output
        WORKING_DIRECTORY "${source_dir}"
        ERROR_QUIET
        OUTPUT_STRIP_TRAILING_WHITESPACE)
    endif ()
  endif ()

  if (result)
    set(output "${default}")
  endif ()

  if (output MATCHES "([0-9]+)\\.([0-9]+)\\.([0-9]+)-?(.*)")
    message(STATUS "Determined source version for ${project}: ${CMAKE_MATCH_0}")
    set(full "${CMAKE_MATCH_0}")
    set(major "${CMAKE_MATCH_1}")
    set(minor "${CMAKE_MATCH_2}")
    set(patch "${CMAKE_MATCH_3}")
    set(patch_extra "${CMAKE_MATCH_4}")
  else ()
    message(FATAL_ERROR
      "Failed to determine the version for ${var}; got ${output}")
  endif ()

  if (full)
    set("${var}_VERSION" "${major}.${minor}" PARENT_SCOPE)
    set("${var}_VERSION_MAJOR" "${major}" PARENT_SCOPE)
    set("${var}_VERSION_MINOR" "${minor}" PARENT_SCOPE)
    set("${var}_VERSION_PATCH" "${patch}" PARENT_SCOPE)
    set("${var}_VERSION_PATCH_EXTRA" "${patch_extra}" PARENT_SCOPE)
    set("${var}_VERSION_FULL" "${full}" PARENT_SCOPE)
    if (patch_extra)
      set("${var}_VERSION_IS_RELEASE" FALSE PARENT_SCOPE)
    else ()
      set("${var}_VERSION_IS_RELEASE" TRUE PARENT_SCOPE)
    endif ()
  endif ()
endfunction ()

macro (_superbuild_set_up variable value)
  set("${variable}" "${value}"
    PARENT_SCOPE)
  set("${variable}" "${value}")
endmacro ()

function (superbuild_set_version_variables project default include_file)
  set(source_dir "")
  if ((NOT ${project}_FROM_GIT AND ${project}_FROM_SOURCE_DIR) OR ${project}_SOURCE_SELECTION STREQUAL "source")
    set(source_dir "${${project}_SOURCE_DIR}")
  endif ()
  superbuild_detect_version_git("${project}" "${source_dir}" "${default}")

  _superbuild_set_up("${project}_version" "${${project}_VERSION}")
  _superbuild_set_up("${project}_version_major" "${${project}_VERSION_MAJOR}")
  _superbuild_set_up("${project}_version_minor" "${${project}_VERSION_MINOR}")
  _superbuild_set_up("${project}_version_patch" "${${project}_VERSION_PATCH}")
  _superbuild_set_up("${project}_version_patch_extra" "${${project}_VERSION_PATCH_EXTRA}")
  if (${project}_version_patch_extra)
    _superbuild_set_up("${project}_version_suffix" "-${${project}_version_patch_extra}")
  else ()
    _superbuild_set_up("${project}_version_suffix" "")
  endif ()
  _superbuild_set_up("${project}_version_full" "${${project}_VERSION_FULL}")
  _superbuild_set_up("${project}_version_is_release" "${${project}_VERSION_IS_RELEASE}")

  if (include_file)
    file(WRITE "${_superbuild_module_gen_dir}/${include_file}" "")
    foreach (variable IN ITEMS "" _major _minor _patch _patch_extra _suffix _full _is_release)
      file(APPEND "${_superbuild_module_gen_dir}/${include_file}"
        "set(\"${project}_version${variable}\" \"${${project}_version${variable}}\")\n")
    endforeach ()
  endif ()
endfunction ()
