cmake_minimum_required(VERSION 3.0)

project(prebuilt-python2)

if (NOT WIN32 OR NOT MSVC90)
  message(FATAL_ERROR "This project requires Visual Studio 2008 to work")
endif ()
set(superbuild_building_prebuilt_python ON)

function (superbuild_find_projects var)
  set(projects
    bzip2
    cxx11
    freetype
    png
    python
    python2
    pythoncycler
    pythondateutil
    pythonpyparsing
    pythonsetuptools
    pythonsix
    pytz
    pywin32
    matplotlib
    numpy
    zlib)

  set("${var}"
    ${projects}
    PARENT_SCOPE)
endfunction ()

function (superbuild_sanity_check)
  if (NOT python2_enabled)
    message(FATAL_ERROR "The python2 project must be enabled.")
  endif ()
endfunction ()

function (superbuild_add_packaging)
  if (python_enabled)
    superbuild_add_extra_package_test(python TGZ
      LABELS  "python"
      TIMEOUT 1200)
  endif ()

  if (numpy_enabled)
    superbuild_add_extra_package_test(numpy TGZ
      LABELS  "python"
      TIMEOUT 1200)
  endif ()

  if (matplotlib_enabled)
    superbuild_add_extra_package_test(matplotlib TGZ
      LABELS  "python"
      TIMEOUT 1200)
  endif ()

  if (pywin32_enabled)
    superbuild_add_extra_package_test(pywin32 TGZ
      LABELS  "python"
      TIMEOUT 1200)
  endif ()
endfunction ()

function (superbuild_add_tests)
endfunction ()

option(superbuild_use_prebuilt_python "Use a prebuilt-python binary" OFF)

list(APPEND superbuild_project_roots
  "${CMAKE_CURRENT_LIST_DIR}/projects")

get_filename_component(sb_dir "${CMAKE_CURRENT_LIST_DIR}" DIRECTORY)
add_subdirectory("${sb_dir}" "${CMAKE_CURRENT_BINARY_DIR}/superbuild")
