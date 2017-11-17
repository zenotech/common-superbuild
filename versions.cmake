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
  URL     "https://www.paraview.org/files/dependencies/bzip2-1.0.6.tar.gz"
  URL_MD5 00b516f4704d4a7cb50a1d97e6e8e15b)

superbuild_set_revision(zlib
  URL     "https://www.paraview.org/files/dependencies/zlib-1.2.7.tar.gz"
  URL_MD5 60df6a37c56e7c1366cca812414f7b85)

superbuild_set_revision(ffmpeg
  URL     "https://www.paraview.org/files/dependencies/ffmpeg-2.3.3.tar.bz2"
  URL_MD5 72361d3b8717b6db3ad2b9da8df7af5e)

superbuild_set_revision(szip
  URL     "https://www.paraview.org/files/dependencies/szip-2.1.tar.gz"
  URL_MD5 902f831bcefb69c6b635374424acbead)

superbuild_set_revision(hdf5
  URL     "https://www.paraview.org/files/dependencies/hdf5-1.8.13.tar.gz"
  URL_MD5 c03426e9e77d7766944654280b467289)

superbuild_set_revision(boost
  URL     "https://www.paraview.org/files/dependencies/boost_1_59_0.tar.bz2"
  URL_MD5 6aa9a5c6a4ca1016edd0ed1178e3cb87)

superbuild_set_revision(png
  URL     "https://www.paraview.org/files/dependencies/libpng-1.6.23.tar.gz"
  URL_MD5 a49e4cc48d968c79def53d082809c9f2)

if (WIN32)
  if (superbuild_is_64bit)
    superbuild_set_revision(python
      URL     "https://www.paraview.org/files/dependencies/python-2.7.3-win64-20170214.tar.gz"
      URL_MD5 882a5d1446c593f0be039d2c3752f860)
  else ()
    superbuild_set_revision(python
      URL     "https://www.paraview.org/files/dependencies/python-2.7.3-win32-20170214.tar.gz"
      URL_MD5 455ad98b196582d48b0d31236b31ca9a)
  endif ()
else()
  superbuild_set_revision(python
    URL     "https://www.paraview.org/files/dependencies/Python-2.7.11.tgz"
    URL_MD5 6b6076ec9e93f05dd63e47eb9c15728b)
endif()

superbuild_set_revision(ftjam
  URL     "https://www.paraview.org/files/dependencies/ftjam-2.5.2-win32.tar.bz2"
  URL_MD5 ee52f3faff6d31ffb89a2fedb3b0caf6)

superbuild_set_revision(freetype
  URL     "https://www.paraview.org/files/dependencies/freetype-2.8.1.tar.bz2"
  URL_MD5 bf0a210b6fe781228fa0e4a80691a521)

superbuild_set_revision(fontconfig
  URL     "https://www.paraview.org/files/dependencies/fontconfig-2.12.6.tar.bz2"
  URL_MD5 733f5e2371ca77b69707bd7b30cc2163)

superbuild_set_revision(libxml2
  URL     "https://www.paraview.org/files/dependencies/libxml2-2.7.8.tar.gz"
  URL_MD5 8127a65e8c3b08856093099b52599c86)

if (WIN32)
  set(qt4_ver "4.8.4")
  set(qt4_md5 "89c5ecba180cae74c66260ac732dc5cb")
else ()
  set(qt4_ver "4.8.6")
  set(qt4_md5 "2edbe4d6c2eff33ef91732602f3518eb")
endif ()
superbuild_set_revision(qt4
  URL     "https://www.paraview.org/files/dependencies/qt-everywhere-opensource-src-${qt4_ver}.tar.gz"
  URL_MD5 "${qt4_md5}")

set(qt5_ver "5.9.2")
if (WIN32)
  set(qt5_ext "zip")
  set(qt5_md5 "d5239e19f6b80dcf44f4dd2de04c7d3d")
else ()
  set(qt5_ext "tar.xz")
  set(qt5_md5 "738d1b98106e1bd39f00cc228beb522a")
