set(BUILD_TESTING ON CACHE BOOL "")

# Enable the `IN_LIST` operator.
cmake_policy(SET CMP0057 NEW)

# If testing specific projects, list them here to test only those projects.
# Please use a `WIP` commit to modify this list so that it does not
# accidentally get merged.
set(_ci_only_projects)

function (enable_project name)
  set(value ON)
  if (_ci_only_projects AND NOT name IN_LIST _ci_only_projects)
    set(value OFF)
  endif ()

  set("ENABLE_${name}" "${value}" CACHE BOOL "")
  set("SUPPRESS_${name}_OUTPUT" ON CACHE BOOL "")
endfunction ()

if ("$ENV{CMAKE_CONFIGURATION}" MATCHES "openssl")
  set(SUPERBUILD_ENABLE_OPENSSL ON CACHE BOOL "")
  enable_project(openssl)
endif ()

enable_project(boost)
enable_project(bzip2)
enable_project(cxx11)
enable_project(expat)
enable_project(ffi)
enable_project(ffmpeg)
enable_project(fontconfig)
enable_project(freetype)
enable_project(glproto)
enable_project(gperf)
enable_project(hdf5)
# Explicitly do not enable; it conflicts with `mpi` + `hdf5` which is a more
# important use case for actually building things.
#enable_project(hdf5cpp)
enable_project(jsoncpp)
enable_project(libjpegturbo)
enable_project(libxml2)
enable_project(llvm)
enable_project(matplotlib)
enable_project(mesa)
enable_project(meson)
enable_project(mpi)
enable_project(netcdf)
enable_project(ninja)
enable_project(nlohmannjson)
enable_project(numpy)
enable_project(osmesa)
enable_project(pkgconf)
enable_project(png)
enable_project(pybind11)
enable_project(python3)
enable_project(pythonaiohttp)
enable_project(pythonasynctimeout)
enable_project(pythonattrs)
enable_project(pythonbeniget)
enable_project(pythoncffi)
enable_project(pythonchardet)
enable_project(pythoncppy)
enable_project(pythoncryptography)
enable_project(pythoncycler)
enable_project(pythoncython)
enable_project(pythondateutil)
enable_project(pythongast)
enable_project(pythonidna)
enable_project(pythonkiwisolver)
enable_project(pythonmpi4py)
enable_project(pythonmpmath)
enable_project(pythonmultidict)
enable_project(pythonpillow)
enable_project(pythonply)
enable_project(pythonpycparser)
enable_project(pythonpygments)
enable_project(pythonpyparsing)
enable_project(pythonpythran)
enable_project(pythonsemanticversion)
enable_project(pythonsetuptools)
enable_project(pythonsetuptoolsrust)
enable_project(pythonsetuptoolsscm)
enable_project(pythonsix)
enable_project(pythontoml)
enable_project(pythontypingextensions)
enable_project(pythonwheel)
enable_project(pythonwslinkasync)
enable_project(pythonyarl)
enable_project(pytz)
enable_project(pywin32)
enable_project(qhull)
enable_project(qt5)
enable_project(sqlite)
enable_project(sympy)
enable_project(szip)
enable_project(tbb)
enable_project(utillinux)
enable_project(xz)
enable_project(zlib)

# OpenXR-SDK-Source does not build on mac os
if (NOT "$ENV{CMAKE_CONFIGURATION}" MATCHES "macos")
  enable_project(openxrsdk)
endif ()

# Fortran doesn't work on Windows or macOS arm64 right now.
if (NOT "$ENV{CMAKE_CONFIGURATION}" MATCHES "windows" AND
    NOT "$ENV{CMAKE_CONFIGURATION}" MATCHES "macos_arm64")
  enable_project(fortran)
  enable_project(lapack)
  enable_project(scipy)
endif ()

# But scipy does work on Windows.
if ("$ENV{CMAKE_CONFIGURATION}" MATCHES "windows")
  enable_project(scipy)
endif ()

# qt5 things
set(qt5_SOURCE_SELECTION            "5.15" CACHE STRING "")
# the gold linker seems to fail with internal error on centos7 builds
# disabling
set(qt5_EXTRA_CONFIGURATION_OPTIONS "-no-use-gold-linker" CACHE STRING "")

# Default to Release builds.
if ("$ENV{CMAKE_BUILD_TYPE}" STREQUAL "")
  set(CMAKE_BUILD_TYPE "Release" CACHE STRING "")
else ()
  set(CMAKE_BUILD_TYPE "$ENV{CMAKE_BUILD_TYPE}" CACHE STRING "")
endif ()

include("${CMAKE_CURRENT_LIST_DIR}/configure_cache.cmake")
