cmake_minimum_required(VERSION 3.18)

project(standalone-mesa)

include(CTest)

function (superbuild_find_projects var)
  set(projects
    bzip2
    cxx11
    cxx17
    flexbison
    llvm
    mesa
    meson
    ninja
    osmesa
    png
    python3
    pythonflitcore
    pythonmako
    pythonmarkupsafe
    pythonsetuptools
    pythonwheel
    sqlite
    xz
    zlib)

  if (UNIX)
    list(APPEND projects
      expat
      ffi
      glproto)
  endif ()

  if (WIN32)
    list(APPEND projects
      pywin32)
  endif ()

  set("${var}"
    ${projects}
    PARENT_SCOPE)
endfunction ()

function (superbuild_sanity_check)
  if (NOT mesa_enabled AND NOT osmesa_enabled)
    message(FATAL_ERROR "Mesa or OSMesa must be enabled.")
  endif ()
endfunction ()

function (superbuild_add_packaging)
  if (WIN32)
    set(generators
      ZIP)
  else ()
    set(generators
      TGZ)
  endif ()
  list(GET generators 0 default_generator)

  list(APPEND superbuild_export_variables)

  if (mesa_enabled)
    set(mesa_PACKAGE_FILE_NAME "mesa-${mesa_SOURCE_SELECTION}")
    list(APPEND superbuild_export_variables
      mesa_PACKAGE_FILE_NAME)
  endif ()

  if (osmesa_enabled)
    set(osmesa_PACKAGE_FILE_NAME "osmesa-${mesa_SOURCE_SELECTION}")
    list(APPEND superbuild_export_variables
      osmesa_PACKAGE_FILE_NAME)
  endif ()

  list(APPEND superbuild_export_variables
    mesa_SWR_ARCH
    mesa_SOURCE_SELECTION)

  foreach (generator IN LISTS generators)
    if (mesa_enabled AND UNIX AND NOT APPLE)
      superbuild_add_extra_package_test(mesa "${generator}"
        TIMEOUT 6400)
      if (NOT default_target)
        set(default_target "mesa/${generator}")
      endif ()
    endif ()
    if (osmesa_enabled AND WIN32)
      superbuild_add_extra_package_test(osmesa "${generator}"
        TIMEOUT 6400)
      if (NOT default_target)
        set(default_target "osmesa/${generator}")
      endif ()
    endif ()
  endforeach ()

  if (default_target)
    superbuild_enable_install_target("${default_target}")
  endif ()
endfunction ()

if (UNIX AND NOT APPLE)
  set(_superbuild_default_mesa ON)
endif ()
if (WIN32)
  set(_superbuild_default_osmesa ON)
endif ()

set(superbuild_install_location "${CMAKE_BINARY_DIR}/install")

list(APPEND superbuild_project_roots
  "${CMAKE_CURRENT_LIST_DIR}/projects")

get_filename_component(sb_dir "${CMAKE_CURRENT_LIST_DIR}" DIRECTORY)
add_subdirectory("${sb_dir}" "${CMAKE_CURRENT_BINARY_DIR}/superbuild")
