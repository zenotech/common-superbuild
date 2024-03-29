cmake_minimum_required(VERSION 3.0)

project(standalone-qt)

function (superbuild_find_projects var)
  set(projects
    cxx11
    freetype
    png
    qt5
    zlib)

  if (UNIX)
    list(APPEND projects
      libxml2)
  endif()

  if (UNIX AND NOT APPLE)
    list(APPEND projects
      pkgconf
      fontconfig
      gperf
      utillinux)
  endif ()

  set("${var}"
    ${projects}
    PARENT_SCOPE)
endfunction ()

set(QT5_SKIP_MODULES "" CACHE STRING "Do not build specified Qt5 modules. They should be separated with `;`")

set(qt_install_location ""
  CACHE PATH "Location to install Qt to.")
if (NOT qt_install_location)
  message(FATAL_ERROR "qt_install_location is not set!")
endif ()
set(superbuild_install_location "${qt_install_location}")
set(qt5_skip_modules "${QT5_SKIP_MODULES}")

get_filename_component(sb_dir "${CMAKE_CURRENT_LIST_DIR}" DIRECTORY)
add_subdirectory("${sb_dir}" "${CMAKE_CURRENT_BINARY_DIR}/superbuild")
