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
  URL     "https://www.paraview.org/files/dependencies/cgns-4.3.0.tar.gz"
  URL_MD5 bce0461cd385ec5daeb04986093290d1)

superbuild_set_revision(seacas
  # https://github.com/sandialabs/seacas/releases
  URL     "https://www.paraview.org/files/dependencies/seacas-2022-08-01.tar.gz"
  URL_MD5 1d50fdd11b1293a7bbb87eb15ca4b6e2)

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
  URL     "https://www.paraview.org/files/dependencies/hdf5-1.12.1.tar.bz2"
  URL_MD5  442469fbf43626006346e679c22cf10a)

superbuild_set_revision(boost
  # https://www.boost.org/users/download/
  URL     "https://www.paraview.org/files/dependencies/boost_1_83_0.tar.bz2"
  URL_MD5 406f0b870182b4eb17a23a9d8fce967d)

superbuild_set_revision(png
  # http://www.libpng.org/pub/png/libpng.html
  URL     "https://www.paraview.org/files/dependencies/libpng-1.6.40.tar.xz"
  URL_MD5 6c7fe9dbb80c89c3579bedad9722e559)

if (WIN32)
  superbuild_set_revision(python3
    # See https://www.paraview.org/files/dependencies/python-for-wheels/
    # To make a new one, see `vtk/vtk@.gitlab/ci/wheels/`
    URL     "https://www.paraview.org/files/dependencies/python-for-wheels/python-3.9.13-windows-x86_64.zip"
    URL_MD5 fe29035c955c49ace9e2844a505bbc09)
else()
  superbuild_set_revision(python3
    # https://www.python.org/downloads/source/
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
  # Note: downloaded assets need renamed from `json.tar.xz`
  URL     "https://www.paraview.org/files/dependencies/nlohmannjson-v3.9.1.tar.gz"
  URL_MD5 e386222fb57dd2fcb8a7879fc016d037)

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

superbuild_set_revision(numpy
  # https://pypi.org/project/numpy/#history
  URL     "https://www.paraview.org/files/dependencies/numpy-1.25.2.tar.gz"
  URL_MD5 cee1996a80032d47bdf1d9d17249c34e)

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
  superbuild_set_revision(scipy
    URL     "https://www.paraview.org/files/dependencies/scipy-${scipy_version}-cp39-cp39-win_amd64.whl"
    URL_MD5 2e2b1fcf6ea9c311576700daf18ccc19)
else ()
  superbuild_set_revision(scipy
    URL     "https://www.paraview.org/files/dependencies/scipy-${scipy_version}.tar.gz"
    URL_MD5 27baf613b6cf3f9600a05161f132151c)
endif ()

superbuild_set_revision(pythonmpmath
  # https://pypi.org/project/mpmath/#history
  URL     "https://www.paraview.org/files/dependencies/mpmath-1.2.1.tar.gz"
  URL_MD5 ef8a6449851755319673b06f71731d52)

superbuild_set_revision(sympy
  # https://pypi.org/project/sympy/#history
  URL     "https://www.paraview.org/files/dependencies/sympy-1.10.1.tar.gz"
  URL_MD5 8c7a956d74a47dc439c2935fec64ac46)

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

superbuild_set_revision(matplotlib
  # https://pypi.org/project/matplotlib/#history
  URL "https://www.paraview.org/files/dependencies/matplotlib-3.4.2.tar.gz"
  URL_MD5 e34749a5f0661b8af74a1dc327fb74f6)

superbuild_set_revision(pywin32
  # https://pypi.org/project/pywin32/#history
  URL "https://www.paraview.org/files/dependencies/pywin32-301-cp39-cp39-win_amd64.whl"
  URL_MD5 3fe9793d6bee6e9b6515bc744f7585df)

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
  URL     "https://www.paraview.org/files/dependencies/pyparsing-2.4.7.tar.gz"
  URL_MD5 f0953e47a0112f7a65aec2305ffdf7b4)

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

superbuild_set_revision(pythonsetuptools
  # https://pypi.org/project/setuptools/#history
  URL     "https://www.paraview.org/files/dependencies/setuptools-68.1.2.tar.gz"
  URL_MD5 222b8c1a7432457d8485f947a0e0fde6)

superbuild_set_revision(pythonwheel
  # https://pypi.org/project/wheel/#history
  # PyPI source tarball with 'unicode.dist' test excised from it (CMake has
  # issues extracting non-UTF-8 names in tarballs).
  URL     "https://www.paraview.org/files/dependencies/wheel-0.41.2-nounicodedist.tar.gz"
  URL_MD5 b5f1f03ec0ad347b8b17c33077513863)

