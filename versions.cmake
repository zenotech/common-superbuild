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
  URL "http://zlib.net/zlib-1.2.11.tar.gz"
  URL_MD5 1c9f62f0778697a09d36121ead88e08e)

superbuild_set_revision(ffmpeg
  URL     "http://www.paraview.org/files/dependencies/ffmpeg-2.3.3.tar.bz2"
  URL_MD5 72361d3b8717b6db3ad2b9da8df7af5e)

superbuild_set_revision(szip
  URL     "http://www.paraview.org/files/dependencies/szip-2.1.tar.gz"
  URL_MD5 902f831bcefb69c6b635374424acbead)

superbuild_set_revision(hdf5
  URL "https://support.hdfgroup.org/ftp/HDF5/current18/src/hdf5-1.8.19.tar.bz2"
  URL_MD5 6f0353ee33e99089c110a1c8d2dd1b22)

superbuild_set_revision(boost
  URL "https://dl.bintray.com/boostorg/release/1.65.1/source/boost_1_65_1.tar.gz"
  URL_MD5 ee64fd29a3fe42232c6ac3c419e523cf)

superbuild_set_revision(png
  URL "http://download.sourceforge.net/libpng/libpng-1.6.29.tar.gz"
  URL_MD5 68553080685f812d1dd7a6b8215c37d8)

if (WIN32)
  if (superbuild_is_64bit)
    superbuild_set_revision(python
      URL     "http://www.paraview.org/files/dependencies/python-2.7.3-win64-20170214.tar.gz"
      URL_MD5 882a5d1446c593f0be039d2c3752f860)
  else ()
    superbuild_set_revision(python
      URL     "http://www.paraview.org/files/dependencies/python-2.7.3-win32-20170214.tar.gz"
      URL_MD5 455ad98b196582d48b0d31236b31ca9a)
  endif ()
else()
  superbuild_set_revision(python
    URL "https://www.python.org/ftp/python/2.7.13/Python-2.7.13.tgz"
    URL_MD5 17add4bf0ad0ec2f08e0cae6d205c700)
endif()

superbuild_set_revision(ftjam
  URL     "http://www.paraview.org/files/dependencies/ftjam-2.5.2-win32.tar.bz2"
  URL_MD5 ee52f3faff6d31ffb89a2fedb3b0caf6)

superbuild_set_revision(freetype
  URL "https://download.savannah.gnu.org/releases/freetype/freetype-2.8.tar.gz"
  URL_MD5 c89c00767f939bff559d5dad326c1355)

superbuild_set_revision(fontconfig
  URL     "http://www.paraview.org/files/dependencies/fontconfig-2.12.6.tar.bz2"
  URL_MD5 733f5e2371ca77b69707bd7b30cc2163)

superbuild_set_revision(libxml2
  URL "ftp://xmlsoft.org/libxslt/libxml2-2.9.6.tar.gz"
  URL_MD5 dbae8327d8471941bf0472e273473e36)

if (WIN32)
  set(qt4_ver "4.8.4")
  set(qt4_md5 "89c5ecba180cae74c66260ac732dc5cb")
else ()
  set(qt4_ver "4.8.6")
  set(qt4_md5 "2edbe4d6c2eff33ef91732602f3518eb")
endif ()
superbuild_set_revision(qt4
  URL     "http://www.paraview.org/files/dependencies/qt-everywhere-opensource-src-${qt4_ver}.tar.gz"
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
  URL     "http://www.paraview.org/files/dependencies/qt-everywhere-opensource-src-${qt5_ver}.${qt5_ext}"
  URL_MD5 "${qt5_md5}")

if (WIN32 AND NOT superbuild_building_prebuilt_python)
  if (superbuild_is_64bit)
    superbuild_set_revision(numpy
      URL     "http://www.paraview.org/files/dependencies/numpy-1.8.1-win64-20160927.tar.gz"
      URL_MD5 c03c7f0d9e88b9d0d2eaedb4571dab90)
  else ()
    superbuild_set_revision(numpy
      URL     "http://www.paraview.org/files/dependencies/numpy-1.8.1-win32-20160927.tar.gz"
      URL_MD5 548f894f23dfd87de14191a8425eb6e0)
  endif ()
else ()
  superbuild_set_revision(numpy
    URL     "http://www.paraview.org/files/dependencies/numpy-1.8.1+cmake+static.tar.bz2"
    URL_MD5 1974dbb4bfa1509e492791a8cd225774)
  superbuild_set_revision(scipy
    URL     "http://www.paraview.org/files/dependencies/scipy-0.15.1.tar.gz"
    URL_MD5 be56cd8e60591d6332aac792a5880110)
