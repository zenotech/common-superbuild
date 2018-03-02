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

  set_property(GLOBAL APPEND
    PROPERTY
      _superbuild_packages "${name}/${generator}")

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

# Add a "superbuild-install" target to install one of the packages.
#
# This function adds a target which acts like "make install" for a selected
# package.
#
# The ``default`` argument is used as the default package to build and the
# cache editors use the list of available packages as the selection choices for
# the ``SUPERBUILD_DEFAULT_INSTALL`` variable.
function (superbuild_enable_install_target default)
  get_property(all_packages GLOBAL
    PROPERTY _superbuild_packages)

  set(SUPERBUILD_DEFAULT_INSTALL "${default}"
    CACHE STRING "The package to install by default")
  set_property(CACHE SUPERBUILD_DEFAULT_INSTALL
    PROPERTY
      STRINGS "${all_packages}")

  if (SUPERBUILD_DEFAULT_INSTALL)
    set(cpack_source_dir "${CMAKE_BINARY_DIR}/cpack/${SUPERBUILD_DEFAULT_INSTALL}")
    set(cpack_build_dir "${cpack_source_dir}/install")
    file(MAKE_DIRECTORY "${cpack_build_dir}")

    if (NOT EXISTS "${cpack_source_dir}")
      message(FATAL_ERROR
        "The ${SUPERBUILD_DEFAULT_INSTALL} package does not exist; it cannot "
        "be used as the default \"install\" target.")
    endif ()

    install(CODE
      "file(MAKE_DIRECTORY \"${cpack_build_dir}\")
  execute_process(
    COMMAND \"${CMAKE_COMMAND}\"
            \"-DCMAKE_INSTALL_PREFIX:PATH=${CMAKE_INSTALL_PREFIX}\"
            \"-Dsuperbuild_is_install_target:BOOL=ON\"
            \"${cpack_source_dir}\"
    RESULT_VARIABLE   res
    WORKING_DIRECTORY \"${cpack_build_dir}\")

  if (res)
    message(FATAL_ERROR \"Failed to configure the ${SUPERBUILD_DEFAULT_INSTALL} package.\")
  endif ()

  execute_process(
    COMMAND \"${CMAKE_COMMAND}\"
            --build \"${cpack_build_dir}\"
            --target install
    RESULT_VARIABLE res)

  if (res)
    message(FATAL_ERROR \"Failed to install the ${SUPERBUILD_DEFAULT_INSTALL} package.\")
  endif ()"
      COMPONENT install)
  endif ()
endfunction ()
