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
  URL     "https://www.paraview.org/files/dependencies/bzip2-1.0.8.tar.gz"
  URL_MD5 67e051268d0c475ea773822f7500d0e5)

superbuild_set_revision(zlib
  URL     "https://www.paraview.org/files/dependencies/zlib-1.2.11.tar.xz"
  URL_MD5 85adef240c5f370b308da8c938951a68)

superbuild_set_revision(ffmpeg
  URL     "https://www.paraview.org/files/dependencies/ffmpeg-2.3.3.tar.bz2"
  URL_MD5 72361d3b8717b6db3ad2b9da8df7af5e)

superbuild_set_revision(szip
  URL     "https://www.paraview.org/files/dependencies/szip-2.1.1.tar.gz"
  URL_MD5 dd579cf0f26d44afd10a0ad7291fc282)

superbuild_set_revision(hdf5
  URL     "https://www.paraview.org/files/dependencies/hdf5-1.12.0.tar.bz2"
  URL_MD5  1fa68c4b11b6ef7a9d72ffa55995f898)

superbuild_set_revision(boost
  URL     "https://www.paraview.org/files/dependencies/boost_1_59_0.tar.bz2"
  URL_MD5 6aa9a5c6a4ca1016edd0ed1178e3cb87)

superbuild_set_revision(png
  URL     "https://www.paraview.org/files/dependencies/libpng-1.6.37.tar.xz"
  URL_MD5 015e8e15db1eecde5f2eb9eb5b6e59e9)

if (WIN32 AND (NOT superbuild_building_prebuilt_python OR superbuild_use_prebuilt_python))
  if (superbuild_is_64bit)
    superbuild_set_revision(python2
      URL     "https://www.paraview.org/files/dependencies/python-2.7.15-win64-20180905.tar.gz"
      URL_MD5 6cfab07945bf75474d4ed2d2ea799c57)
  else ()
    message(FATAL_ERROR
      "Prebuilt Python binaries for Windows 32 bit are not provided.")
  endif ()
else()
  superbuild_set_revision(python2
    URL     "https://www.paraview.org/files/dependencies/Python-2.7.15.tar.xz"
    URL_MD5 a80ae3cc478460b922242f43a1b4094d)
endif()

if (WIN32)
  superbuild_set_revision(python3
    URL "https://www.paraview.org/files/dependencies/python-win64-3.8.6-no-ssl.tar.xz"
    URL_MD5 8cece55f80ef13ae8e839595e1c090d2)
else()
  superbuild_set_revision(python3
    URL     "https://www.paraview.org/files/dependencies/Python-3.8.6.tar.xz"
    URL_MD5 69e73c49eeb1a853cefd26d18c9d069d)
endif()

superbuild_set_revision(ftjam
  URL     "https://www.paraview.org/files/dependencies/ftjam-2.5.2-win32.tar.bz2"
  URL_MD5 ee52f3faff6d31ffb89a2fedb3b0caf6)

superbuild_set_revision(freetype
  URL     "https://www.paraview.org/files/dependencies/freetype-2.10.2.tar.xz"
  URL_MD5 7c0d5a39f232d7eb9f9d7da76bf08074)

superbuild_set_revision(gperf
  URL     "https://www.paraview.org/files/dependencies/gperf-3.1.tar.gz"
  URL_MD5 9e251c0a618ad0824b51117d5d9db87e)

superbuild_set_revision(fontconfig
  URL     "https://www.paraview.org/files/dependencies/fontconfig-2.13.1.tar.bz2"
  URL_MD5 36cdea1058ef13cbbfdabe6cb019dc1c)

superbuild_set_revision(libxml2
  URL     "https://www.paraview.org/files/dependencies/libxml2-2.9.10.tar.gz"
  URL_MD5 10942a1dc23137a8aa07f0639cbfece5)

