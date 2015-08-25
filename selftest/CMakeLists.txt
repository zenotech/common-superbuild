cmake_minimum_required(VERSION 3.0)

project(superbuild-selftest)

function (superbuild_find_projects var)
  set(projects
    boost
    bzip2
    fontconfig
    freetype
    hdf5
    lapack
    matplotlib
    netcdf
    numpy
    png
    python
    qt4
    qt5
    szip
    zlib)

  if (NOT WIN32)
    list(APPEND projects
      ffmpeg
      mpi
      libxml2)
  endif ()

  set("${var}"
    ${projects}
    PARENT_SCOPE)
endfunction ()

function (superbuild_sanity_check)
  if (qt4_enabled AND qt5_enabled)
    message(FATAL_ERROR "qt4 and qt5 cannot be enabled at the same time.")
  endif ()
endfunction ()

get_filename_component(sb_dir "${CMAKE_CURRENT_LIST_DIR}" DIRECTORY)
add_subdirectory("${sb_dir}" "${CMAKE_CURRENT_BINARY_DIR}/superbuild")
