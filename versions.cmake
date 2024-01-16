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
  # https://sourceware.org/pub/bzip2/
  URL     "https://www.paraview.org/files/dependencies/bzip2-1.0.8.tar.gz"
  URL_MD5 67e051268d0c475ea773822f7500d0e5)

superbuild_set_revision(cgns
  # https://github.com/CGNS/CGNS/releases
  URL     "https://www.paraview.org/files/dependencies/cgns-4.4.0.tar.gz"
  URL_MD5 7d82f6834c11ee873232cf131fadfba6)

superbuild_set_revision(seacas
  # https://github.com/sandialabs/seacas/releases
  URL     "https://www.paraview.org/files/dependencies/seacas-2023-05-30.tar.gz"
  URL_MD5 03f0eca3e201cd2fd352b80c10536669)

superbuild_set_revision(zlib
  # https://github.com/madler/zlib/releases
  URL     "https://www.paraview.org/files/dependencies/zlib-1.3.tar.xz"
  URL_MD5 b49e70aacafacfceb1107943497f5545)

superbuild_set_revision(xz
  # https://tukaani.org/xz/
  URL     "https://www.paraview.org/files/dependencies/xz-5.4.4.tar.xz"
  URL_MD5 d83d6f64a64f88759e312b8a38c3add6)

superbuild_set_revision(ffmpeg
  # https://ffmpeg.org/download.html
  URL     "https://www.paraview.org/files/dependencies/ffmpeg-6.0.tar.xz"
  URL_MD5 47b6c5d930937413c3e308e2fdb3dfb5)

superbuild_set_revision(szip
  # https://support.hdfgroup.org/doc_resource/SZIP/ (Check "SZIP Source Code" link)
  URL     "https://www.paraview.org/files/dependencies/szip-2.1.1.tar.gz"
  URL_MD5 dd579cf0f26d44afd10a0ad7291fc282)

superbuild_set_revision(hdf5
  # https://github.com/HDFGroup/hdf5/releases
  URL     "https://www.paraview.org/files/dependencies/hdf5-1_14_2.tar.gz"
  URL_MD5  dc95b307eb8a46335ec59e7ffa1948a4)

superbuild_set_revision(boost
  # https://www.boost.org/users/download/
  URL     "https://www.paraview.org/files/dependencies/boost_1_83_0.tar.bz2"
  URL_MD5 406f0b870182b4eb17a23a9d8fce967d)

superbuild_set_revision(png
  # http://www.libpng.org/pub/png/libpng.html
  URL     "https://www.paraview.org/files/dependencies/libpng-1.6.40.tar.xz"
  URL_MD5 6c7fe9dbb80c89c3579bedad9722e559)

if (WIN32)
  superbuild_set_selectable_source(python3
    # See https://www.paraview.org/files/dependencies/python-for-wheels/
    # To make a new one, see `vtk/vtk@.gitlab/ci/wheels/`
    SELECT 3.10 DEFAULT
      URL     "https://www.paraview.org/files/dependencies/python-for-wheels/python-3.10.11-windows-x86_64.zip"
      URL_MD5 e963090c45b8e696b367de23ac8afe39
    SELECT 3.9
      URL     "https://www.paraview.org/files/dependencies/python-for-wheels/python-3.9.13-windows-x86_64.zip"
      URL_MD5 fe29035c955c49ace9e2844a505bbc09)
else()
  superbuild_set_selectable_source(python3
    # https://www.python.org/downloads/source/
    SELECT 3.10 DEFAULT
      URL     "https://www.paraview.org/files/dependencies/Python-3.10.13.tar.xz"
      URL_MD5 8847dc6458d1431d0ae0f55942deeb89
    SELECT 3.9
      URL     "https://www.paraview.org/files/dependencies/Python-3.9.13.tar.xz"
      URL_MD5 5e2411217b0060828d5f923eb422a3b8)
endif()

superbuild_set_revision(freetype
  # https://download.savannah.gnu.org/releases/freetype/
  URL     "https://www.paraview.org/files/dependencies/freetype-2.13.1.tar.xz"
  URL_MD5 e4c3f0d8453a2a7993ae784912d6f19a)

superbuild_set_revision(gperf
  # https://ftp.gnu.org/pub/gnu/gperf/
  URL     "https://www.paraview.org/files/dependencies/gperf-3.1.tar.gz"
  URL_MD5 9e251c0a618ad0824b51117d5d9db87e)

superbuild_set_revision(fontconfig
  # https://www.freedesktop.org/software/fontconfig/release/
  URL     "https://www.paraview.org/files/dependencies/fontconfig-2.14.2.tar.xz"
  URL_MD5 95261910ea727b5dd116b06fbfd84b1f)

superbuild_set_revision(libxml2
  # https://gitlab.gnome.org/GNOME/libxml2/-/releases
  # Grab the "Official distribution tarball"
  URL     "https://www.paraview.org/files/dependencies/libxml2-2.11.5.tar.xz"
  URL_MD5 b2e7332289f5784087448a0717f45ac3)

superbuild_set_revision(nlohmannjson
  # https://github.com/nlohmann/json/releases
  # Be sure to grab the full source code, not one of the subdirectory archives.
  URL     "https://www.paraview.org/files/dependencies/nlohmannjson-3.11.2.tar.gz"
  URL_MD5 e8d56bc54621037842ee9f0aeae27746)

