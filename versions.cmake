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
  URL     "http://www.computationalmodelbuilder.org/files/dependencies/boost_1_59_0.tar.bz2"
  URL_MD5 6aa9a5c6a4ca1016edd0ed1178e3cb87)

superbuild_set_revision(png
  URL     "http://www.paraview.org/files/dependencies/libpng-1.6.23.tar.gz"
  URL_MD5 a49e4cc48d968c79def53d082809c9f2)

if (WIN32)
  if (superbuild_is_64bit)
    superbuild_set_revision(python
      URL     "http://www.paraview.org/files/dependencies/python-2.7.2-win64.tar.gz"
      URL_MD5 b9724a3b29274b5b52d2f0a1c8c0d5d3)
  else ()
    superbuild_set_revision(python
      URL     "http://www.paraview.org/files/dependencies/python-2.7.2-win32.tar.gz"
      URL_MD5 e54eadacee0a418d44e6671a803119f5)
  endif ()
else()
  superbuild_set_revision(python
    URL     "http://paraview.org/files/dependencies/Python-2.7.11.tgz"
    URL_MD5 6b6076ec9e93f05dd63e47eb9c15728b)
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

set(qt5_ver_series "5.6")
set(qt5_ver "${qt5_ver_series}.0")
if (WIN32)
  set(qt5_ext "zip")
  set(qt5_md5 "03402708f260dcc917abae9bc559c1df")
else ()
  set(qt5_ext "tar.gz")
  set(qt5_md5 "7a2a867bc12384f4161809136d49d4be")
endif ()
superbuild_set_revision(qt5
  URL     "http://download.qt.io/official_releases/qt/${qt5_ver_series}/${qt5_ver}/single/qt-everywhere-opensource-src-${qt5_ver}.${qt5_ext}"
  URL_MD5 "${qt5_md5}")

if (WIN32)
  if (superbuild_is_64bit)
    superbuild_set_revision(numpy
      URL     "http://paraview.org/files/dependencies/numpy-1.8.1-win64.tar.gz"
      URL_MD5 7f5dc0fd1464f64baca7956cba231d30)
  else ()
    superbuild_set_revision(numpy
      URL     "http://paraview.org/files/dependencies/numpy-1.8.1-win32.tar.gz"
      URL_MD5 c0865735461ad432506262c66d30fc29)
  endif ()
else ()
  superbuild_set_revision(numpy
    URL     "http://paraview.org/files/dependencies/numpy-1.8.1+cmake+static.tar.bz2"
    URL_MD5 1974dbb4bfa1509e492791a8cd225774)
endif ()

if (WIN32)
  if (superbuild_is_64bit)
    superbuild_set_revision(matplotlib
      URL     "http://paraview.org/files/dependencies/matplotlib-1.8.1-win64.tar.gz"
      URL_MD5 da0f5d217fefadb27314424d44bc014c)
  else ()
    superbuild_set_revision(matplotlib
      URL     "http://paraview.org/files/dependencies/matplotlib-1.8.1-win32.tar.gz"
      URL_MD5 d1c4713eb0988be8d3899e5b6545829f)
  endif ()
else ()
  superbuild_set_revision(matplotlib
    URL     "http://paraview.org/files/dependencies/matplotlib-1.1.1_notests.tar.gz"
    URL_MD5 30ee59119599331bf1f3b6e838fee9a8)
endif ()

if (WIN32)
  if (superbuild_is_64bit)
    superbuild_set_revision(pywin32
      URL     "http://paraview.org/files/dependencies/pywin32-220-win64.tar.gz"
      URL_MD5 7d7c6fdb6a5f11911df95cec624c845e)
  else ()
    superbuild_set_revision(pywin32
      URL     "http://paraview.org/files/dependencies/pywin32-220-win32.tar.gz"
      URL_MD5 ffa1183f3e5719cbacf2b39b7105df8d)
  endif ()
endif ()

superbuild_set_revision(mpi
  URL     "http://paraview.org/files/dependencies/mpich2-1.4.1p1.tar.gz"
  URL_MD5 b470666749bcb4a0449a072a18e2c204)

superbuild_set_revision(lapack
  URL     "http://paraview.org/files/dependencies/lapack-3.4.2.tgz"
  URL_MD5 61bf1a8a4469d4bdb7604f5897179478)

# TODO: split into netcdf and netcdfcpp
# TODO: use a patch
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

superbuild_set_revision(pythonsetuptools
  URL     "https://pypi.python.org/packages/45/5e/79ca67a0d6f2f42bfdd9e467ef97398d6ad87ee2fa9c8cdf7caf3ddcab1e/setuptools-23.0.0.tar.gz"
  URL_MD5 100a90664040f8ff232fbac02a4c5652)
