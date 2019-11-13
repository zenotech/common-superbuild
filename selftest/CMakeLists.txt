cmake_minimum_required(VERSION 3.0)

project(superbuild-selftest)

function (superbuild_find_projects var)
  set(projects
    boost
    bzip2
    cxx11
    ffi
    fortran
    freetype
    hdf5
    lapack
    matplotlib
    mpi
    netcdf
    nlohmannjson
    numpy
    png
    python
    python2
    python3
    pythonattrs
    pythonautobahn
    pythonconstantly
    pythoncycler
    pythondateutil
    pythonhyperlink
    pythonincremental
    pythonkiwisolver
    pythonmpi4py
    pythonpygments
    pythonpyparsing
    pythonsetuptools
    pythonsix
    pythontwisted
    pythontxaio
    pythonwslink
    pythonzope
    pythonzopeinterface
    pytz
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
  include(python.functions)
  superbuild_python_sanity_check()

  include(qt.functions)
  superbuild_qt_sanity_check()
endfunction ()

get_filename_component(sb_dir "${CMAKE_CURRENT_LIST_DIR}" DIRECTORY)
add_subdirectory("${sb_dir}" "${CMAKE_CURRENT_BINARY_DIR}/superbuild")
