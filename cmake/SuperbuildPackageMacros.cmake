set(_superbuild_packaging_cmake_dir "${CMAKE_CURRENT_LIST_DIR}")

# Adds a test to package a "bundle" project.
#
# Usage:
#
#   superbuild_add_extra_package_test(<name> <generator>
#     [<property> <value>]...)
#
# This packages a bundle described by a ``${name}.bundle.cmake`` file in the
# project hierarchy. Variables may be put into the package's context by setting
# the ``superbuild_export_variables`` variable to a list of variables to put
# into the generated CMake project.
#
# Extra arguments are set as properties on the test. This should be used for
# things such as ``TIMEOUT`` and ``LABEL``.
#
# This creates a test named ``cpack-${name}-${generator}`` which generates the
# package requested. These tests are set up so that they cannot run in parallel
# with each other. This is because CPack uses the ``_CPack_Packages`` directory
# for itself in all tests.
function (superbuild_add_extra_package_test name generator)
  set(superbuild_extra_variables)
  foreach (variable IN LISTS superbuild_export_variables)
    set(superbuild_extra_variables
      "${superbuild_extra_variables}set(\"${variable}\" \"${${variable}}\")\n")
  endforeach ()

  set(cpack_source_dir "${CMAKE_BINARY_DIR}/cpack/${name}/${generator}")
  set(cpack_build_dir "${cpack_source_dir}/build")
  configure_file(
    "${_superbuild_packaging_cmake_dir}/superbuild_package_cmakelists.cmake.in"
    "${cpack_source_dir}/CMakeLists.txt"
    @ONLY)

  file(MAKE_DIRECTORY "${cpack_build_dir}")

  add_test(
    NAME    "cpack-${name}-${generator}"
    COMMAND "${CMAKE_COMMAND}"
            -Dname=${name}
            -Dcmake_generator=${CMAKE_GENERATOR}
            -Dcpack_generator=${generator}
            -Doutput_directory=${CMAKE_BINARY_DIR}
            -Dsource_directory=${cpack_source_dir}
            -Dbuild_directory=${cpack_build_dir}
            -P "${_superbuild_packaging_cmake_dir}/scripts/package_test.cmake"
    WORKING_DIRECTORY "${cpack_build_dir}")

  set_tests_properties("cpack-${name}-${generator}"
    PROPERTIES
      RESOURCE_LOCK cpack
      ${ARGN})
endfunction ()

# DEPRECATED
# Adds a test to package the top-level superbuild.
#
# This is deprecated because CPack will rerun the build of the top-level
# project. Since superbuilds never have a "do-nothing" build in the presense of
# Git repositories, it is not recommended to use this.
function (superbuild_add_package_test generator)
  message(AUTHOR_WARNING
    "superbuild_add_package_test: This function is deprecated; "
    "use the newer superbuild_add_extra_package_test mechanism instead.")

  add_test(
    NAME    "cpack-${generator}"
    COMMAND "${CMAKE_CPACK_COMMAND}"
            -V
            -G "${generator}"
    WORKING_DIRECTORY "${CMAKE_BINARY_DIR}")

  set_tests_properties("cpack-${generator}"
    PROPERTIES
      RESOURCE_LOCK cpack
      ${ARGN})
endfunction ()