# https://download.qt.io/official_releases/qt/
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
  SELECT 5.12
    URL     "https://www.paraview.org/files/dependencies/qt-everywhere-src-5.12.9.tar.xz"
    URL_MD5 "fa2646280cf38180689c29c393cddd05"
  SELECT 5.15 DEFAULT
    URL     "https://www.paraview.org/files/dependencies/qt-everywhere-opensource-src-5.15.10.tar.xz"
    URL_MD5 "fb41d86bea6bc4886030a5092c910b09")

superbuild_set_selectable_source(numpy
  # https://pypi.org/project/numpy/#history
  # When updating to a version that drops support for a Python version, also
  # update `projects/numpy.cmake`'s valid version detection.
  SELECT 1.25.2 DEFAULT # Requires Python 3.9+
    URL     "https://www.paraview.org/files/dependencies/numpy-1.25.2.tar.gz"
    URL_MD5 cee1996a80032d47bdf1d9d17249c34e
  SELECT 1.24.4 # Needed for Python 3.8
    URL     "https://www.paraview.org/files/dependencies/numpy-1.24.4.tar.gz"
    URL_MD5 3f3995540a17854a29dc79f8eeecd832
  SELECT 1.21.6 # Needed for Python 3.7
    URL     "https://www.paraview.org/files/dependencies/numpy-1.21.6.zip"
    URL_MD5 04aea95dcb1d256d13a45df42173aa1e
  SELECT 1.19.5 # Needed for Python 3.6
    URL     "https://www.paraview.org/files/dependencies/numpy-1.19.5.zip"
    URL_MD5 f6a1b48717c552bbc18f1adc3cc1fe0e)

superbuild_set_revision(pythonpyprojectmetadata
  # https://pypi.org/project/pyproject-metadata/#history
  URL     "https://www.paraview.org/files/dependencies/pyproject-metadata-0.7.1.tar.gz"
  URL_MD5 ca5e9527cff96153a976e14530b53746)

superbuild_set_revision(pythonflitcore
  # https://pypi.org/project/flit-core/#history
  URL     "https://www.paraview.org/files/dependencies/flit_core-3.9.0.tar.gz"
  URL_MD5 3bc52f1952b9a78361114147da63c35b)

superbuild_set_revision(pythonpackaging
  # https://pypi.org/project/packaging/#history
  URL     "https://www.paraview.org/files/dependencies/packaging-23.1.tar.gz"
  URL_MD5 f7d5c39c6f92cc2dfa1293ba8f6c097c)

superbuild_set_revision(pythontomli
  # https://pypi.org/project/tomli/#history
  URL     "https://www.paraview.org/files/dependencies/tomli-2.0.1.tar.gz"
  URL_MD5 d4341621d423a7ca6822e23d6d52bb9a)

superbuild_set_revision(pythonmesonpython
  # https://pypi.org/project/meson-python/#history
  URL     "https://www.paraview.org/files/dependencies/meson_python-0.13.2.tar.gz"
  URL_MD5 0db4483e30df43dbd465254be9c7db8a)

# https://pypi.org/project/scipy/#history
set(scipy_version "1.11.2")
if (WIN32)
  superbuild_set_selectable_source(scipy
    SELECTS_WITH python3
    SELECT 3.10
      URL     "https://www.paraview.org/files/dependencies/scipy-${scipy_version}-cp310-cp310-win_amd64.whl"
      URL_MD5 85c785288036b94826c2c564116b5e6b
    SELECT 3.9
      URL     "https://www.paraview.org/files/dependencies/scipy-${scipy_version}-cp39-cp39-win_amd64.whl"
      URL_MD5 2e2b1fcf6ea9c311576700daf18ccc19)
else ()
  superbuild_set_revision(scipy
    URL     "https://www.paraview.org/files/dependencies/scipy-${scipy_version}.tar.gz"
    URL_MD5 27baf613b6cf3f9600a05161f132151c)
endif ()

superbuild_set_revision(pythonmpmath
  # https://pypi.org/project/mpmath/#history
  URL     "https://www.paraview.org/files/dependencies/mpmath-1.3.0.tar.gz"
  URL_MD5 d5d17bbefea73eeb959967351d905306)

superbuild_set_selectable_source(sympy
  # https://pypi.org/project/sympy/#history
  # When updating to a version that drops support for a Python version, also
  # update `projects/sympy.cmake`'s valid version detection.
  SELECT 1.12 DEFAULT
    URL     "https://www.paraview.org/files/dependencies/sympy-1.12.tar.gz"
    URL_MD5 3e0033109352d7303ea97b9216e16645
  SELECT 1.10.1 # Needed for Python 3.7
    URL     "https://www.paraview.org/files/dependencies/sympy-1.10.1.tar.gz"
    URL_MD5 8c7a956d74a47dc439c2935fec64ac46
  SELECT 1.9 # Needed for Python 3.6
    URL     "https://www.paraview.org/files/dependencies/sympy-1.9.tar.gz"
    URL_MD5 217f8179c3f1f3c888feb9b0fde0994e)

superbuild_set_revision(qhull
  # http://www.qhull.org/download/ ("Download: … for Unix")
  URL     "https://www.paraview.org/files/dependencies/qhull-2020-src-8.0.2.tgz"
  URL_MD5 295f7332269a38279478f555cc185296)

superbuild_set_revision(libjpegturbo
  URL     "https://www.paraview.org/files/dependencies/libjpeg-turbo-3.0.0.tar.gz"
  URL_MD5 c84d907ace44d351fcce643c2b9d9492)

superbuild_set_revision(pythonpillow
  # https://pypi.org/project/pillow/#history
  URL     "https://www.paraview.org/files/dependencies/Pillow-10.0.0.tar.gz"
  URL_MD5 2a8f327ba2250aad26ed101337c8fa56)

