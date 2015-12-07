# This maintains the links for all sources used by this superbuild.
# Simply update this file to change the revision.
# One can use different revision on different platforms.
# e.g.
# if (UNIX)
#   ..
# else (APPLE)
#   ..
# endif()

include(CMakeDependentOption)

# NOTE: if updating bzip2 version, fix patch in bzip2.cmake
superbuild_set_revision(bzip2
  URL     "http://www.paraview.org/files/dependencies/bzip2-1.0.6.tar.gz"
  URL_MD5 00b516f4704d4a7cb50a1d97e6e8e15b)

# NOTE: if updating zlib version, fix patch in zlib.cmake
superbuild_set_revision(zlib
  URL     "http://www.paraview.org/files/dependencies/zlib-1.2.7.tar.gz"
  URL_MD5 60df6a37c56e7c1366cca812414f7b85)

superbuild_set_revision(ffmpeg
  URL     "http://paraview.org/files/dependencies/ffmpeg-2.3.3.tar.bz2"
  URL_MD5 72361d3b8717b6db3ad2b9da8df7af5e)

superbuild_set_revision(szip
  URL     "http://paraview.org/files/dependencies/szip-2.1.tar.gz"
  URL_MD5 902f831bcefb69c6b635374424acbead)

superbuild_set_revision(hdf5
  URL     "http://www.paraview.org/files/dependencies/hdf5-1.8.13.tar.gz"
  URL_MD5 c03426e9e77d7766944654280b467289)

superbuild_set_revision(boost
  URL     "http://www.computationalmodelbuilder.org/files/dependencies/boost_1_56_0.tar.gz"
  URL_MD5 8c54705c424513fa2be0042696a3a162)

superbuild_set_revision(png
  URL     "http://paraview.org/files/dependencies/libpng-1.4.8.tar.gz"
  URL_MD5 49c6e05be5fa88ed815945d7ca7d4aa9)

if (WIN32)
  if (64bit_build)
    superbuild_set_revision(python
      URL     "http://www.computationalmodelbuilder.org/files/dependencies/python+deps.tar.bz2"
      URL_MD5 0b0ceb15fee34dae011f90570888c429)
  else ()
    superbuild_set_revision(python
      URL     "http://www.computationalmodelbuilder.org/files/dependencies/python+deps-x32.tar.bz2"
      URL_MD5 df1438352768caecf929d7bc2bdf841c)
  endif ()
elseif (CROSS_BUILD_STAGE STREQUAL "CROSS")
  superbuild_set_revision(python
    URL     "http://www.paraview.org/files/dependencies/Python-2.7.3.tgz"
    URL_MD5 2cf641732ac23b18d139be077bd906cd)
else()
  superbuild_set_revision(python
    URL     "http://paraview.org/files/dependencies/Python-2.7.2.tgz"
    URL_MD5 0ddfe265f1b3d0a8c2459f5bf66894c7)
endif()

superbuild_set_revision(freetype
  URL     "http://paraview.org/files/dependencies/freetype-2.4.8.tar.gz"
  URL_MD5 5d82aaa9a4abc0ebbd592783208d9c76)

superbuild_set_revision(fontconfig
  URL     "http://paraview.org/files/dependencies/fontconfig-2.8.0.tar.gz"
  URL_MD5 77e15a92006ddc2adbb06f840d591c0e)

superbuild_set_revision(libxml2
  URL     "http://paraview.org/files/dependencies/libxml2-2.7.8.tar.gz"
  URL_MD5 8127a65e8c3b08856093099b52599c86)

if (WIN32)
  set(qt4_ver "4.8.4")
  set(qt4_md5 "89c5ecba180cae74c66260ac732dc5cb")
else ()
  set(qt4_ver "4.8.6")
  set(qt4_md5 "2edbe4d6c2eff33ef91732602f3518eb")
endif ()
superbuild_set_revision(qt4
  URL     "http://paraview.org/files/dependencies/qt-everywhere-opensource-src-${qt4_ver}.tar.gz"
  URL_MD5 "${qt4_md5}")

set(qt5_ver_series "5.4")
set(qt5_ver "${qt5_version_series}.1")
if (WIN32)
  set(qt5_ext "zip")
  set(qt5_md5 "57b25c68982237abb9e18b347034e005")
else ()
  set(qt5_ext "tar.gz")
  set(qt5_md5 "90f3fbce38ed16e5dc2cd0909ae86ca4")
endif ()
superbuild_set_revision(qt5
  URL     "http://download.qt.io/official_releases/qt/${qt5_ver_series}/${qt5_ver}/single/qt-everywhere-opensource-src-${qt5_ver}.${qt5_ext}"
  URL_MD5 "${qt5_md5}")

superbuild_set_revision(numpy
  URL     "http://paraview.org/files/dependencies/numpy-1.8.1+cmake+static.tar.bz2"
  URL_MD5 1974dbb4bfa1509e492791a8cd225774)

superbuild_set_revision(matplotlib
  URL     "http://paraview.org/files/dependencies/matplotlib-1.1.1_notests.tar.gz"
  URL_MD5 30ee59119599331bf1f3b6e838fee9a8)

superbuild_set_revision(mpi
  URL     "http://paraview.org/files/dependencies/mpich2-1.4.1p1.tar.gz"
  URL_MD5 b470666749bcb4a0449a072a18e2c204)

superbuild_set_revision(lapack
  URL     "http://paraview.org/files/dependencies/lapack-3.4.2.tgz"
  URL_MD5 61bf1a8a4469d4bdb7604f5897179478)

superbuild_set_revision(netcdf
  URL     "http://www.paraview.org/files/dependencies/netcdf-4.3.2.modified.tar.gz"
  URL_MD5 1841196c2bfcf10246966eecf92ad0ec)

set(tbb_ver "44_20150728oss")
if (WIN32)
  set(tbb_file "tbb${tbb_ver}_win.zip")
  set(tbb_md5 "e7bbf293cdb5a50ca81347c80168956d")
elseif (APPLE)
  set(tbb_file "tbb${tbb_ver}_osx.tgz")
  set(tbb_md5 "a767d7a8b375e6b054e44e2317d806b8")
else ()
  set(tbb_file "tbb${tbb_ver}_lin_0.tgz")
  set(tbb_md5 "ab5df80a65adf423b14637a1f35814b2")
endif ()

superbuild_set_revision(tbb
  URL     "http://www.paraview.org/files/dependencies/${tbb_file}"
  URL_MD5 "${tbb_md5}")
