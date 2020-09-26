if (BUILD_SHARED_LIBS)
  set(mpi_shared_args --enable-shared --disable-static)
else ()
  set(mpi_shared_args --disable-shared --enable-static)
endif ()

set(mpi_fortran_flags
  --disable-fortran
  --disable-fc)
set(mpi_environment)
if (fortran_enabled)
  set(mpi_fortran_flags)
  set(mpi_environment
    FC ${CMAKE_Fortran_COMPILER})
endif ()

# Set `-fallow-argument-mismatch` for gfortran 10+.
if (CMAKE_Fortran_COMPILER_ID STREQUAL "GNU" AND
    NOT CMAKE_Fortran_COMPILER_VERSION VERSION_LESS "10")
  list(APPEND mpi_environment
    FFLAGS -fallow-argument-mismatch)
endif ()

superbuild_add_project(mpi
  CAN_USE_SYSTEM
  DEPENDS_OPTIONAL fortran
  BUILD_IN_SOURCE 1
  CONFIGURE_COMMAND
    <SOURCE_DIR>/configure
      --prefix=<INSTALL_DIR>
      --with-device=ch3:sock
      ${mpi_shared_args}
      ${mpi_fortran_flags}
      --disable-mpe
      --disable-libxml2
  BUILD_COMMAND
    $(MAKE)
  INSTALL_COMMAND
    $(MAKE) install
  PROCESS_ENVIRONMENT
    ${mpi_environment})

if (UNIX AND NOT APPLE)
  superbuild_append_flags(ld_flags
    "-Wl,-rpath,${superbuild_install_location}/lib"
    PROJECT_ONLY)
endif ()

if (NOT USE_SYSTEM_mpi)
  set(MPI_C_COMPILER <INSTALL_DIR>/bin/mpicc)
  set(MPI_CXX_COMPILER <INSTALL_DIR>/bin/mpic++)
endif ()

# https://github.com/pmodels/mpich/pull/4726
superbuild_apply_patch(mpi gfortran10
  "Support gfortran10")
