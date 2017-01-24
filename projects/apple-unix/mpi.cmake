if (BUILD_SHARED_LIBS)
  set(mpi_shared_args --enable-shared --disable-static)
else ()
  set(mpi_shared_args --disable-shared --enable-static)
endif ()

set(mpi_fortran_flags
  --disable-fortran
  --disable-fc)
if (fortran_enabled)
  set(mpi_fortran_flags)
endif ()

superbuild_add_project(mpi
  CAN_USE_SYSTEM
  DEPENDS_OPTIONAL fortran
  BUILD_IN_SOURCE 1
  CONFIGURE_COMMAND
    <SOURCE_DIR>/configure
      --prefix=<INSTALL_DIR>
      ${mpi_shared_args}
      ${mpi_fortran_flags}
      --disable-mpe
  BUILD_COMMAND
    $(MAKE)
  INSTALL_COMMAND
    $(MAKE) install)

if (NOT USE_SYSTEM_mpi)
  set(MPI_C_COMPILER <INSTALL_DIR>/bin/mpicc)
  set(MPI_CXX_COMPILER <INSTALL_DIR>/bin/mpic++)
endif ()
