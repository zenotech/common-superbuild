#[==[.md
# Testing packages

The packages created by the superbuild packaging support may also be tested. In
order to do so, the created package must first be extracted.
#]==]

set(_superbuild_testing_cmake_dir "${CMAKE_CURRENT_LIST_DIR}")

#[==[.md
The `superbuild_add_extract_test` extracts a package generated by a packaging
test.

```
superbuild_add_extract_test(<NAME> <PREFIX> <GENERATOR> <OUTPUT>
  [<PROPERTY> <VALUE>]...)
```

The `NAME` and `GENERATOR` arguments must match the corresponding package test
that should be extracted. There is also the `PREFIX` argument which should be a
prefix long enough to make the glob for the resulting package name unique.

The `OUTPUT` is the path to the directory that the package should be extracted
into. One intermediate directory is removed from the extraction. For example, a
package containing `dirname/bin/program` and `dirname/include/header.h` will
have a `bin` and `include` directory under the given output directory.
#]==]

# TODO: use a PROPERTIES argument
function (superbuild_add_extract_test name glob_prefix generator output)
  set(_ZIP_test_glob "${glob_prefix}*.zip")
  set(_NSIS_test_glob "${glob_prefix}*.exe")
  set(_DragNDrop_test_glob "${glob_prefix}*.dmg")
  set(_TGZ_test_glob "${glob_prefix}*.tar.gz")

  if (NOT DEFINED _${generator}_test_glob)
    message(FATAL_ERROR
      "No known glob to find packages created by the ${generator} CPack "
      "generator.")
  endif ()

  add_test(
    NAME    "extract-${name}-${generator}"
    COMMAND "${CMAKE_COMMAND}"
            "-Dname:STRING=${name}"
            "-Dtest_dir:PATH=${CMAKE_BINARY_DIR}"
            "-Dbinary_glob:STRING=${_${generator}_test_glob}"
            "-Doutput_dir:PATH=${output}"
            -P "${_superbuild_testing_cmake_dir}/scripts/extract_test.cmake")
  set_tests_properties("extract-${name}-${generator}"
    PROPERTIES
      DEPENDS "cpack-${name}-${generator}"
      ${ARGN})
endfunction ()

# TODO: Add support for extracting a specific CPack's output.

#[==[.md
Create a test which loads all modules within a directory as being standalone
loadable.

```
superbuild_add_extra_package_test(<package> <generator> <directory>
  [EXCLUDES <exclude>...])
```

For a package named `<package>`, find all loadable libraries under
`<directory>` and make sure they are loadable.

If `EXCLUDES` are given, paths matching the exclusion are not tested.
#]==]

function (superbuild_test_loadable_modules package generator dir)
  cmake_parse_arguments(PARSE_ARGV 3 _test_loadable "" "" "EXCLUDES")

  if (_test_loadable_UNPARSED_ARGUMENTS)
    message(FATAL_ERROR
      "Unparsed arguments to `superbuild_test_loadable_modules`: "
      "${_test_loadable_UNPARSED_ARGUMENTS}")
  endif ()

  if (WIN32)
    return ()
  endif ()

  find_program(FILE_COMMAND
    NAMES file
    REQUIRED)

  add_test(
    NAME  "test-package-${package}-${generator}-ldd-resolutions"
    COMMAND
      "${CMAKE_COMMAND}"
        "-Ddirectory=${dir}"
        "-Dexcludes=${_test_loadable_EXCLUDES}"
        "-Dfile_command=${FILE_COMMAND}"
        -D_run_superbuild_test_loadable_modules=ON
        -P "${CMAKE_CURRENT_FUNCTION_LIST_FILE}")
  set_tests_properties("test-package-${package}-${generator}-ldd-resolutions"
    PROPERTIES
      DEPENDS "extract-${package}-${generator}")
endfunction ()

if (_run_superbuild_test_loadable_modules)
  # Keep the full output on CDash for future inspection.
  message("CTEST_FULL_OUTPUT")

  if (NOT file_command)
    message(FATAL_ERROR
      "Missing `file` command to detect filetypes.")
  endif ()

  function (_superbuild_test_file_type module type)
    execute_process(
      COMMAND "${file_command}" "${module}"
      RESULT_VARIABLE res
      OUTPUT_VARIABLE out
      ERROR_VARIABLE err
      OUTPUT_STRIP_TRAILING_WHITESPACE
      ERROR_STRIP_TRAILING_WHITESPACE)
    if (res)
      message(SEND_ERROR
        "Failed to run `file` to detect type of '${module}': ${err}")
      return ()
    endif ()

    set(filetype "")
    if (out MATCHES ": ELF")
      set(filetype "ELF")
    elseif (out MATCHES ": Mach-O")
      set(filetype "Mach-O")
    endif ()

    if (filetype)
      set("${type}" "${filetype}" PARENT_SCOPE)
    else ()
      set("${type}" "" PARENT_SCOPE)
    endif ()
  endfunction ()

  function (_superbuild_test_loadable_module module format)
    if (format STREQUAL "ELF")
      set(command "ldd")
      set(ignore_regex "^$")
      set(missing_regex " => not found$")
      set(libname_regex "^\t(.*) => not found$")
    else ()
      message(FATAL_ERROR
        "Unrecognized binary format: ${format}")
    endif ()

    execute_process(
      COMMAND ${command} "${module}"
      RESULT_VARIABLE res
      OUTPUT_VARIABLE out
      ERROR_VARIABLE err
      OUTPUT_STRIP_TRAILING_WHITESPACE
      ERROR_STRIP_TRAILING_WHITESPACE)
    if (res)
      message(SEND_ERROR
        "Failed to run `${command}` on '${module}': ${err}")
    endif ()

    string(REPLACE "\n" ";" lines "${out}")

    foreach (line IN LISTS lines)
      if (line MATCHES "${ignore_regex}")
        continue ()
      endif ()

      if (line MATCHES "${missing_regex}")
        string(REGEX REPLACE "${libname_regex}" "\\1" libname "${line}")
        message(SEND_ERROR
          "'${module}' cannot find library ${libname}")
      endif ()
    endforeach ()
  endfunction ()

  file(GLOB binaries "${directory}/bin/*")
  file(GLOB macos_binaries "${directory}/MacOS/*")
  file(GLOB_RECURSE so_libraries "${directory}/*.so*")
  file(GLOB_RECURSE dylib_libraries "${directory}/*.dylib*")

  set(expected_format)
  if (APPLE)
    set(expected_format "Mach-O")
  elseif (UNIX)
    set(expected_format "ELF")
  endif ()

  if (NOT expected_format)
    message(FATAL_ERROR
      "No expected format; nothing to test.")
  endif ()

  foreach (module IN LISTS binaries macos_binaries so_libraries dylib_libraries)
    # Skip symlinks.
    if (IS_SYMLINK "${module}")
      continue ()
    endif ()

    set(exclude 0)
    foreach (exclude IN LISTS excludes)
      if (module MATCHES "${exclude}")
        set(exclude 1)
        break ()
      endif ()
    endforeach ()
    if (exclude)
      continue ()
    endif ()

    # Skip files not in the expected format.
    _superbuild_test_file_type("${module}" module_format)
    if (NOT module_format STREQUAL expected_format)
      continue ()
    endif ()

    message(STATUS "Testing ${module}")

    _superbuild_test_loadable_module("${module}" "${module_format}")
  endforeach ()
endif ()
