if (BUILD_SHARED_LIBS)
  set(mpi_shared_args --enable-shared --disable-static)
else ()
  set(mpi_shared_args --disable-shared --enable-static)
endif ()

if (superbuild_build_phase AND CMAKE_VERSION VERSION_LESS "3.21.2")
  message(AUTHOR_WARNING
    "CMake's FindMPI prior to 3.21.2 extracts incorrect flags for this build "
    "of MPICH. Please use a newer CMake to avoid miscompilations in projects "
    "consuming this MPI build.")
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

# Set `-fallow-argument-mismatch` for gfortran 10+.
if (CMAKE_Fortran_COMPILER_ID STREQUAL "GNU" AND
    NOT CMAKE_Fortran_COMPILER_VERSION VERSION_LESS "10")
  superbuild_append_flags(f_flags
    -fallow-argument-mismatch
    PROJECT_ONLY)
endif ()
