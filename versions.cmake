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
  URL     "https://www.paraview.org/files/dependencies/ffmpeg-4.4.tar.xz"
  URL_MD5 7b9d5b652d20e8c5405304ad72636d4a)

superbuild_set_revision(szip
  URL     "https://www.paraview.org/files/dependencies/szip-2.1.1.tar.gz"
  URL_MD5 dd579cf0f26d44afd10a0ad7291fc282)

superbuild_set_revision(hdf5
  URL     "https://www.paraview.org/files/dependencies/hdf5-1.12.1.tar.bz2"
  URL_MD5  442469fbf43626006346e679c22cf10a)

superbuild_set_revision(boost
  URL     "https://www.paraview.org/files/dependencies/boost_1_76_0.tar.bz2"
  URL_MD5 )

superbuild_set_revision(png
  URL     "https://www.paraview.org/files/dependencies/libpng-1.6.37.tar.xz"
  URL_MD5 015e8e15db1eecde5f2eb9eb5b6e59e9)

if (WIN32 AND (NOT superbuild_building_prebuilt_python OR superbuild_use_prebuilt_python))
  superbuild_set_revision(python2
    URL     "https://www.paraview.org/files/dependencies/python-2.7.15-win64-20180905.tar.gz"
    URL_MD5 6cfab07945bf75474d4ed2d2ea799c57)
else()
  superbuild_set_revision(python2
    URL     "https://www.paraview.org/files/dependencies/Python-2.7.15.tar.xz"
    URL_MD5 a80ae3cc478460b922242f43a1b4094d)
endif()

if (WIN32)
  superbuild_set_revision(python3
    URL     "https://www.paraview.org/files/dependencies/python-3.9.5-windows-x86_64.zip"
    URL_MD5 c41556099961c9e0d4d6afd419045bac)
else()
  superbuild_set_revision(python3
    URL     "https://www.paraview.org/files/dependencies/Python-3.9.5.tar.xz"
    URL_MD5 71f7ada6bec9cdbf4538adc326120cfd)
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
  URL     "https://www.paraview.org/files/dependencies/libxml2-2.9.12.tar.gz"
  URL_MD5 f433a39be087a9f0b197eb2307ad9f75)

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
  superbuild_set_revision(numpy
    URL     "https://www.paraview.org/files/dependencies/numpy-1.15.1-win64-20180906.tar.gz"
    URL_MD5 d75f1c5c111de3fed8556174fe353f0c)
else ()
  superbuild_set_selectable_source(numpy
    SELECT python2
      URL     "https://www.paraview.org/files/dependencies/numpy-1.16.4.tar.gz"
      URL_MD5 6edf7334d04d8e8849ad058ccd3b3803
    SELECT python3 DEFAULT
      URL     "https://www.paraview.org/files/dependencies/numpy-1.21.1.zip"
      URL_MD5 1d016e05851a4ba85307f3246eb569aa)
  superbuild_set_revision(scipy
    URL     "https://www.paraview.org/files/dependencies/scipy-1.7.1.tar.gz"
    URL_MD5 8ac74369cdcabc097f602682c951197c)
endif ()

if (ENABLE_python3 OR python3_enabled)
  superbuild_set_revision(matplotlib
    URL "https://www.paraview.org/files/dependencies/matplotlib-3.2.1.tar.gz"
    URL_MD5 9186b1e9f1fc7d555f2abf64b35dea5b)
else ()
  if (WIN32 AND NOT superbuild_building_prebuilt_python)
    superbuild_set_revision(matplotlib
      URL     "https://www.paraview.org/files/dependencies/matplotlib-1.1.1-win64-20180905.tar.gz"
      URL_MD5 0c96b84e87b4db50cdc4d18869ae74ed)
  else ()
    superbuild_set_revision(matplotlib
      URL     "https://www.paraview.org/files/dependencies/matplotlib-1.1.1_notests.tar.gz"
      URL_MD5 30ee59119599331bf1f3b6e838fee9a8)
  endif ()
endif ()

