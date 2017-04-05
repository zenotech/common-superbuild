cmake_minimum_required(VERSION 3.0)

project(superbuild-selftest)

function (superbuild_find_projects var)
  set(projects
    boost
    bzip2
    cxx11
    fortran
    freetype
    hdf5
    lapack
    matplotlib
    netcdf
    numpy
    png
    python
    pythonpkgconfig
    pythonsetuptools
    pythonsix
    qt4
    qt5
    szip
    tbb
    zlib)

  if (WIN32)
    list(APPEND projects
      ftjam)
  endif ()

  if (NOT WIN32)
    list(APPEND projects
      ffmpeg
      mpi
      libxml2
      scipy)
  endif ()

  if (UNIX AND NOT APPLE)
    list(APPEND projects
      fontconfig)
  endif ()

  set("${var}"
    ${projects}
    PARENT_SCOPE)
endfunction ()

function (superbuild_sanity_check)
  include(qt.functions)

  superbuild_qt_sanity_check()
endfunction ()

get_filename_component(sb_dir "${CMAKE_CURRENT_LIST_DIR}" DIRECTORY)
add_subdirectory("${sb_dir}" "${CMAKE_CURRENT_BINARY_DIR}/superbuild")
