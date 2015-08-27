cmake_minimum_required(VERSION 3.0)

project(common-superbuild)

if (CMAKE_SOURCE_DIR STREQUAL common-superbuild_SOURCE_DIR)
  message(FATAL_ERROR
    "This project is not meant to be run directly, but instead used via "
    "add_subdirectory.")
elseif (NOT COMMAND superbuild_find_projects)
  message(FATAL_ERROR
    "The superbuild_find_projects function is not implemented; no projects "
    "can be enabled.")
endif ()

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
if (NOT superbuild_install_location)
  set(superbuild_install_location "${CMAKE_BINARY_DIR}/install")
endif ()
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
list(APPEND superbuild_version_files
  "${CMAKE_CURRENT_LIST_DIR}/versions.cmake")
foreach (version_file IN LISTS superbuild_version_files)
  include("${version_file}")
endforeach ()

include(SuperbuildMacros)

superbuild_find_projects(superbuild_projects)
if (NOT superbuild_projects)
  message(FATAL_ERROR "No projects are configured!")
endif ()

# Discover the projects.
foreach (project IN LISTS superbuild_projects)
  include("${project}")
endforeach ()
# Enable projects, etc.
superbuild_process_dependencies()

# Do any sanity checking necessary here.
if (COMMAND superbuild_sanity_check)
  superbuild_sanity_check()
endif ()

# Add packaging.
if (COMMAND superbuild_add_packaging)
  superbuild_add_packaging()

  get_property(superbuild_package_projects GLOBAL
    PROPERTY superbuild_package_projects)
  foreach (project IN LISTS superbuild_package_projects)
    if (${project}_enabled)
      include(${project}.bundle)
    endif ()
  endforeach ()
endif ()

# Add any tests.
if (COMMAND superbuild_add_tests)
  # Enable testing support.
  include(CTest)
  configure_file(
    "${CMAKE_CURRENT_LIST_DIR}/cmake/CTestCustom.cmake.in"
    "${CMAKE_BINARY_DIR}/CTestCustom.cmake"
    @ONLY)

  superbuild_add_tests()

  get_property(superbuild_test_projects GLOBAL
    PROPERTY superbuild_test_projects)
  foreach (project IN LISTS superbuild_test_projects)
    cmake_dependent_option("TEST_${project}" "Run ${project} test from the superbuild" ON
      "${project}_enabled;TARGET ${project};NOT DEVELOPER_MODE_${project}" OFF)
    if (TEST_${project})
      set(binary_dir "<BINARY_DIR>")
      _ep_replace_location_tags("${project}" binary_dir)
      list(APPEND superbuild_extra_ctest_dirs
        "${binary_dir}")
    endif ()
  endforeach ()

  configure_file(
    "${CMAKE_CURRENT_LIST_DIR}/cmake/superbuild_testing_trampoline.cmake.in"
    "${CMAKE_CURRENT_BINARY_DIR}/superbuild_testing_trampoline.cmake"
    @ONLY)
  set_property(
    DIRECTORY "${CMAKE_CURRENT_LIST_DIR}"
    PROPERTY
      TEST_INCLUDE_FILE "${CMAKE_CURRENT_BINARY_DIR}/superbuild_testing_trampoline.cmake")
endif ()
