cmake_minimum_required(VERSION 3.18)

project(standalone-mesa)

include(CTest)

function (superbuild_find_projects var)
  set(projects
    bzip2
    cxx11
    cxx17
    expat
    ffi
    flexbison
    glproto
    llvm
    mesa
    meson
    ninja
    png
    python3
    pythonmako
    pythonsetuptools
    sqlite
    xz
    zlib)

  set("${var}"
    ${projects}
    PARENT_SCOPE)
endfunction ()

function (superbuild_sanity_check)
  if (NOT mesa_enabled)
    message(FATAL_ERROR "Mesa must be enabled.")
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

  set(mesa_PACKAGE_FILE_NAME "mesa-${mesa_version}")
  list(APPEND superbuild_export_variables
    mesa_PACKAGE_FILE_NAME)

  list(APPEND superbuild_export_variables
    mesa_SWR_ARCH)

  foreach (generator IN LISTS generators)
    superbuild_add_extra_package_test(mesa "${generator}"
      TIMEOUT 6400)
  endforeach ()

  superbuild_enable_install_target("mesa/${default_generator}")
endfunction ()

set(_superbuild_default_mesa ON)

set(superbuild_install_location "${CMAKE_BINARY_DIR}/install")

list(APPEND superbuild_project_roots
  "${CMAKE_CURRENT_LIST_DIR}/projects")

get_filename_component(sb_dir "${CMAKE_CURRENT_LIST_DIR}" DIRECTORY)
add_subdirectory("${sb_dir}" "${CMAKE_CURRENT_BINARY_DIR}/superbuild")
