cmake_minimum_required(VERSION 3.19)

project(superbuild-selftest)

option(SUPERBUILD_ENABLE_OPENSSL "Enable support for OpenSSL" OFF)
set(_superbuild_enable_openssl "${SUPERBUILD_ENABLE_OPENSSL}")

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
    pythonbeniget
    pythoncffi
    pythonconstantly
    pythoncppy
    pythoncryptography
    pythoncycler
    pythoncython
    pythondateutil
    pythongast
    pythonhyperlink
    pythonidna
    pythonincremental
    pythonkiwisolver
    pythonmpi4py
    pythonply
    pythonpycparser
    pythonpygments
    pythonpyparsing
    pythonpythran
    pythonsemanticversion
    pythonsetuptools
    pythonsetuptoolsscm
    pythonsetuptoolsrust
    pythonsix
    pythontoml
    pythontwisted
    pythontxaio
    pythonwheel
    pythonwslink
    pythonzope
    pythonzopeinterface
    pytz
    qt5
    szip
    tbb
    zlib)

  if (SUPERBUILD_ENABLE_OPENSSL)
    list(APPEND projects
      openssl)
  endif ()

  if (WIN32)
    list(APPEND projects
      ftjam
      pywin32)
  endif ()

  if (NOT WIN32)
    list(APPEND projects
      ffi
      ffmpeg
      gperf
      libxml2
      pkgconf
      pybind11
      scipy
      sqlite
      utillinux)
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
endfunction ()

# Disable Qt modules that generally aren't necessary.
set(qt5_skip_modules
  qtconnectivity
  qtgamepad
  qtlocation
  qtmultimedia
  qtsensors
  qtserialport
  qtwayland
  qtwebchannel
  qtwebengine
  qtwebsockets)

get_filename_component(sb_dir "${CMAKE_CURRENT_LIST_DIR}" DIRECTORY)
add_subdirectory("${sb_dir}" "${CMAKE_CURRENT_BINARY_DIR}/superbuild")

include(CTest)
enable_testing()
add_subdirectory(tests)
