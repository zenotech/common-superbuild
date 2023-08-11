set(alembic_lib_install_dir lib)
if (WIN32)
  set(alembic_lib_install_dir bin)
endif ()

if (NOT BUILD_SHARED_LIBS_imath STREQUAL "<same>")
  if (BUILD_SHARED_LIBS_imath)
    set(alembic_ilmbase_link_static "OFF")
  else()
    set(alembic_ilmbase_link_static "ON")
  endif()
else ()
  if (BUILD_SHARED_LIBS)
    set(alembic_ilmbase_link_static "OFF")
  else()
    set(alembic_ilmbase_link_static "ON")
  endif()
endif ()

if (NOT BUILD_SHARED_LIBS_alembic STREQUAL "<same>")
  set(alembic_shared_libs ${BUILD_SHARED_LIBS_alembic})
else ()
  set(alembic_shared_libs ${BUILD_SHARED_LIBS})
endif ()

superbuild_add_project(alembic
  BUILD_SHARED_LIBS_INDEPENDENT
  LICENSE_FILES
    LICENSE.txt
  DEPENDS imath
  CMAKE_ARGS
    -DALEMBIC_ILMBASE_LINK_STATIC:BOOL=${alembic_ilmbase_link_static}
    -DALEMBIC_LIB_INSTALL_DIR:PATH=${alembic_lib_install_dir}
    -DALEMBIC_SHARED_LIBS:BOOL=${alembic_shared_libs}
    -DCMAKE_INSTALL_LIBDIR:STRING=lib
    -DCMAKE_INSTALL_NAME_DIR:PATH=<INSTALL_DIR>/lib
    -DCMAKE_INSTALL_RPATH:PATH=<INSTALL_DIR>/lib
    -DCMAKE_MACOSX_RPATH:BOOL=OFF
    -DUSE_BINARIES:BOOL=OFF
    -DUSE_TESTS:BOOL=OFF
)