superbuild_set_selectable_source(pythoncontourpy
  # https://pypi.org/project/contourpy/#history
  # When updating to a version that drops support for a Python version, also
  # update `projects/pythoncontourpy.cmake`'s valid version detection.
  SELECT 1.1.0 DEFAULT
    URL "https://www.paraview.org/files/dependencies/contourpy-1.1.0.tar.gz"
    URL_MD5 cae5b781ade023c01bc1a8a53312f2ac
  SELECT 1.0.6 # Needed for Python 3.7
    URL "https://www.paraview.org/files/dependencies/contourpy-1.0.6.tar.gz"
    URL_MD5 0ed85863802b1323708b400ae7e7bbd7)

superbuild_set_revision(pythonfonttools
  # https://pypi.org/project/fonttools/#history
  URL "https://www.paraview.org/files/dependencies/fonttools-4.42.1.tar.gz"
  URL_MD5 039956b85e9b84ba53373b0df644f5ad)

superbuild_set_revision(matplotlib
  # https://pypi.org/project/matplotlib/#history
  # NOTE: when updating, update pyparsing as well
  URL "https://www.paraview.org/files/dependencies/matplotlib-3.7.2.tar.gz"
  URL_MD5 64c7053050be5f92eab9131f1d85b71d)

superbuild_set_selectable_source(pywin32
  # https://pypi.org/project/pywin32/#history
  SELECTS_WITH python3
  SELECT 3.10
    URL "https://www.paraview.org/files/dependencies/pywin32-306-cp310-cp310-win_amd64.whl"
    URL_MD5 6fffe656f01d4a3377c40d98087de2b2
  SELECT 3.9
    URL "https://www.paraview.org/files/dependencies/pywin32-306-cp39-cp39-win_amd64.whl"
    URL_MD5 8825c29dd5dc6e8d906d82c666a7081f)

superbuild_set_revision(mpi
  # https://github.com/pmodels/mpich/releases
  URL     "https://www.paraview.org/files/dependencies/mpich-4.1.2.tar.gz"
  URL_MD5 66185dc9d911ab2b27cb42bec8e8e1a7)

superbuild_set_revision(lapack
  # https://github.com/Reference-LAPACK/lapack/releases
  URL     "https://www.paraview.org/files/dependencies/lapack-3.11.0.tar.gz"
  URL_MD5 595b064fd448b161cd711fe346f498a7)

superbuild_set_revision(netcdf
  # https://github.com/Unidata/netcdf-c/releases
  URL     "https://www.paraview.org/files/dependencies/netcdf-c-4.9.2.tar.gz"
  URL_MD5 84acd096ab4f3300c20db862eecdf7c7)

superbuild_set_revision(pythoncftime
  # https://pypi.org/project/cftime/#history
  URL     "https://www.paraview.org/files/dependencies/cftime-1.6.3.tar.gz"
  URL_MD5 74e916dcdfe36bbb07c238145de630cd)

superbuild_set_revision(pythonnetcdf4
  # https://github.com/Unidata/netcdf4-python/releases
  URL     "https://www.paraview.org/files/dependencies/netcdf4-python-1.6.5.tar.gz"
  URL_MD5 c3ebdf74ae184f2bd9ecbbc3f16801fe)

superbuild_set_revision(tbb
  # https://github.com/oneapi-src/oneTBB/releases
  URL     "https://www.paraview.org/files/dependencies/tbb-2021.10.0.tar.gz"
  URL_MD5 2caf55b3d35b53edccb33ecaf0f23402)

superbuild_set_revision(pytz
  # https://pypi.org/project/pytz/#history
  URL     "https://www.paraview.org/files/dependencies/pytz-2023.3.tar.gz"
  URL_MD5 fe54c8f8a1544b4e78b523b264ab071b)

superbuild_set_revision(pythondateutil
  # https://pypi.org/project/python-dateutil/#history
  URL     "https://www.paraview.org/files/dependencies/python-dateutil-2.8.2.tar.gz"
  URL_MD5 5970010bb72452344df3d76a10281b65)

superbuild_set_revision(pythonpyparsing
  # https://pypi.org/project/pyparsing/#history
  # 3.1.0+ breaks matplotlib: https://github.com/matplotlib/matplotlib/issues/26152
  # matplotlib 3.7.3+ fixes it: https://github.com/matplotlib/matplotlib/issues/26152#issuecomment-1691984837
  #URL     "https://www.paraview.org/files/dependencies/pyparsing-3.1.1.tar.gz"
  #URL_MD5 bb8c8c6b8015ca5887ae2c37917ee82e)
  URL     "https://www.paraview.org/files/dependencies/pyparsing-3.0.9.tar.gz"
  URL_MD5 fadc2f3bf5872bf6310576a86c3566e0)

superbuild_set_revision(pythonbeniget
  # https://pypi.org/project/beniget/#history
  URL     "https://www.paraview.org/files/dependencies/beniget-0.4.1.tar.gz"
  URL_MD5 a2bbe7f17f10f9c127d8ef00692ddc55)

superbuild_set_revision(pythongast
  # https://pypi.org/project/gast/#history
  URL     "https://www.paraview.org/files/dependencies/gast-0.5.4.tar.gz"
  URL_MD5 907c689e3fdbc7a48cc010e665195baa)

superbuild_set_revision(pythonply
  # https://pypi.org/project/ply/#history
  URL     "https://www.paraview.org/files/dependencies/ply-3.11.tar.gz"
  URL_MD5 6465f602e656455affcd7c5734c638f8)

