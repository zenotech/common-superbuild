set(seacas_has_component OFF)

set(seacas_depends)
set(seacas_depends_optional)

set(seacas_licenses)
if (exodus_enabled)
  set(seacas_has_component ON)
  list(APPEND seacas_depends
    hdf5 netcdf)
  list(APPEND seacas_depends_optional
    mpi)
  list(APPEND seacas_licenses
    packages/seacas/libraries/exodus/COPYRIGHT)
endif ()

if (superbuild_build_phase AND NOT seacas_has_component)
  message(FATAL_ERROR
    "Seacas is a collection of libraries; at least one must be enabled to "
    "work.")
endif ()

if (superbuild_build_phase AND CMAKE_VERSION VERSION_LESS "3.22")
  message(FATAL_ERROR
    "Seacas requires at least CMake 3.22")
endif ()

list(REMOVE_DUPLICATES seacas_depends)
list(REMOVE_DUPLICATES seacas_depends_optional)

superbuild_add_project(seacas
  DEPENDS
    ${seacas_depends}
  DEPENDS_OPTIONAL
    ${seacas_depends_optional}
  DEPENDS_OPTIONAL exodus
  LICENSE_FILES
    LICENSE
    ${seacas_licenses}
  SPDX_LICENSE_IDENTIFIER
    BSD-3-Clause
  SPDX_COPYRIGHT_TEXT
    "Copyright (c) National Technology & Engineering Solutions of Sandia, LLC (NTESS)"
  CMAKE_ARGS
    -DBUILD_TESTING:BOOL=OFF
    -DBUILD_SHARED_LIBS:BOOL=${BUILD_SHARED_LIBS}
    -DCMAKE_INSTALL_NAME_DIR:STRING=<INSTALL_DIR>/lib
    -DSeacas_ENABLE_ALL_OPTIONAL_PACKAGES:BOOL=OFF
    -DSeacas_ENABLE_Fortran:BOOL=OFF
    -DSeacas_ENABLE_TEUCHOS_TIME_MONITOR:BOOL=OFF
    -DSeacas_INSTALL_EXECUTABLES:BOOL=OFF
    -DSeacas_SKIP_CTEST_ADD_TEST:BOOL=ON
    -DTPL_ENABLE_DLlib:BOOL=OFF

    # TriBITS fixes.
    # Imported targets confuse the vendored TriBITS code.
    -DHDF5_NO_FIND_PACKAGE_CONFIG_FILE:BOOL=ON

    # exodus
    -DSeacas_ENABLE_SEACASExodus:BOOL=${exodus_enabled}
    -DTPL_ENABLE_HDF5:BOOL=${exodus_enabled}
    -DTPL_ENABLE_MPI:STRING=${mpi_enabled}
    )
