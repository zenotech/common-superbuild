if (BUILD_SHARED_LIBS)
  set(mpi_shared_args --enable-shared --disable-static)
else ()
  set(mpi_shared_args --disable-shared --enable-static)
endif ()

superbuild_add_project(mpi
  CAN_USE_SYSTEM
  BUILD_IN_SOURCE 1
  CONFIGURE_COMMAND
    <SOURCE_DIR>/configure
      --prefix=<INSTALL_DIR>
      ${mpi_shared_args}
      --disable-fortran
      --disable-fc
      --disable-mpe
  # PVExternalProject_Add sets up an parallel build, by default. that doesn't
  # work for the version of MPICH2 we're using.
  BUILD_COMMAND
    make
  INSTALL_COMMAND
    make install)

if (NOT USE_SYSTEM_mpi)
  set(MPI_C_COMPILER <INSTALL_DIR>/bin/mpicc)
  set(MPI_CXX_COMPILER <INSTALL_DIR>/bin/mpic++)
endif ()