superbuild_set_revision(pythonpythran
  # https://pypi.org/project/pythran/#history
  URL     "https://www.paraview.org/files/dependencies/pythran-0.13.1.tar.gz"
  URL_MD5 3090288af50566af75cb058d1878aaad)

superbuild_set_revision(pythoncycler
  # https://pypi.org/project/cycler/#history
  URL     "https://www.paraview.org/files/dependencies/cycler-0.11.0.tar.gz"
  URL_MD5 4d0c25f418956e91c47163179682e0ef)

superbuild_set_revision(pythoncython
  # https://pypi.org/project/Cython/#history
  URL     "https://www.paraview.org/files/dependencies/Cython-3.0.0.tar.gz"
  URL_MD5 63c5672e1f58dcee6854aef8b33a922e)

superbuild_set_selectable_source(pythonsetuptools
  # https://pypi.org/project/setuptools/#history
  # When updating to a version that drops support for a Python version, also
  # update `projects/pythonsetuptools.cmake`'s valid version detection.
  SELECT 68.1.2 DEFAULT
    URL     "https://www.paraview.org/files/dependencies/setuptools-68.1.2.tar.gz"
    URL_MD5 222b8c1a7432457d8485f947a0e0fde6
  SELECT 67.8.0 # Needed for Python 3.7
    URL     "https://www.paraview.org/files/dependencies/setuptools-67.8.0.tar.gz"
    URL_MD5 628ab1ae7d14185e5e536740ea31b5ce
  SELECT 58.5.3 # Needed for Python 3.6
    URL     "https://www.paraview.org/files/dependencies/setuptools-58.5.3.tar.gz"
    URL_MD5 04402d15308fb70de2de4a1c537ade1f)

superbuild_set_revision(pythonwheel
  # https://pypi.org/project/wheel/#history
  # PyPI source tarball with 'unicode.dist' test excised from it (CMake has
  # issues extracting non-UTF-8 names in tarballs).
  URL     "https://www.paraview.org/files/dependencies/wheel-0.41.2-nounicodedist.tar.gz"
  URL_MD5 b5f1f03ec0ad347b8b17c33077513863)

# https://pypi.org/project/mpi4py/#history
set(mpi4py_ver "3.1.4")
if (WIN32)
  superbuild_set_selectable_source(pythonmpi4py
    SELECTS_WITH python3
    SELECT 3.10
      URL     "https://www.paraview.org/files/dependencies/mpi4py-${mpi4py_ver}-cp310-cp310-win_amd64.whl"
      URL_MD5 22767c198cd8d9b80e8c96071650200e
    SELECT 3.9
      URL     "https://www.paraview.org/files/dependencies/mpi4py-${mpi4py_ver}-cp39-cp39-win_amd64.whl"
      URL_MD5 e8387c642919358a7d5739c8e7128f89)
else ()
  superbuild_set_revision(pythonmpi4py
    URL     "https://www.paraview.org/files/dependencies/mpi4py-${mpi4py_ver}.tar.gz"
    URL_MD5 09e20c0128207303a3d0462eb6b0c0e3)
endif ()

superbuild_set_revision(pythonpycparser
  # https://pypi.org/project/pycparser/#history
  URL     "https://www.paraview.org/files/dependencies/pycparser-2.21.tar.gz"
  URL_MD5 48f7d743bf018f7bb2ffc5fb976d1492)

superbuild_set_revision(pythontoml
  # https://pypi.org/project/toml/#history
  URL     "https://www.paraview.org/files/dependencies/toml-0.10.2.tar.gz"
  URL_MD5 59bce5d8d67e858735ec3f399ec90253)

superbuild_set_revision(pythonsetuptoolsscm
  # https://pypi.org/project/setuptools-scm/#history
  URL     "https://www.paraview.org/files/dependencies/setuptools_scm-7.1.0.tar.gz"
  URL_MD5 158dc741637fb4fa4b955c62bd2c08be)

superbuild_set_revision(pythonsetuptoolsrust
  # https://pypi.org/project/setuptools-rust/#history
  URL     "https://www.paraview.org/files/dependencies/setuptools-rust-1.7.0.tar.gz"
  URL_MD5 5d8c29528d6f99537ff6c186f977f470)

superbuild_set_revision(pythoncharsetnormalizer
  # https://pypi.org/project/charset-normalizer/#history
  URL     "https://www.paraview.org/files/dependencies/charset-normalizer-3.2.0.tar.gz"
  URL_MD5 dbb8c5b745beddbaae67d06dce0b7c29)

superbuild_set_revision(pythonaiosignal
  # https://pypi.org/project/aiosignal/#history
  URL     "https://www.paraview.org/files/dependencies/aiosignal-1.3.1.tar.gz"
  URL_MD5 2a15f4008b899377590cef4773020902)

superbuild_set_selectable_source(pythonfrozenlist
  # https://pypi.org/project/frozenlist/#history
  # When updating to a version that drops support for a Python version, also
  # update `projects/pythonfrozenlist.cmake`'s valid version detection.
  SELECT 1.4.0 DEFAULT
    URL     "https://www.paraview.org/files/dependencies/frozenlist-1.4.0.tar.gz"
    URL_MD5 4a14df2fe30853d9e18f73002493a860
  SELECT 1.3.3 # Needed for Python 3.7
    URL     "https://www.paraview.org/files/dependencies/frozenlist-1.3.3.tar.gz"
    URL_MD5 14e9ffd849c6a1dfa3c6b1fb1ff77b14
  SELECT 1.2.0 # Needed for Python 3.6
    URL     "https://www.paraview.org/files/dependencies/frozenlist-1.2.0.tar.gz"
    URL_MD5 8f1851ef871d95a15ebcf20255c12f6d)