endif ()
superbuild_set_revision(qt5
  URL     "https://www.paraview.org/files/dependencies/qt-everywhere-opensource-src-${qt5_ver}.${qt5_ext}"
  URL_MD5 "${qt5_md5}")

if (WIN32 AND NOT superbuild_building_prebuilt_python)
  if (superbuild_is_64bit)
    superbuild_set_revision(numpy
      URL     "https://www.paraview.org/files/dependencies/numpy-1.8.1-win64-20160927.tar.gz"
      URL_MD5 c03c7f0d9e88b9d0d2eaedb4571dab90)
  else ()
    superbuild_set_revision(numpy
      URL     "https://www.paraview.org/files/dependencies/numpy-1.8.1-win32-20160927.tar.gz"
      URL_MD5 548f894f23dfd87de14191a8425eb6e0)
  endif ()
else ()
  superbuild_set_revision(numpy
    URL     "https://www.paraview.org/files/dependencies/numpy-1.8.1+cmake+static.tar.bz2"
    URL_MD5 1974dbb4bfa1509e492791a8cd225774)
  superbuild_set_revision(scipy
    URL     "https://www.paraview.org/files/dependencies/scipy-0.15.1.tar.gz"
    URL_MD5 be56cd8e60591d6332aac792a5880110)
endif ()

if (WIN32 AND NOT superbuild_building_prebuilt_python)
  if (superbuild_is_64bit)
    superbuild_set_revision(matplotlib
      URL     "https://www.paraview.org/files/dependencies/matplotlib-1.1.1-win64-20160927.tar.gz"
      URL_MD5 cf20ab4210fe1ebd541ab04221d93e46)
  else ()
    superbuild_set_revision(matplotlib
      URL     "https://www.paraview.org/files/dependencies/matplotlib-1.1.1-win32-20160927.tar.gz"
      URL_MD5 c14d6c4f43f2bba537c027035c8e195a)
  endif ()
else ()
  superbuild_set_revision(matplotlib
    URL     "https://www.paraview.org/files/dependencies/matplotlib-1.1.1_notests.tar.gz"
    URL_MD5 30ee59119599331bf1f3b6e838fee9a8)
endif ()

if (WIN32 AND NOT superbuild_building_prebuilt_python)
  if (superbuild_is_64bit)
    superbuild_set_revision(pywin32
      URL     "https://www.paraview.org/files/dependencies/pywin32-220-win64-20160927.tar.gz"
      URL_MD5 064c396b315d2c1a11096df9378a503a)
  else ()
    superbuild_set_revision(pywin32
      URL     "https://www.paraview.org/files/dependencies/pywin32-220-win32-20160927.tar.gz"
      URL_MD5 83ce04df1d0084b7adb1c94a8734423e)
  endif ()
else ()
  superbuild_set_revision(pywin32
    URL     "https://www.paraview.org/files/dependencies/pywin32-220.zip"
    URL_MD5 9c386839c1485b2047c03fab66e69b9e)
endif ()

superbuild_set_revision(mpi
  URL     "https://www.paraview.org/files/dependencies/mpich-3.2.tar.gz"
  URL_MD5 f414cfa77099cd1fa1a5ae4e22db508a)

superbuild_set_revision(lapack
  URL     "https://www.paraview.org/files/dependencies/lapack-3.4.2.tgz"
  URL_MD5 61bf1a8a4469d4bdb7604f5897179478)

# TODO: split into netcdf and netcdfcpp
# TODO: use a patch
superbuild_set_revision(netcdf
  URL     "https://www.paraview.org/files/dependencies/netcdf-4.3.2.modified.tar.gz"
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
  URL     "https://www.paraview.org/files/dependencies/${tbb_file}"
  URL_MD5 "${tbb_md5}")

superbuild_set_revision(pythonsetuptools
  URL     "https://www.paraview.org/files/dependencies/setuptools-23.0.0.tar.gz"
  URL_MD5 100a90664040f8ff232fbac02a4c5652)