superbuild_set_revision(nlohmannjson
  URL     "https://www.paraview.org/files/dependencies/nlohmannjson-v3.9.1.tar.gz"
  URL_MD5 e386222fb57dd2fcb8a7879fc016d037)

superbuild_set_selectable_source(qt5
  SELECT 5.8
    URL     "https://www.paraview.org/files/dependencies/qt-everywhere-opensource-src-5.8.0.tar.xz"
    URL_MD5 "66660cd3d9e1a6fed36e88adcb72e9fe"
  SELECT 5.9
    URL     "https://www.paraview.org/files/dependencies/qt-everywhere-opensource-src-5.9.2.tar.xz"
    URL_MD5 "738d1b98106e1bd39f00cc228beb522a"
  SELECT 5.10
    URL     "https://www.paraview.org/files/dependencies/qt-everywhere-src-5.10.1.tar.xz"
    URL_MD5 "7e167b9617e7bd64012daaacb85477af"
  SELECT 5.12 DEFAULT
    URL     "https://www.paraview.org/files/dependencies/qt-everywhere-src-5.12.9.tar.xz"
    URL_MD5 "fa2646280cf38180689c29c393cddd05")

if (WIN32 AND NOT superbuild_building_prebuilt_python AND NOT ENABLE_python3 AND NOT python3_enabled)
  if (superbuild_is_64bit)
    superbuild_set_revision(numpy
      URL     "https://www.paraview.org/files/dependencies/numpy-1.15.1-win64-20180906.tar.gz"
      URL_MD5 d75f1c5c111de3fed8556174fe353f0c)
  else ()
    message(FATAL_ERROR
      "Prebuilt Python binaries for Windows 32 bit are not provided.")
  endif ()
else ()
  superbuild_set_selectable_source(numpy
    SELECT python2
      URL     "https://www.paraview.org/files/dependencies/numpy-1.16.4.tar.gz"
      URL_MD5 6edf7334d04d8e8849ad058ccd3b3803
    SELECT python3 DEFAULT
      URL     "https://www.paraview.org/files/dependencies/numpy-1.19.2.tar.gz"
      URL_MD5 471156268abd8686e39e811003726ab1)
  superbuild_set_revision(scipy
    URL     "https://www.paraview.org/files/dependencies/scipy-1.5.2.tar.xz"
    URL_MD5 5bc188f21054a2ecff74fae40dd298da)
endif ()

if (ENABLE_python3 OR python3_enabled)
  superbuild_set_revision(matplotlib
    URL "https://www.paraview.org/files/dependencies/matplotlib-3.2.1.tar.gz"
    URL_MD5 9186b1e9f1fc7d555f2abf64b35dea5b)
else ()
  if (WIN32 AND NOT superbuild_building_prebuilt_python)
    if (superbuild_is_64bit)
      superbuild_set_revision(matplotlib
        URL     "https://www.paraview.org/files/dependencies/matplotlib-1.1.1-win64-20180905.tar.gz"
        URL_MD5 0c96b84e87b4db50cdc4d18869ae74ed)
    else ()
      message(FATAL_ERROR
        "Prebuilt Python binaries for Windows 32 bit are not provided.")
    endif ()
  else ()
    superbuild_set_revision(matplotlib
      URL     "https://www.paraview.org/files/dependencies/matplotlib-1.1.1_notests.tar.gz"
      URL_MD5 30ee59119599331bf1f3b6e838fee9a8)
  endif ()
endif ()

if (WIN32 AND NOT superbuild_building_prebuilt_python AND NOT ENABLE_python3 AND NOT python3_enabled)
  if (superbuild_is_64bit)
    superbuild_set_revision(pywin32
      URL     "https://www.paraview.org/files/dependencies/pywin32-220-win64-20180905.tar.gz"
      URL_MD5 08a6ab778e459e6752d54083c29dbb13)
  else ()
    message(FATAL_ERROR
      "Prebuilt Python binaries for Windows 32 bit are not provided.")
  endif ()