superbuild_set_revision(pythonaiohttp
  # https://pypi.org/project/aiohttp/#history
  URL     "https://www.paraview.org/files/dependencies/aiohttp-3.8.5.tar.gz"
  URL_MD5 4bb59a17563df9a692c64418224ade12)

superbuild_set_revision(pythonasynctimeout
  # https://pypi.org/project/async-timeout/#history
  URL     "https://www.paraview.org/files/dependencies/async-timeout-4.0.3.tar.gz"
  URL_MD5 9bf7b764a7310cb063c1c261c21342e4)

superbuild_set_revision(pythonchardet
  # https://pypi.org/project/chardet/#history
  URL     "https://www.paraview.org/files/dependencies/chardet-5.2.0.tar.gz"
  URL_MD5 cc2d8cc9a751641463b4f7cfecad2ffa)

superbuild_set_revision(pythonmultidict
  # https://pypi.org/project/multidict/#history
  URL     "https://www.paraview.org/files/dependencies/multidict-6.0.4.tar.gz"
  URL_MD5 ec06a613d871dadfb66f2be3a1f2f3fa)

superbuild_set_revision(pythontypingextensions
  # https://pypi.org/project/typing_extensions/#history
  URL     "https://www.paraview.org/files/dependencies/typing_extensions-4.7.1.tar.gz"
  URL_MD5 06e7fff4b1d51f8dc6f49b16e71de54e)

superbuild_set_revision(pythonyarl
  # https://pypi.org/project/yarl/#history
  URL     "https://www.paraview.org/files/dependencies/yarl-1.9.2.tar.gz"
  URL_MD5 4e46a0c7078d34d9734a7c5d182dee92)

superbuild_set_revision(pythoncffi
  # https://pypi.org/project/cffi/#history
  URL     "https://www.paraview.org/files/dependencies/cffi-1.15.1.tar.gz"
  URL_MD5 f493860a6e98cd0c4178149568a6b4f6)

superbuild_set_revision(pythonsemanticversion
  # https://pypi.org/project/semantic_version/#history
  URL     "https://www.paraview.org/files/dependencies/semantic_version-2.10.0.tar.gz"
  URL_MD5 e48abef93ba69abcd4eaf4640edfc38b)

superbuild_set_revision(pythonidna
  # https://pypi.org/project/idna/#history
  URL     "https://www.paraview.org/files/dependencies/idna-3.2.tar.gz"
  URL_MD5 08ea8e2ce09e522424e872409c221138)

superbuild_set_revision(pythonwslinkasync
  # https://pypi.org/project/wslink/#history
  URL     "https://www.paraview.org/files/dependencies/wslink-1.11.1.tar.gz"
  URL_MD5 594a72a7dcc9fa805cc9dfda3b681613)

superbuild_set_revision(pythonsix
  # https://pypi.org/project/six/#history
  URL     "https://www.paraview.org/files/dependencies/six-1.16.0.tar.gz"
  URL_MD5 a7c927740e4964dd29b72cebfc1429bb)

superbuild_set_revision(pythonpygments
  # https://pypi.org/project/Pygments/#history
  URL     "https://www.paraview.org/files/dependencies/Pygments-2.16.1.tar.gz"
  URL_MD5 20cb967029c23389253326cf515dec8a)

superbuild_set_revision(pythonmarkupsafe
  # https://pypi.org/project/MarkupSafe/#history
  URL     "https://www.paraview.org/files/dependencies/MarkupSafe-2.1.3.tar.gz"
  URL_MD5 ca33f119bd0551ce15837f58bb180214)

superbuild_set_revision(pythonmako
  # https://pypi.org/project/Mako/#history
  URL     "https://www.paraview.org/files/dependencies/Mako-1.2.4.tar.gz"
  URL_MD5 651f365616611fcd4f2702a9002e2195)

superbuild_set_revision(pythoncppy
  # https://pypi.org/project/cppy/#history
  URL     "https://www.paraview.org/files/dependencies/cppy-1.2.1.tar.gz"
  URL_MD5 7c1f825c43dd66454440932a35b9969c)

superbuild_set_revision(pythonkiwisolver
  # https://pypi.org/project/kiwisolver/#history
  URL     "https://www.paraview.org/files/dependencies/kiwisolver-1.4.5.tar.gz"
  URL_MD5 20dea6992699d6be8a563995d7fe0309)

superbuild_set_revision(pythonpathspec
  # https://pypi.org/project/pathspec/#history
  URL     "https://www.paraview.org/files/dependencies/pathspec-0.11.2.tar.gz"
  URL_MD5 92ebd6d735d261952ff99d64083eeff4)

superbuild_set_selectable_source(pythonpluggy
  # https://pypi.org/project/pluggy/#history
  # When updating to a version that drops support for a Python version, also
  # update `projects/pythonpluggy.cmake`'s valid version detection.
  SELECT 1.3.0 DEFAULT
    URL     "https://www.paraview.org/files/dependencies/pluggy-1.3.0.tar.gz"
    URL_MD5 f31aad77be2f5af8ed3864159b7fd743
  SELECT 1.2.0 # Needed for Python 3.7
    URL     "https://www.paraview.org/files/dependencies/pluggy-1.2.0.tar.gz"
    URL_MD5 b6ab532a71304092cb0a309f82e8d8c6
  SELECT 1.0.0 # Needed for Python 3.6
    URL     "https://www.paraview.org/files/dependencies/pluggy-1.0.0.tar.gz"
    URL_MD5 daa6fddfb6cd364f3c82e52098911e4b)

