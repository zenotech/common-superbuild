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

superbuild_set_revision(mpi
  URL     "http://paraview.org/files/dependencies/mpich2-1.4.1p1.tar.gz"
  URL_MD5 b470666749bcb4a0449a072a18e2c204)
