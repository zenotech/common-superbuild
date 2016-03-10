if (BUILD_SHARED_LIBS)
  set(python_shared_args --enable-shared --disable-static)
else ()
  set(python_shared_args --disable-shared --enable-static)
endif ()

superbuild_add_project(python
  CAN_USE_SYSTEM
  DEPENDS bzip2 zlib png
  CONFIGURE_COMMAND
    <SOURCE_DIR>/configure
      --prefix=<INSTALL_DIR>
      --enable-unicode
      ${python_shared_args}
  BUILD_COMMAND
    $(MAKE)
  INSTALL_COMMAND
    make install)

if (NOT CMAKE_CROSSCOMPILING)
  # Pass the -rpath flag when building python to avoid issues running the
  # executable we built.
  superbuild_append_flags(
    LDFLAGS "-Wl,-rpath,${superbuild_install_location}/lib"
    PROJECT_ONLY)
endif ()

set(superbuild_python_executable "${superbuild_install_location}/bin/python"
  CACHE INTERNAL "")

superbuild_add_extra_cmake_args(
  -DVTK_PYTHON_VERSION=2.7)