superbuild_set_revision(pythontroveclassifiers
  # https://pypi.org/project/trove-classifiers/#history
  URL     "https://www.paraview.org/files/dependencies/trove-classifiers-2023.8.7.tar.gz"
  URL_MD5 6ae148c8374d131dd18e28c22275d56a)

superbuild_set_selectable_source(pythonhatchling
  # https://pypi.org/project/hatchling/#history
  # When updating to a version that drops support for a Python version, also
  # update `projects/pythonhatchling.cmake`'s valid version detection.
  SELECT 1.18.0 DEFAULT
    URL     "https://www.paraview.org/files/dependencies/hatchling-1.18.0.tar.gz"
    URL_MD5 43f7203cacb6c3c178b93149b8a8151d
  SELECT 1.17.1 # Needed for Python 3.7
    URL     "https://www.paraview.org/files/dependencies/hatchling-1.17.1.tar.gz"
    URL_MD5 456b26de1da49b23e65934ac5a39c7fa)

superbuild_set_revision(pythonhatchvcs
  # https://pypi.org/project/hatch-vcs/#history
  URL     "https://www.paraview.org/files/dependencies/hatch_vcs-0.3.0.tar.gz"
  URL_MD5 c2f2cbe6851b7b2969cb4aa24c4b9b2f)

superbuild_set_revision(pythonhatchfancypypireadme
  # https://pypi.org/project/hatch-fancy-pypi-readme/#history
  URL     "https://www.paraview.org/files/dependencies/hatch_fancy_pypi_readme-23.1.0.tar.gz"
  URL_MD5 8755cce1a4a4d5e5d84992089801acbf)

superbuild_set_revision(pythonattrs
  # https://pypi.org/project/attrs/#history
  URL     "https://www.paraview.org/files/dependencies/attrs-23.1.0.tar.gz"
  URL_MD5 6623fed7ffa22261ba25fccaf4d99539)

superbuild_set_revision(pythontzdata
  # https://pypi.org/project/tzdata/#history
  URL     "https://www.paraview.org/files/dependencies/tzdata-2023.3.tar.gz"
  URL_MD5 3c8f05d031770659a7d80de5159af202)

superbuild_set_revision(pythonversioneer
  # https://pypi.org/project/versioneer/#history
  URL     "https://www.paraview.org/files/dependencies/versioneer-0.29.tar.gz"
  URL_MD5 1703d6ced3656553066fa71e42c5eee6)

superbuild_set_revision(pythonpandas
  # https://pypi.org/project/pandas/#history
  URL     "https://www.paraview.org/files/dependencies/pandas-2.0.3.tar.gz"
  URL_MD5 9d78ba91d58e424e262b07ebf8a514ac)

superbuild_set_revision(ffi
  # https://github.com/libffi/libffi/releases
  URL     "https://www.paraview.org/files/dependencies/libffi-3.4.4.tar.gz"
  URL_MD5 0da1a5ed7786ac12dcbaf0d499d8a049)

superbuild_set_revision(utillinux
  # https://mirrors.edge.kernel.org/pub/linux/utils/util-linux/
  URL     "https://www.paraview.org/files/dependencies/util-linux-2.39.2.tar.xz"
  URL_MD5 2feb3e7c306f336a3d22a182dfffc942)

superbuild_set_revision(pkgconf
  # https://distfiles.ariadne.space/pkgconf/
  URL     "https://www.paraview.org/files/dependencies/pkgconf-2.0.2.tar.xz"
  URL_MD5 9bc6eee9dc86e96f855ce70a39a12bd3)

superbuild_set_revision(pybind11
  # https://github.com/pybind/pybind11/releases
  URL     "https://www.paraview.org/files/dependencies/pybind11-2.11.1.tar.gz"
  URL_MD5 49e92f92244021912a56935918c927d0)

superbuild_set_revision(sqlite
  # https://sqlite.org/download.html
  URL     "https://www.paraview.org/files/dependencies/sqlite-autoconf-3430000.tar.gz"
  URL_MD5 f321a958aed13fb5f8773ae2f3504c0b)

superbuild_set_revision(expat
  # https://github.com/libexpat/libexpat/releases
  URL     "https://www.paraview.org/files/dependencies/expat-2.5.0.tar.xz"
  URL_MD5 ac6677b6d1b95d209ab697ce8b688704)

superbuild_set_revision(glproto
  # Deprecated; no new releases.
  URL     "https://www.paraview.org/files/dependencies/glproto-1.4.17.tar.bz2"
  URL_MD5 5565f1b0facf4a59c2778229c1f70d10)

superbuild_set_revision(meson
  # https://github.com/mesonbuild/meson/releases
  URL     "https://www.paraview.org/files/dependencies/meson-1.2.1.tar.gz"
  URL_MD5 e3cc846536189aacd7d01858a45ca9af)

superbuild_set_selectable_source(mesa
  # https://gitlab.freedesktop.org/mesa/mesa/-/tags
  SELECT 23.1.6
    URL     "https://www.paraview.org/files/dependencies/mesa-23.1.6.tar.xz"
    URL_MD5 5dd176e3f283143cc193b5a8264a206e
  SELECT 22.3.3 DEFAULT
    URL     "https://www.paraview.org/files/dependencies/mesa-22.3.3.tar.xz"
    URL_MD5 3cee19ea4d800e6ca8570d1f9ab1482d
  SELECT 21.2.1
    URL     "https://www.paraview.org/files/dependencies/mesa-21.2.1.tar.xz"
    URL_MD5 5d8beb41eccad604296d1e2a6688dd6a)
