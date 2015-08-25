cmake_minimum_required(VERSION 2.8.9)

project(common-superbuild)

list(INSERT CMAKE_MODULE_PATH 0
  "${CMAKE_CURRENT_LIST_DIR}/cmake")
include("SuperbuildUtils")
include("SuperbuildCrossMacros")

set(platform)
if (APPLE)
  set(platforms "apple" "apple-unix")
elseif (UNIX)
  set(platforms "unix" "apple-unix")
elseif (WIN32)
  set(platforms "win32")
else ()
  message(FATAL_ERROR "unsupported platform")
endif ()

superbuild_cross_declare_variables()
superbuild_osx_determine_target()
superbuild_detect_64bit_target()

set(shared_default ON)
if (superbuild_is_cross)
  set(shared_default OFF)
endif ()
option(BUILD_SHARED_LIBS "Enable shared libraries" "${shared_default}")

#-----------------------------------------------------------------------------
# Setup some standard variables that control various locations and flags.
set(superbuild_install_location "${CMAKE_BINARY_DIR}/install")
set(superbuild_prefix_path "${superbuild_install_location}")
set(superbuild_download_location "${CMAKE_BINARY_DIR}/downloads"
  CACHE PATH "Location for downloaded source tarballs")
mark_as_advanced(superbuild_download_location)

superbuild_setup_flags()

# merge in default/user-specified CMake flags.
set(superbuild_ldflags "${CMAKE_SHARED_LINKER_FLAGS} ${superbuild_ldflags}")
set(superbuild_cpp_flags "${CMAKE_CXX_FLAGS} ${superbuild_cpp_flags}")
set(superbuild_cxx_flags "${CMAKE_CXX_FLAGS} ${superbuild_cxx_flags}")
set(superbuild_c_flags "${CMAKE_C_FLAGS} ${superbuild_c_flags}")

foreach (var ldflags cpp_flags cxx_flags c_flags)
  string(STRIP "${superbuild_${var}}" "superbuild_${var}")
endforeach ()

superbuild_prepare_build_tree()

#-----------------------------------------------------------------------------
# Setup CMAKE_MODULE_PATH so that platform specific configurations are
# processed before the generic ones.
set(project_path)
list(APPEND superbuild_project_roots
  "${CMAKE_CURRENT_LIST_DIR}/projects")
foreach (root IN LISTS superbuild_project_roots)
  foreach (platform IN LISTS platforms)
    list(APPEND project_path
      "${root}/${platform}/${lstage}"
      "${root}/${platform}")
  endforeach ()
  list(APPEND project_path
    "${root}/common"
    "${root}")
endforeach ()
list(INSERT CMAKE_MODULE_PATH 0
  ${project_path})

if (NOT CROSS_BUILD_STAGE STREQUAL "HOST" AND
    COMMAND superbuild_cross_prepare_target)
  superbuild_cross_prepare_target()
endif ()

include(SuperbuildRevisionMacros)

# Gather version information.
include("${CMAKE_CURRENT_LIST_DIR}/versions.cmake")
if (COMMAND superbuild_determine_versions)
  superbuild_determine_versions()
endif ()

include(SuperbuildMacros)

#-----------------------------------------------------------------------------
set (CM_PROJECTS_ALL)

process_dependencies()