# https://pypi.org/project/mpi4py/#history
set(mpi4py_ver "3.1.3")
if (WIN32)
  superbuild_set_revision(pythonmpi4py
    URL     "https://www.paraview.org/files/dependencies/mpi4py-${mpi4py_ver}-cp39-cp39-win_amd64.whl"
    URL_MD5 e9e890b7058b81cd1099627c61852967)
else ()
  superbuild_set_revision(pythonmpi4py
    URL     "https://www.paraview.org/files/dependencies/mpi4py-${mpi4py_ver}.tar.gz"
    URL_MD5 e6d0644a2a3c7aa5119825d35ebeb8ee)
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
  URL     "https://www.paraview.org/files/dependencies/setuptools_scm-6.0.1.tar.gz"
  URL_MD5 aa7f0efbbf46c5576db5994dd1ce3f8d)

superbuild_set_revision(pythonsetuptoolsrust
  # https://pypi.org/project/setuptools-rust/#history
  URL     "https://www.paraview.org/files/dependencies/setuptools-rust-0.12.1.tar.gz"
  URL_MD5 33c3fd3bcde2877483ab782353bee54c)

superbuild_set_revision(pythonaiohttp
  # https://pypi.org/project/aiohttp/#history
  URL     "https://www.paraview.org/files/dependencies/aiohttp-3.7.4.post0.tar.gz"
  URL_MD5 7052a8e9877921d73da98d2b18c9a145)

superbuild_set_revision(pythonasynctimeout
  # https://pypi.org/project/async-timeout/#history
  URL     "https://www.paraview.org/files/dependencies/async-timeout-4.0.3.tar.gz"
  URL_MD5 9bf7b764a7310cb063c1c261c21342e4)

superbuild_set_revision(pythonchardet
  # https://pypi.org/project/chardet/#history
  URL     "https://www.paraview.org/files/dependencies/chardet-4.0.0.tar.gz"
  URL_MD5 bc9a5603d8d0994b2d4cbf255f99e654)

superbuild_set_revision(pythonmultidict
  # https://pypi.org/project/multidict/#history
  URL     "https://www.paraview.org/files/dependencies/multidict-6.0.4.tar.gz"
  URL_MD5 ec06a613d871dadfb66f2be3a1f2f3fa)

superbuild_set_revision(pythontypingextensions
  # https://pypi.org/project/typing_extensions/#history
  URL     "https://www.paraview.org/files/dependencies/typing_extensions-3.10.0.0.tar.gz"
  URL_MD5 9b5b33ae64c94479fa0862cf8ae89d58)

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
  URL     "https://www.paraview.org/files/dependencies/wslink-1.9.1.tar.gz"
  URL_MD5 7b0817ee259844d3e7e48fbfeee43037)

superbuild_set_revision(pythonsix
  # https://pypi.org/project/six/#history
  URL     "https://www.paraview.org/files/dependencies/six-1.16.0.tar.gz"
  URL_MD5 a7c927740e4964dd29b72cebfc1429bb)

superbuild_set_revision(pythonpygments
  # https://pypi.org/project/Pygments/#history
  URL     "https://www.paraview.org/files/dependencies/Pygments-2.9.0.tar.gz"
  URL_MD5 665516d1d1c0099241ab6e4c057e26be)

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
  URL     "https://www.paraview.org/files/dependencies/kiwisolver-1.3.1.tar.gz"
  URL_MD5 81012578317ddcfa3daed806142f8fed)

superbuild_set_revision(pythonpathspec
  # https://pypi.org/project/pathspec/#history
  URL     "https://www.paraview.org/files/dependencies/pathspec-0.11.2.tar.gz"
  URL_MD5 92ebd6d735d261952ff99d64083eeff4)

superbuild_set_revision(pythonpluggy
  # https://pypi.org/project/pluggy/#history
  URL     "https://www.paraview.org/files/dependencies/pluggy-1.3.0.tar.gz"
  URL_MD5 f31aad77be2f5af8ed3864159b7fd743)

superbuild_set_revision(pythontroveclassifiers
  # https://pypi.org/project/trove-classifiers/#history
  URL     "https://www.paraview.org/files/dependencies/trove-classifiers-2023.8.7.tar.gz"
  URL_MD5 6ae148c8374d131dd18e28c22275d56a)

superbuild_set_revision(pythonhatchling
  # https://pypi.org/project/hatchling/#history
  URL     "https://www.paraview.org/files/dependencies/hatchling-1.18.0.tar.gz"
  URL_MD5 43f7203cacb6c3c178b93149b8a8151d)

