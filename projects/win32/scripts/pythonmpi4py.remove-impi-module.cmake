file(GLOB impi_files
  "${install_location}/Python/Lib/site-packages/mpi4py/MPI.mpi*-impi.*.pyd")

foreach (impi_file IN LISTS impi_files)
  message("Removing ${impi_file}")
  file(REMOVE "${impi_file}")
endforeach ()
