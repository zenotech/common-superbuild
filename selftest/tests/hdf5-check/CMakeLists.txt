cmake_minimum_required(VERSION 3.12)
project(hdf5-check C)

message(CTEST_FULL_OUTPUT)

function (check_target target)
  if (NOT TARGET "${target}")
    message(SEND_ERROR
      "Target `${target}` not defined.")
  endif ()
endfunction ()

find_package(HDF5 REQUIRED
  COMPONENTS C)
# HDF5's configuration file needs work.
find_package(SZIP REQUIRED)

if (with_mpi)
  find_package(MPI REQUIRED COMPONENTS C)
endif ()

check_target(HDF5::HDF5)

add_executable(hdf5test hdf5.c)
target_link_libraries(hdf5test PRIVATE HDF5::HDF5)

if (with_mpi)
  target_link_libraries(hdf5test PRIVATE MPI::MPI_C)
endif ()

if (TARGET szip-shared)
  check_target(szip-shared)
  target_link_libraries(hdf5test PRIVATE szip-shared)
else ()
  check_target(szip-static)
  target_link_libraries(hdf5test PRIVATE szip-static)
endif ()

include(CTest)
enable_testing()

add_test(NAME hdf5test COMMAND hdf5test)
