find_package(MPI REQUIRED)

# We need to sanitize lists to replace ';' with ${ep_list_separator}. This
# ensures that the arguments are passed correctly through a
# add_external_project() call.
superbuild_sanitize_lists_in_string(SB_ MPIEXEC_MAX_NUMPROCS)
superbuild_sanitize_lists_in_string(SB_ MPIEXEC_NUMPROC_FLAG)
superbuild_sanitize_lists_in_string(SB_ MPIEXEC_POSTFLAGS)
superbuild_sanitize_lists_in_string(SB_ MPIEXEC_PREFLAGS)
superbuild_sanitize_lists_in_string(SB_ MPI_CXX_COMPILE_FLAGS)
superbuild_sanitize_lists_in_string(SB_ MPI_CXX_INCLUDE_PATH)
superbuild_sanitize_lists_in_string(SB_ MPI_CXX_LIBRARIES)
superbuild_sanitize_lists_in_string(SB_ MPI_CXX_LINK_FLAGS)
superbuild_sanitize_lists_in_string(SB_ MPI_C_COMPILE_FLAGS)
superbuild_sanitize_lists_in_string(SB_ MPI_C_INCLUDE_PATH)
superbuild_sanitize_lists_in_string(SB_ MPI_C_LIBRARIES)
superbuild_sanitize_lists_in_string(SB_ MPI_C_LINK_FLAGS)
superbuild_sanitize_lists_in_string(SB_ MPI_EXTRA_LIBRARY)

superbuild_add_extra_cmake_args(
  -DMPIEXEC:FILEPATH=${MPIEXEC}
  -DMPI_CXX_COMPILER:FILEPATH=${MPI_CXX_COMPILER}
  -DMPI_C_COMPILER:FILEPATH=${MPI_C_COMPILER}
  -DMPI_Fortran_COMPILER:FILEPATH=${MPI_Fortran_COMPILER}
  -DMPI_LIBRARY:FILEPATH=${MPI_LIBRARY}

  -DMPIEXEC_MAX_NUMPROCS:STRING=${SB_MPIEXEC_MAX_NUMPROCS}
  -DMPIEXEC_NUMPROC_FLAG:STRING=${SB_MPIEXEC_NUMPROC_FLAG}
  -DMPIEXEC_POSTFLAGS:STRING=${SB_MPIEXEC_POSTFLAGS}
  -DMPIEXEC_PREFLAGS:STRING=${SB_MPIEXEC_PREFLAGS}
  -DMPI_CXX_COMPILE_FLAGS:STRING=${SB_MPI_CXX_COMPILE_FLAGS}
  -DMPI_CXX_INCLUDE_PATH:STRING=${SB_MPI_CXX_INCLUDE_PATH}
  -DMPI_CXX_LIBRARIES:STRING=${SB_MPI_CXX_LIBRARIES}
  -DMPI_CXX_LINK_FLAGS:STRING=${SB_MPI_CXX_LINK_FLAGS}
  -DMPI_C_COMPILE_FLAGS:STRING=${SB_MPI_C_COMPILE_FLAGS}
  -DMPI_C_INCLUDE_PATH:STRING=${SB_MPI_C_INCLUDE_PATH}
  -DMPI_C_LIBRARIES:STRING=${SB_MPI_C_LIBRARIES}
  -DMPI_C_LINK_FLAGS:STRING=${SB_MPI_C_LINK_FLAGS}
  -DMPI_EXTRA_LIBRARY:STRING=${SB_MPI_EXTRA_LIBRARY})