# Use the same selection for `osmesa` as `mesa`. However, add `DOWNLOAD_NAME`
# arguments to rename the local file for `osmesa` to avoid conflicts while
# downloading the files in parallel.
get_property(mesa_revision GLOBAL PROPERTY mesa_revision)
set(osmesa_args)
set(next_is_url 0)
foreach (mesa_arg IN LISTS mesa_revision)
  list(APPEND osmesa_args "${mesa_arg}")
  if (next_is_url)
    get_filename_component(filename "${mesa_arg}" NAME)
    list(APPEND osmesa_args
      DOWNLOAD_NAME "os${filename}")
    set(next_is_url 0)
  elseif (mesa_arg STREQUAL "URL")
    set(next_is_url 1)
  endif ()
endforeach ()
superbuild_set_revision(osmesa ${osmesa_args})

superbuild_set_selectable_source(llvm
  # https://github.com/llvm/llvm-project/releases
  SELECTS_WITH mesa
  SELECT 23.1.6
    URL     "https://www.paraview.org/files/dependencies/llvm-project-16.0.6.src.tar.xz"
    URL_MD5 dc13938a604f70379d3b38d09031de98
  SELECT 22.3.3
    URL     "https://www.paraview.org/files/dependencies/llvm-project-15.0.6.src.tar.xz"
    URL_MD5 8202ece5dfaad502ee513a8eaaa4ada3
  SELECT 21.2.1
    URL     "https://www.paraview.org/files/dependencies/llvm-7.0.0.src.tar.xz"
    URL_MD5 e0140354db83cdeb8668531b431398f0)
set(llvm_version_23.1.6 "16.0.6")
set(llvm_version_22.3.3 "15.0.6")
set(llvm_version_21.2.1 "7.0.0")

superbuild_set_revision(ninja
  # https://github.com/ninja-build/ninja/releases
  URL     "https://www.paraview.org/files/dependencies/ninja-1.11.1.tar.gz"
  URL_MD5 32151c08211d7ca3c1d832064f6939b0)

superbuild_set_revision(openxrsdk
  # https://github.com/KhronosGroup/OpenXR-SDK/releases
  URL     "https://www.paraview.org/files/dependencies/OpenXR-SDK-release-1.0.28.tar.gz"
  URL_MD5 c1d4caa3c1b7a7e7b972202f55cc8d2b)

superbuild_set_revision(jsoncpp
  # https://github.com/open-source-parsers/jsoncpp/releases
  URL     "https://www.paraview.org/files/dependencies/jsoncpp-1.9.5.tar.gz"
  URL_MD5 d6c8c609f2162eff373db62b90a051c7)

superbuild_set_selectable_source(ospray
  # https://github.com/ospray/ospray/releases
  SELECT 2.7.1
    URL     "https://www.paraview.org/files/dependencies/ospray-v2.7.1.tar.gz"
    URL_MD5 e027ca7a5119300a0c94c3f9be38b58d
  SELECT 2.12.0 DEFAULT
    URL     "https://www.paraview.org/files/dependencies/ospray-2.12.0.tar.gz"
    URL_MD5 44445f0d181d52ca1c06bbea3c808761)

# https://github.com/ispc/ispc/releases
if (WIN32)
  set(ispc_1.16.1_suffix "windows.zip")
  set(ispc_1.21.0_suffix "windows.zip")
  set(ispc_1.16.1_md5 22d1e9fd03427b8e8a9d75ce56cfa495)
  set(ispc_1.21.0_md5 c3757640921b6b53086dd842b2f36992)
elseif (APPLE)
  set(ispc_1.16.1_suffix "macOS.tar.gz")
  set(ispc_1.21.0_suffix "macOS.universal.tar.gz")
  set(ispc_1.16.1_md5 0ae980be5d319b38592c6ef5596c305d)
  set(ispc_1.21.0_md5 dd91293a5a8db6182df2360ed1c1be24)
else()
  set(ispc_1.16.1_suffix "linux.tar.gz")
  set(ispc_1.21.0_suffix "linux.tar.gz")
  set(ispc_1.16.1_md5 4665c577541003e31c8ce0afd64b6952)
  set(ispc_1.21.0_md5 281e7cb034f454553133587b88081aad)
endif()
superbuild_set_selectable_source(ispc
  SELECTS_WITH ospray
  SELECT 2.7.1
    URL     "https://www.paraview.org/files/dependencies/ispc-v1.16.1-${ispc_1.16.1_suffix}"
    URL_MD5 "${ispc_1.16.1_md5}"
  SELECT 2.12.0
    URL     "https://www.paraview.org/files/dependencies/ispc-v1.21.0-${ispc_1.21.0_suffix}"
    URL_MD5 "${ispc_1.21.0_md5}")

superbuild_set_selectable_source(embree
  # https://github.com/embree/embree/releases
  SELECTS_WITH ospray
  SELECT 2.7.1
    URL     "https://www.paraview.org/files/dependencies/embree-v3.13.1.tar.gz"
    URL_MD5 71453f1e9af48a95090112e493982898
  SELECT 2.12.0
    URL     "https://www.paraview.org/files/dependencies/embree-4.2.0.tar.gz"
    URL_MD5 9e6abbfb230a2ea07e80fa193ed94186)

superbuild_set_selectable_source(openvkl
  # https://github.com/openvkl/openvkl/releases
  SELECTS_WITH ospray
  SELECT 2.7.1
    URL     "https://www.paraview.org/files/dependencies/openvkl-v1.0.1.tar.gz"
    URL_MD5 c6a9a222df0e7f21b49ea8081b509171
  SELECT 2.12.0
    URL     "https://www.paraview.org/files/dependencies/openvkl-1.3.2.tar.gz"
    URL_MD5 b9020e3ab6019055db437d9f1cef50e6)