if (WIN32 AND NOT superbuild_building_prebuilt_python AND NOT ENABLE_python3 AND NOT python3_enabled)
  superbuild_set_revision(pywin32
    URL     "https://www.paraview.org/files/dependencies/pywin32-220-win64-20180905.tar.gz"
    URL_MD5 08a6ab778e459e6752d54083c29dbb13)
elseif (ENABLE_python3 OR python3_enabled)
  superbuild_set_revision(pywin32
    URL "https://www.paraview.org/files/dependencies/pywin32-301-cp39-cp39-win_amd64.whl"
    URL_MD5 3fe9793d6bee6e9b6515bc744f7585df)
else ()
  superbuild_set_revision(pywin32
    URL     "https://www.paraview.org/files/dependencies/pywin32-220.zip"
    URL_MD5 9c386839c1485b2047c03fab66e69b9e)
endif ()

superbuild_set_revision(mpi
  URL     "https://www.paraview.org/files/dependencies/mpich-3.4.2.tar.gz"
  URL_MD5 6ee1cfff98728e5160c6e78bdb1986ca)

superbuild_set_revision(lapack
  URL     "https://www.paraview.org/files/dependencies/lapack-3.10.0.tar.gz"
  URL_MD5 d70fc27a8bdebe00481c97c728184f09)

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

superbuild_set_revision(pythonbeniget
  URL     "https://www.paraview.org/files/dependencies/beniget-0.4.1.tar.gz"
  URL_MD5 a2bbe7f17f10f9c127d8ef00692ddc55)

superbuild_set_revision(pythongast
  URL     "https://www.paraview.org/files/dependencies/gast-0.5.2.tar.gz"
  URL_MD5 eb2489df0c85ae198e4740e5711c7299)

superbuild_set_revision(pythonply
  URL     "https://www.paraview.org/files/dependencies/ply-3.11.tar.gz"
  URL_MD5 6465f602e656455affcd7c5734c638f8)

superbuild_set_revision(pythonpythran
  URL     "https://www.paraview.org/files/dependencies/pythran-0.9.12.post1.tar.gz"
  URL_MD5 b84d70ed33554dcef423673216bc3826)

superbuild_set_revision(pythoncycler
  URL     "https://www.paraview.org/files/dependencies/cycler-0.10.0.tar.gz"
  URL_MD5 4cb42917ac5007d1cdff6cccfe2d016b)

superbuild_set_revision(pythoncython
  URL     "https://www.paraview.org/files/dependencies/Cython-0.29.21.tar.gz"
  URL_MD5 12c5e45af71dcc6dff28cdcbcbef6f39)

superbuild_set_revision(pythonsetuptools
  URL     "https://www.paraview.org/files/dependencies/setuptools-46.1.3.zip"
  URL_MD5 562328cde5a33564c0ebf16699a27b65)

superbuild_set_revision(pythonwheel
  # PyPI source tarball with 'unicode.dist' test excised from it (CMake has
  # issues extracting non-UTF-8 names in tarballs).
  URL     "https://www.paraview.org/files/dependencies/wheel-0.36.2-nounicodedist.tar.gz"
  URL_MD5 20cbaac2ac5493ee7395145a2d708640)

superbuild_set_revision(pythonpycparser
  URL     "https://www.paraview.org/files/dependencies/pycparser-2.20.tar.gz"
  URL_MD5 b8f88de737db8c346ee8d31c07c7a25a)

superbuild_set_revision(pythontoml
  URL     "https://www.paraview.org/files/dependencies/toml-0.10.2.tar.gz"
  URL_MD5 59bce5d8d67e858735ec3f399ec90253)

superbuild_set_revision(pythonsetuptoolsscm
  URL     "https://www.paraview.org/files/dependencies/setuptools_scm-5.0.1.tar.gz"
  URL_MD5 c11bf23d80224691a46ee5deb84c42db)

superbuild_set_revision(pythonsetuptoolsrust
  URL     "https://www.paraview.org/files/dependencies/setuptools-rust-0.11.6.tar.gz"
  URL_MD5 319d2968f076f37279c866e51bcccbcc)