elseif (ENABLE_python3 OR python3_enabled)
  superbuild_set_revision(pywin32
    URL "https://www.paraview.org/files/dependencies/pywin32-228-cp38-cp38-win_amd64.tar.xz"
    URL_MD5 46fc0684aa4818e622929fc031be77ba)
else ()
  superbuild_set_revision(pywin32
    URL     "https://www.paraview.org/files/dependencies/pywin32-220.zip"
    URL_MD5 9c386839c1485b2047c03fab66e69b9e)
endif ()

superbuild_set_revision(mpi
  URL     "https://www.paraview.org/files/dependencies/mpich-3.3.tar.gz"
  URL_MD5 574af413dc0dc7fbb929a761822beb06)

superbuild_set_revision(lapack
  URL     "https://www.paraview.org/files/dependencies/lapack-3.9.0.tar.gz"
  URL_MD5 0b251e2a8d5f949f99b50dd5e2200ee2)

superbuild_set_revision(netcdf
  URL     "https://www.paraview.org/files/dependencies/netcdf-c-4.7.0.tar.gz"
  URL_MD5 37134a12a49e80c45fb58777aa3e9e3b)

# Using Intel Threading Building Blocks 2018 Update 2
set(tbb_ver "2019_20190410oss")
if (WIN32)
  set(tbb_file "tbb${tbb_ver}_win.zip")
  set(tbb_md5 63fc9feb34ec973b0c8ae439afb30f5e)
elseif (APPLE)
  set(tbb_file "tbb${tbb_ver}_mac.tgz")
  set(tbb_md5 d1420b7b6e1d2b9c7e737123bd7e8315)
else ()
  set(tbb_file "tbb${tbb_ver}_lin.tgz")
  set(tbb_md5 cb95ed04d2522e54d2327afd1c56938f)
endif ()

superbuild_set_revision(tbb
  URL     "https://www.paraview.org/files/dependencies/${tbb_file}"
  URL_MD5 "${tbb_md5}")

superbuild_set_revision(pytz
  URL     "https://www.paraview.org/files/dependencies/pytz-2020.1.tar.gz"
  URL_MD5 0349106ac02f2bfe565dd6d5594e3a15)

superbuild_set_revision(pythondateutil
  URL     "https://www.paraview.org/files/dependencies/python-dateutil-2.6.0.tar.gz"
  URL_MD5 6e38f91e8c94c15a79ce22768dfeca87)

superbuild_set_revision(pythonpyparsing
  URL     "https://www.paraview.org/files/dependencies/pyparsing-2.2.0.tar.gz"
  URL_MD5 0214e42d63af850256962b6744c948d9)

superbuild_set_revision(pythoncycler
  URL     "https://www.paraview.org/files/dependencies/cycler-0.10.0.tar.gz"
  URL_MD5 4cb42917ac5007d1cdff6cccfe2d016b)

superbuild_set_revision(pythoncython
  URL     "https://www.paraview.org/files/dependencies/Cython-0.29.21.tar.gz"
  URL_MD5 12c5e45af71dcc6dff28cdcbcbef6f39)

superbuild_set_revision(pythonsetuptools
  URL     "https://www.paraview.org/files/dependencies/setuptools-46.1.3.zip"
  URL_MD5 562328cde5a33564c0ebf16699a27b65)

superbuild_set_revision(pythonautobahn
  URL     "https://www.paraview.org/files/dependencies/autobahn-17.10.1.tar.gz"
  URL_MD5 f8c8d74bf73644719b751e6fb11dc4a3)

superbuild_set_revision(pythonconstantly
  URL     "https://www.paraview.org/files/dependencies/constantly-15.1.0.tar.gz"
  URL_MD5 f0762f083d83039758e53f8cf0086eef)

