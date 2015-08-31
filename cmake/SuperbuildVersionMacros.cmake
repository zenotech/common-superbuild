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
#   source_dir: Source directory
#   default:    (optional) Default value for the version
function (superbuild_detect_version_git var source_dir)
  set(major)
  set(minor)
  set(patch)
  set(full)
  set(patch_extra)
  set(result -1)

  if (GIT_FOUND AND source_dir)
    execute_process(
      COMMAND         "${GIT_EXECUTABLE}" describe
      RESULT_VARIABLE result
      OUTPUT_VARIABLE output
      WORKING_DIRECTORY "${source_dir}"
      ERROR_QUIET
      OUTPUT_STRIP_TRAILING_WHITESPACE
      ERROR_STRIP_TRAILING_WHITESPACE)
  endif ()

  if (result AND ARGC GREATER 2)
    set(output "${ARGV2}")
  endif ()

  if (output MATCHES "([0-9]+)\\.([0-9]+)\\.([0-9]+)-?(.*)")
    message(STATUS "Determined source version for ${project}: ${CMAKE_MATCH_0}")
    set(full "${CMAKE_MATCH_0}")
    set(major "${CMAKE_MATCH_1}")
    set(minor "${CMAKE_MATCH_2}")
    set(patch "${CMAKE_MATCH_3}")
    set(patch_extra "${CMAKE_MATCH_4}")
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

function (superbuild_set_version_variables project default)
  set(source_dir "")
  if (${project}_FROM_SOURCE_DIR)
    set(source_dir "${${project}_SOURCE_DIR}")
  endif ()
  superbuild_detect_version_git("${project}" "${source_dir}" "${default}")

  set("${project}_version" "${${project}_VERSION}"
    PARENT_SCOPE)
  set("${project}_version_major" "${${project}_VERSION_MAJOR}"
    PARENT_SCOPE)
  set("${project}_version_minor" "${${project}_VERSION_MINOR}"
    PARENT_SCOPE)
  set("${project}_version_patch" "${${project}_VERSION_PATCH}"
    PARENT_SCOPE)
  set("${project}_version_patch_extra" "${${project}_VERSION_PATCH_EXTRA}"
    PARENT_SCOPE)
  set("${project}_version_full" "${${project}_VERSION_FULL}"
    PARENT_SCOPE)
  set("${project}_version_is_release" "${${project}_VERSION_IS_RELEASE}"
    PARENT_SCOPE)
endfunction ()
