cmake_minimum_required(VERSION 3.19)

project(superbuild-selftest)

option(SUPERBUILD_ENABLE_OPENSSL "Enable support for OpenSSL" OFF)
set(_superbuild_enable_openssl "${SUPERBUILD_ENABLE_OPENSSL}")

function (superbuild_find_projects var)
  set(projects
    alembic
    boost
    bzip2
    cgns
    cxx11
    cxx14
    cxx17
    embree
    exodus
    flexbison
    fortran
    freetype
    hdf5
    hdf5cpp
    imath
    ispc
    jsoncpp
    lapack
    libjpegturbo
    llvm
    openmp
    matplotlib
    meson
    mpi
    netcdf
    ninja
    nlohmannjson
    numpy
    openimagedenoise
    openvkl
    osmesa
    ospray
    ospraymaterials
    ospraymodulempi
    png
    python3
    pythonaiohttp
    pythonasynctimeout
    pythonattrs
    pythonbeniget
    pythoncffi
    pythonchardet
    pythoncppy
    pythoncryptography
    pythoncycler
    pythoncython
    pythondateutil
    pythonflitcore
    pythongast
    pythonidna
    pythonkiwisolver
    pythonmako
    pythonmarkupsafe
    pythonmesonpython
    pythonmpi4py
    pythonmpmath
    pythonmultidict
    pythonpackaging
    pythonpandas
    pythonpillow
    pythonply
    pythonpycparser
    pythonpygments
    pythonpyparsing
    pythonpyprojectmetadata
    pythonpythran
    pythonsemanticversion
    pythonsetuptools
    pythonsetuptoolsrust
    pythonsetuptoolsscm
    pythonsix
    pythontoml
    pythontomli
    pythontypingextensions
    pythonwheel
    pythonwslinkasync
    pythonyarl
    pytz
    qhull
    qt5
    rkcommon
    scipy
    seacas
    snappy
    sqlite
    sympy
    szip
    tbb
    xz
    zlib)

  if (SUPERBUILD_ENABLE_OPENSSL)
    list(APPEND projects
      openssl)
  endif ()

  if (WIN32)
    list(APPEND projects
      pywin32)
  endif ()

  if (NOT WIN32)
    list(APPEND projects
      expat
      ffi
      ffmpeg
      gperf
      libxml2
      pkgconf
      pybind11)
  endif ()

  if (NOT APPLE)
    list(APPEND projects
      mesa
      openxrsdk)
  endif ()

  if (UNIX AND NOT APPLE)
    list(APPEND projects
      egl
      fontconfig
      glproto
      utillinux)
  endif ()

  set("${var}"
    ${projects}
    PARENT_SCOPE)

  # For later usage.
  set_property(GLOBAL PROPERTY _superbuild_all_projects ${projects})
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