superbuild_set_revision(ospraymaterials
  # https://gitlab.kitware.com/paraview/materials/-/tags
  # Note that the version is not used in the tag name.
  URL     "https://www.paraview.org/files/data/OSPRayMaterials-0.3.tar.gz"
  URL_MD5 d256c17f70890d3477e90d35bf814c25)

superbuild_set_selectable_source(openimagedenoise
  # https://github.com/OpenImageDenoise/oidn/releases
  SELECTS_WITH ospray
  SELECT 2.7.1
    URL     "https://www.paraview.org/files/dependencies/oidn-1.4.1.src.tar.gz"
    URL_MD5 df4007b0ab93b1c41cdf223b075d01c0
  SELECT 2.12.0
    URL     "https://www.paraview.org/files/dependencies/oidn-2.0.1.src.tar.gz"
    URL_MD5 9e13ff3d9eb640e923b699bea1c8d419)

superbuild_set_selectable_source(rkcommon
  # https://github.com/ospray/rkcommon/tags
  SELECTS_WITH ospray
  SELECT 2.7.1
    URL     "https://www.paraview.org/files/dependencies/rkcommon-v1.7.0.tar.gz"
    URL_MD5 1bd26e5aea9b1c4873fe8b8cec9a1d28
  SELECT 2.12.0
    URL     "https://www.paraview.org/files/dependencies/rkcommon-1.11.0.tar.gz"
    URL_MD5 2a298ad88b2959e44c275a6ff679bf1f)

superbuild_set_revision(snappy
  # https://github.com/google/snappy/releases
  URL     "https://www.paraview.org/files/dependencies/snappy-1.1.10.tar.gz"
  URL_MD5 70153395ebe6d72febe2cf2e40026a44)

# https://pypi.org/project/cryptography/#history
set(pythoncryptography_version "41.0.3")
if (CMAKE_SYSTEM_NAME STREQUAL "Windows")
  if (CMAKE_HOST_SYSTEM_PROCESSOR MATCHES "64")
    set(pythoncryptography_file
      "cryptography-${pythoncryptography_version}-cp37-abi3-win_amd64.whl")
    set(pythoncryptography_md5
      "5dee5069491c917a975d76fa655ab0ad")
  endif ()
elseif (CMAKE_SYSTEM_NAME STREQUAL "Darwin")
  if (CMAKE_HOST_SYSTEM_PROCESSOR STREQUAL "x86_64")
    set(pythoncryptography_file
      "cryptography-${pythoncryptography_version}-cp37-abi3-macosx_10_12_x86_64.whl")
    set(pythoncryptography_md5
      "1351baacf6069403c3f916a46cebbad5")
  elseif (CMAKE_HOST_SYSTEM_PROCESSOR STREQUAL "arm64")
    set(pythoncryptography_file
      "cryptography-${pythoncryptography_version}-cp37-abi3-macosx_10_12_universal2.whl")
    set(pythoncryptography_md5
      "bedfef0b707ea313b212c2e72222e883")
  endif ()
elseif (CMAKE_SYSTEM_NAME STREQUAL "Linux")
  if (CMAKE_HOST_SYSTEM_PROCESSOR STREQUAL "x86_64")
    set(pythoncryptography_file
      "cryptography-${pythoncryptography_version}-cp37-abi3-manylinux_2_17_x86_64.manylinux2014_x86_64.whl")
    set(pythoncryptography_md5
      "c7fce3b285651310e92cfe5a6e299898")
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
    "fbf930acd8de95780604c40c4e817a74")
  set_property(GLOBAL
    PROPERTY
      pythoncryptography_source 1)
endif ()
superbuild_set_revision(pythoncryptography
  URL     "https://www.paraview.org/files/dependencies/${pythoncryptography_file}"
  URL_MD5 "${pythoncryptography_md5}")

# https://github.com/openssl/openssl/releases
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

superbuild_set_revision(flexbison
  # https://github.com/lexxmark/winflexbison/releases
  URL     "https://www.paraview.org/files/dependencies/win_flex_bison-2.5.25.zip"
  URL_MD5 "720226b1befe7033fb3ecc98f5ffd425")

superbuild_set_revision(alembic
  # https://github.com/alembic/alembic/releases
  URL     "https://www.paraview.org/files/dependencies/alembic-1.8.5.tar.gz"
  URL_MD5 fcd5b5492a005057e11b601b60ac9a49)

superbuild_set_revision(imath
  # https://github.com/AcademySoftwareFoundation/Imath/releases
  URL     "https://www.paraview.org/files/dependencies/Imath-3.1.9.tar.gz"
  URL_MD5 97f1cbfb86b88ddfde42b7df1f1494db)

superbuild_set_revision(zstd
  # https://github.com/facebook/zstd/releases
  URL     "https://www.paraview.org/files/dependencies/zstd-1.5.5.tar.gz"
  URL_MD5 "63251602329a106220e0a5ad26ba656f")

superbuild_set_revision(lz4
  # https://github.com/lz4/lz4/releases
  URL     "https://www.paraview.org/files/dependencies/lz4-1.9.4.tar.gz"
  URL_MD5 "e9286adb64040071c5e23498bf753261")

superbuild_set_revision(blosc
  # https://github.com/Blosc/c-blosc/releases
  URL     "https://www.paraview.org/files/dependencies/blosc-1.21.5.tar.gz"
  URL_MD5 "5097ee61dc1f25281811f5a55b91b2e4")