endif ()

if (WIN32 AND NOT superbuild_building_prebuilt_python)
  if (superbuild_is_64bit)
    superbuild_set_revision(matplotlib
      URL     "http://www.paraview.org/files/dependencies/matplotlib-1.1.1-win64-20160927.tar.gz"
      URL_MD5 cf20ab4210fe1ebd541ab04221d93e46)
  else ()
    superbuild_set_revision(matplotlib
      URL     "http://www.paraview.org/files/dependencies/matplotlib-1.1.1-win32-20160927.tar.gz"
      URL_MD5 c14d6c4f43f2bba537c027035c8e195a)
  endif ()
else ()
  superbuild_set_revision(matplotlib
    URL     "http://www.paraview.org/files/dependencies/matplotlib-1.1.1_notests.tar.gz"
    URL_MD5 30ee59119599331bf1f3b6e838fee9a8)
endif ()

if (WIN32 AND NOT superbuild_building_prebuilt_python)
  if (superbuild_is_64bit)
    superbuild_set_revision(pywin32
      URL     "http://www.paraview.org/files/dependencies/pywin32-220-win64-20160927.tar.gz"
      URL_MD5 064c396b315d2c1a11096df9378a503a)
  else ()
    superbuild_set_revision(pywin32
      URL     "http://www.paraview.org/files/dependencies/pywin32-220-win32-20160927.tar.gz"
      URL_MD5 83ce04df1d0084b7adb1c94a8734423e)
  endif ()
else ()
  superbuild_set_revision(pywin32
    URL     "http://www.paraview.org/files/dependencies/pywin32-220.zip"
    URL_MD5 9c386839c1485b2047c03fab66e69b9e)
endif ()

superbuild_set_revision(mpi
  URL     "http://www.paraview.org/files/dependencies/mpich-3.2.tar.gz"
  URL_MD5 f414cfa77099cd1fa1a5ae4e22db508a)

superbuild_set_revision(lapack
  URL     "http://www.paraview.org/files/dependencies/lapack-3.4.2.tgz"
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
  URL     "http://www.paraview.org/files/dependencies/setuptools-23.0.0.tar.gz"
  URL_MD5 100a90664040f8ff232fbac02a4c5652)

############################
# Added for zCFD
############################
superbuild_set_revision(libunwind
    URL "http://download.savannah.nongnu.org/releases/libunwind/libunwind-1.2.tar.gz"
    URL_MD5 eefcb5d7f78fdc8f1ed172a26ea4202f
)

superbuild_set_revision(papi
    URL "http://icl.utk.edu/projects/papi/downloads/papi-5.5.1.tar.gz"
    URL_MD5 86a8a6f3d0f34cd83251da3514aae15d
)

superbuild_set_revision(extrae
    URL "https://ftp.tools.bsc.es/extrae/extrae-3.4.3-src.tar.bz2"
    URL_MD5 779a95aa9f498a658041f9c851ecb4f1
    #    URL "https://ftp.tools.bsc.es/extrae/extrae-3.5.0-src.tar.bz2"
    #    URL_MD5 832c1babb1e8f8661163120e60d918a0
)

superbuild_set_revision(libsodium
    URL "https://github.com/jedisct1/libsodium/releases/download/1.0.15/libsodium-1.0.15.tar.gz"
    URL_MD5 070373e73a0b10bd96f412e1732ebc42)

superbuild_set_revision(openssl
  URL "https://www.openssl.org/source/openssl-1.1.0e.tar.gz"
  URL_MD5 51c42d152122e474754aea96f66928c6)

superbuild_set_revision(silo
  URL "http://paraview.org/files/dependencies/silo-4.9.1-bsd.tar.gz"
  URL_MD5 465d2a0a8958b088cde83fb2a5a7eeef)

superbuild_set_revision(cgns
  URL "http://www.paraview.org/files/dependencies/cgnslib_3.1.3-4.tar.gz"
  URL_MD5 442bba32b576f3429cbd086af43fd4ae)

superbuild_set_revision(ccmio
  URL "http://packages.zenotech.com/libccmio-2.6.1.tar.gz"
  URL_MD5 fa363a5f9c297dd1ddfa67c86cbfe09a)

superbuild_set_revision(libxslt
  URL "ftp://xmlsoft.org/libxslt/libxslt-1.1.31.tar.gz"
  URL_MD5 14e9842a70fda476065f2eefcbc29af0
)