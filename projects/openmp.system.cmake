set(openmp_components "CXX")
if (fortran_enabled)
  list(APPEND openmp_components "Fortran")
endif()
find_package(OpenMP REQUIRED COMPONENTS ${openmp_components})