superbuild_set_revision(pythonhyperlink
  URL     "https://www.paraview.org/files/dependencies/hyperlink-17.3.1.tar.gz"
  URL_MD5 eaccb9845b559817e838846669cbc68a)

superbuild_set_revision(pythonincremental
  URL     "https://www.paraview.org/files/dependencies/incremental-17.5.0.tar.gz"
  URL_MD5 602746e0d438e075a5a9e0678140bba2)

superbuild_set_revision(pythontwisted
  URL     "https://www.paraview.org/files/dependencies/twisted-19.7.0.tar.gz"
  URL_MD5 f307687d4315db3534d02aba97ba5ed0)

superbuild_set_revision(pythontxaio
  URL     "https://www.paraview.org/files/dependencies/txaio-2.8.2.tar.gz"
  URL_MD5 a20e3431c95896a49fa3ffa84f77cde1)

superbuild_set_revision(pythonwslink
  URL     "https://www.paraview.org/files/dependencies/wslink-0.1.11.tar.gz"
  URL_MD5 35e6285c2a74304da0557f1402c400e5)

superbuild_set_revision(pythonzope
  URL     "https://www.paraview.org/files/dependencies/Zope-4.0b3.tar.gz"
  URL_MD5 9a63e8c8b614dc6d6944fcbd9c105f45)

superbuild_set_revision(pythonzopeinterface
  URL     "https://www.paraview.org/files/dependencies/zope.interface-5.1.0.tar.gz"
  URL_MD5 53bccb21aab8894a68f40ee2f202465d)

superbuild_set_revision(pythonsix
  URL     "https://www.paraview.org/files/dependencies/six-1.11.0.tar.gz"
  URL_MD5 d12789f9baf7e9fb2524c0c64f1773f8)

superbuild_set_revision(pythonpygments
  URL     "https://www.paraview.org/files/dependencies/Pygments-2.2.0.tar.gz"
  URL_MD5 13037baca42f16917cbd5ad2fab50844)

superbuild_set_revision(pythonmako
  URL     "https://www.paraview.org/files/dependencies/Mako-1.0.7.tar.gz"
  URL_MD5 5836cc997b1b773ef389bf6629c30e65)

superbuild_set_revision(pythonkiwisolver
  URL     "https://www.paraview.org/files/dependencies/kiwisolver-1.1.0.tar.gz"
  URL_MD5 fc8a614367f7ba0d34a02fd08c535afc)

superbuild_set_revision(pythonattrs
  URL     "https://www.paraview.org/files/dependencies/attrs-20.2.0.tar.gz"
  URL_MD5 7be95e1b35e9385d71a0017a48217efc)

superbuild_set_revision(pythonpandas
  URL     "https://www.paraview.org/files/dependencies/pandas-1.1.3.tar.gz"
  URL_MD5 f10372d83a1c55cae217e8c05bf9bc5d)

superbuild_set_revision(ffi
  URL     "https://www.paraview.org/files/dependencies/libffi-3.3.tar.gz"
  URL_MD5 6313289e32f1d38a9df4770b014a2ca7)

superbuild_set_revision(utillinux
  URL     "https://www.paraview.org/files/dependencies/util-linux-2.34.tar.xz"
  URL_MD5 a78cbeaed9c39094b96a48ba8f891d50)

superbuild_set_revision(pkgconf
  URL     "https://www.paraview.org/files/dependencies/pkgconf-1.6.3.tar.xz"
  URL_MD5 f93fb1be95a5cb62e43c219c82b5791a)

superbuild_set_revision(pybind11
  URL     "https://www.paraview.org/files/dependencies/pybind11-2.5.0.tar.gz"
  URL_MD5 1ad2c611378fb440e8550a7eb6b31b89)

superbuild_set_revision(sqlite
  URL     "https://www.paraview.org/files/dependencies/sqlite-autoconf-3330000.tar.gz"
  URL_MD5 842a8a100d7b01b09e543deb2b7951dd)
