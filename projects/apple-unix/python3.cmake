if (BUILD_SHARED_LIBS)
  set(python3_shared_args --enable-shared)
else ()
  set(python3_shared_args --disable-shared --enable-static)
endif ()

set(python3_environment)
if (APPLE AND CMAKE_OSX_DEPLOYMENT_TARGET)
  list(APPEND python3_environment
    MACOSX_DEPLOYMENT_TARGET "${CMAKE_OSX_DEPLOYMENT_TARGET}")
endif ()

superbuild_add_project(python3
  CAN_USE_SYSTEM
  DEPENDS bzip2 zlib png ffi sqlite
  CONFIGURE_COMMAND
    <SOURCE_DIR>/configure
      --prefix=<INSTALL_DIR>
      --with-ensurepip=install
      --with-pymalloc
      --without-pydebug
      ${python3_shared_args}
  BUILD_COMMAND
    $(MAKE)
  INSTALL_COMMAND
    make install
  PROCESS_ENVIRONMENT
    ${python3_environment})

if (NOT CMAKE_CROSSCOMPILING)
  # Pass the -rpath flag when building python to avoid issues running the
  # executable we built.
  superbuild_append_flags(
    ld_flags "-Wl,-rpath,${superbuild_install_location}/lib"
    PROJECT_ONLY)
endif ()

if (APPLE AND CMAKE_OSX_DEPLOYMENT_TARGET)
  superbuild_append_flags(c_flags
    "-mmacosx-version-min=${CMAKE_OSX_DEPLOYMENT_TARGET}"
    PROJECT_ONLY)
endif ()

if (python3_enabled)
  set(superbuild_python_executable "${superbuild_install_location}/bin/python3"
    CACHE INTERNAL "")
  set(superbuild_python_pip "${superbuild_install_location}/bin/pip3"
    CACHE INTERNAL "")
else ()
  set(superbuild_python_executable ""
    CACHE INTERNAL "")
  set(superbuild_python_pip ""
    CACHE INTERNAL "")
endif ()

set(superbuild_python_version "3.9"
  CACHE INTERNAL "")

superbuild_add_extra_cmake_args(
  -DPython3_EXECUTABLE:FILEPATH=<INSTALL_DIR>/bin/python${superbuild_python_version}
  -DPython3_INCLUDE_DIR:PATH=<INSTALL_DIR>/include/python${superbuild_python_version}
  -DPython3_LIBRARY:FILEPATH=<INSTALL_DIR>/lib/libpython${superbuild_python_version}${CMAKE_SHARED_LIBRARY_SUFFIX}
  -DPython3_LIBRARY_RELEASE:FILEPATH=<INSTALL_DIR>/lib/libpython${superbuild_python_version}${CMAKE_SHARED_LIBRARY_SUFFIX}

  -DPYTHON_EXECUTABLE:FILEPATH=<INSTALL_DIR>/bin/python${superbuild_python_version}
  -DPYTHON_INCLUDE_DIR:PATH=<INSTALL_DIR>/include/python${superbuild_python_version}
  -DPYTHON_LIBRARY:FILEPATH=<INSTALL_DIR>/lib/libpython${superbuild_python_version}${CMAKE_SHARED_LIBRARY_SUFFIX}
  -DPYTHON_LIBRARY_RELEASE:FILEPATH=<INSTALL_DIR>/lib/libpython${superbuild_python_version}${CMAKE_SHARED_LIBRARY_SUFFIX}
)
