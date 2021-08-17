set(BUILD_TESTING ON CACHE BOOL "")

function (enable_project name)
  set("ENABLE_${name}" ON CACHE BOOL "")
  set("SUPPRESS_${name}_OUTPUT" ON CACHE BOOL "")
endfunction ()

if ("$ENV{CMAKE_CONFIGURATION}" MATCHES "openssl")
  set(SUPERBUILD_ENABLE_OPENSSL ON CACHE BOOL "")
  enable_project(openssl)
endif ()

if ("$ENV{CMAKE_CONFIGURATION}" MATCHES "python2")
  enable_project(python2)
else ()
  enable_project(python3)
endif ()

enable_project(boost)
enable_project(bzip2)
enable_project(cxx11)
enable_project(ffi)
enable_project(ffmpeg)
enable_project(fontconfig)
enable_project(freetype)
enable_project(gperf)
enable_project(hdf5)
enable_project(libjpegturbo)
enable_project(libxml2)
enable_project(matplotlib)
enable_project(mpi)
enable_project(netcdf)
enable_project(nlohmannjson)
enable_project(numpy)
enable_project(pkgconf)
enable_project(png)
enable_project(pybind11)
enable_project(python)
enable_project(pythonaiohttp)
enable_project(pythonasynctimeout)
enable_project(pythonattrs)
enable_project(pythonautobahn)
enable_project(pythonbeniget)
enable_project(pythoncffi)
enable_project(pythonchardet)
enable_project(pythonconstantly)
enable_project(pythoncppy)
enable_project(pythoncryptography)
enable_project(pythoncycler)
enable_project(pythoncython)
enable_project(pythondateutil)
enable_project(pythongast)
enable_project(pythonhyperlink)
enable_project(pythonidna)
enable_project(pythonincremental)
enable_project(pythonkiwisolver)
enable_project(pythonmpi4py)
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
enable_project(pythontwisted)
enable_project(pythontxaio)
enable_project(pythontypingextensions)
enable_project(pythonwheel)
enable_project(pythonwslink)
enable_project(pythonwslinkasync)
enable_project(pythonpywebvue)
enable_project(pythonyarl)
enable_project(pythonzope)
enable_project(pythonzopeinterface)
enable_project(pytz)
enable_project(pywin32)
enable_project(qhull)
enable_project(qt5)
enable_project(szip)
enable_project(utillinux)
enable_project(zlib)

# Fortran doesn't work on Windows right now.
if (NOT "$ENV{CMAKE_CONFIGURATION}" MATCHES "windows" AND
    NOT "$ENV{CMAKE_CONFIGURATION}" MATCHES "macos_arm64")
  enable_project(fortran)
  enable_project(lapack)
  enable_project(scipy)
endif ()

# TBB doesn't have macOS arm64 support yet.
if (NOT "$ENV{CMAKE_CONFIGURATION}" MATCHES "macos_arm64")
  enable_project(tbb)
endif ()

# qt5 things
set(qt5_SOURCE_SELECTION            "5.12" CACHE STRING "")
# the gold linker seems to fail with internal error on centos7 builds
# disabling
set(qt5_EXTRA_CONFIGURATION_OPTIONS "-no-use-gold-linker" CACHE STRING "")

# Default to Release builds.
if ("$ENV{CMAKE_BUILD_TYPE}" STREQUAL "")
  set(CMAKE_BUILD_TYPE "Release" CACHE STRING "")
else ()
  set(CMAKE_BUILD_TYPE "$ENV{CMAKE_BUILD_TYPE}" CACHE STRING "")
endif ()

include("${CMAKE_CURRENT_LIST_DIR}/configure_sccache.cmake")