superbuild_set_revision(pythonhatchvcs
  # https://pypi.org/project/hatch-vcs/#history
  URL     "https://www.paraview.org/files/dependencies/hatch_vcs-0.3.0.tar.gz"
  URL_MD5 c2f2cbe6851b7b2969cb4aa24c4b9b2f)

superbuild_set_revision(pythonattrs
  # https://pypi.org/project/attrs/#history
  URL     "https://www.paraview.org/files/dependencies/attrs-21.2.0.tar.gz"
  URL_MD5 06af884070d9180694becdb106e5cd65)

superbuild_set_revision(pythonpandas
  # https://pypi.org/project/pandas/#history
  URL     "https://www.paraview.org/files/dependencies/pandas-1.3.1.tar.gz"
  URL_MD5 407560bb24b0ec4785ecf4dba5e1a139)

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
get_property(mesa_revision GLOBAL PROPERTY mesa_revision)
superbuild_set_revision(osmesa ${mesa_revision})

superbuild_set_selectable_source(llvm
  # https://github.com/llvm/llvm-project/releases
  SELECTS_WITH mesa
  SELECT 23.1.6
    URL     "https://www.paraview.org/files/dependencies/llvm-project-15.0.6.src.tar.xz"
    URL_MD5 8202ece5dfaad502ee513a8eaaa4ada3
  SELECT 22.3.3
    URL     "https://www.paraview.org/files/dependencies/llvm-project-15.0.6.src.tar.xz"
    URL_MD5 8202ece5dfaad502ee513a8eaaa4ada3
  SELECT 21.2.1
    URL     "https://www.paraview.org/files/dependencies/llvm-7.0.0.src.tar.xz"
    URL_MD5 e0140354db83cdeb8668531b431398f0)
set(llvm_version_23.1.6 "15.0.6")
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

if (WIN32)
  set(ispc_suffix "windows.zip")
  set(ispc_md5 c3757640921b6b53086dd842b2f36992)
elseif (APPLE)
  set(ispc_suffix "macOS.universal.tar.gz")
  set(ispc_md5 dd91293a5a8db6182df2360ed1c1be24)
else()
  set(ispc_suffix "linux.tar.gz")
  set(ispc_md5 281e7cb034f454553133587b88081aad)
endif()
superbuild_set_revision(ispc
  # https://github.com/ispc/ispc/releases
  URL     "https://www.paraview.org/files/dependencies/ispc-v1.21.0-${ispc_suffix}"
  URL_MD5 "${ispc_md5}")

superbuild_set_revision(embree
  # https://github.com/embree/embree/releases
  URL     "https://www.paraview.org/files/dependencies/embree-4.2.0.tar.gz"
  URL_MD5 9e6abbfb230a2ea07e80fa193ed94186)

superbuild_set_revision(openvkl
  # https://github.com/openvkl/openvkl/releases
  URL     "https://www.paraview.org/files/dependencies/openvkl-1.3.2.tar.gz"
  URL_MD5 b9020e3ab6019055db437d9f1cef50e6)

superbuild_set_revision(ospray
  # https://github.com/ospray/ospray/releases
  URL     "https://www.paraview.org/files/dependencies/ospray-2.12.0.tar.gz"
  URL_MD5 44445f0d181d52ca1c06bbea3c808761)

superbuild_set_revision(ospraymaterials
  # https://gitlab.kitware.com/paraview/materials/-/tags
  # Note that the version is not used in the tag name.
  URL     "https://www.paraview.org/files/data/OSPRayMaterials-0.3.tar.gz"
  URL_MD5 d256c17f70890d3477e90d35bf814c25)

superbuild_set_revision(openimagedenoise
  # https://github.com/OpenImageDenoise/oidn/releases
  URL     "https://www.paraview.org/files/dependencies/oidn-2.0.1.src.tar.gz"
  URL_MD5 9e13ff3d9eb640e923b699bea1c8d419)

superbuild_set_revision(rkcommon
  # https://github.com/ospray/rkcommon/tags
  URL     "https://www.paraview.org/files/dependencies/rkcommon-1.11.0.tar.gz"
  URL_MD5 2a298ad88b2959e44c275a6ff679bf1f)

superbuild_set_revision(snappy
  # https://github.com/google/snappy/releases
  URL     "https://www.paraview.org/files/dependencies/snappy-1.1.10.tar.gz"
  URL_MD5 70153395ebe6d72febe2cf2e40026a44)

# https://pypi.org/project/cryptography/#history
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