superbuild_set_revision(pythonautobahn
  URL     "https://www.paraview.org/files/dependencies/autobahn-21.1.1.tar.gz"
  URL_MD5 f0c5bebdc24eab1e8ee5811ae73075b8)

superbuild_set_revision(pythoncffi
  URL     "https://www.paraview.org/files/dependencies/cffi-1.14.5.tar.gz"
  URL_MD5 272cb183bf0365530e3c0d8f446cd89d)

superbuild_set_revision(pythonsemanticversion
  URL     "https://www.paraview.org/files/dependencies/semantic_version-2.8.5.tar.gz"
  URL_MD5 76d7364def7ee487b6153d40b13de904)

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
  URL     "https://www.paraview.org/files/dependencies/Twisted-21.2.0.tar.gz"
  URL_MD5 0733e15bcc48bb2c8b4d593bb0839043)

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
  URL     "https://www.paraview.org/files/dependencies/sqlite-autoconf-3350200.tar.gz"
  URL_MD5 454e0899d99a7b28825db3d807526774)

set(pythoncryptography_version "3.4.7")
if (CMAKE_SYSTEM_NAME STREQUAL "Windows")
  if (CMAKE_HOST_SYSTEM_PROCESSOR MATCHES "64")
    set(pythoncryptography_file
      "cryptography-${pythoncryptography_version}-cp36-abi3-win_amd64.whl")
    set(pythoncryptography_md5
      "4ac946949ecb278b028c2fcf5d1cbc2b")
  endif ()
elseif (CMAKE_SYSTEM_NAME STREQUAL "Darwin")
  if (CMAKE_HOST_SYSTEM_PROCESSOR STREQUAL "x86_64")
    set(pythoncryptography_file
      "cryptography-${pythoncryptography_version}-cp36-abi3-macosx_10_10_x86_64.whl")
    set(pythoncryptography_md5
      "f5e574ea0e46b25157a29d09fc6e76b3")
  elseif (CMAKE_HOST_SYSTEM_PROCESSOR STREQUAL "arm64")
    set(pythoncryptography_file
      "cryptography-${pythoncryptography_version}-cp36-abi3-macosx_11_0_arm64.whl")
    set(pythoncryptography_md5
      "cd55873ce4a9aa985a0573efdc4244e1")
  endif ()
elseif (CMAKE_SYSTEM_NAME STREQUAL "Linux")
  if (CMAKE_HOST_SYSTEM_PROCESSOR STREQUAL "x86_64")
    set(pythoncryptography_file
      "cryptography-${pythoncryptography_version}-cp36-abi3-manylinux2010_x86_64.whl")
    set(pythoncryptography_md5
      "37e6016ff0dd06e168d908ee800a071b")
  endif ()
endif ()
if (NOT pythoncryptography_file)
  message(WARNING
    "The Python cryptography package is being built from source due to the "
    "lack of a suitable wheel file. This needs a Rust compiler. Please see "
    "https://rustup.rs/ for instructions on obtaining a toolchain.")
  set(pythoncryptography_file
    "cryptography-${pythoncryptography_version}.tar.gz")
  set(pythoncryptography_md5
    "f24fb11c6d5beb18cbfe216b9e58c27e")
  set_property(GLOBAL
    PROPERTY
      pythoncryptography_source 1)
endif ()
superbuild_set_revision(pythoncryptography
  URL     "https://www.paraview.org/files/dependencies/${pythoncryptography_file}"
  URL_MD5 "${pythoncryptography_md5}")

set(openssl_version 1.1.1k)
if (WIN32)
  # Obtained from https://kb.firedaemon.com/support/solutions/articles/4000121705
  superbuild_set_revision(openssl
    URL     "https://www.paraview.org/files/dependencies/openssl-${openssl_version}.zip"
    URL_MD5 0c08d59e229e2ac3cb941158b4d35915)
else ()
  superbuild_set_revision(openssl
    URL     "https://www.paraview.org/files/dependencies/openssl-${openssl_version}.tar.gz"
    URL_MD5 c4e7d95f782b08116afa27b30393dd27)
endif ()
