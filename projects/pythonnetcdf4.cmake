set(pythonnetcdf4_environment)
if (szip_enabled)
  list(APPEND pythonnetcdf4_environment
    SZIP_DIR <INSTALL_DIR>)
endif ()
if (libjpegturbo_enabled)
  list(APPEND pythonnetcdf4_environment
    JPEG_DIR <INSTALL_DIR>)
endif ()
if (mpi_enabled AND MPI_C_INCLUDE_PATH)
  list(APPEND pythonnetcdf4_environment
    MPI_INCDIR "${MPI_C_INCLUDE_PATH}")
endif ()

superbuild_add_project_python(pythonnetcdf4
  PACKAGE
    netCDF4
  DEPENDS
    pythonsetuptools
    pythoncftime
    pythoncython
    numpy

    netcdf
    hdf5
    zlib
  DEPENDS_OPTIONAL
    szip
    libjpegturbo
    mpi
    pythonmpi4py
  PROCESS_ENVIRONMENT
    HDF5_DIR    <INSTALL_DIR>
    NETCDF4_DIR <INSTALL_DIR>
    SZIP_DIR    <INSTALL_DIR>
    ${pythonnetcdf4_environment}
  LICENSE_FILES
    LICENSE
  SPDX_LICENSE_IDENTIFIER
    "MIT"
  SPDX_COPYRIGHT_TEXT
    "Copyright 2008 Jeffrey Whitaker"
  )

superbuild_apply_patch(pythonnetcdf4 no-certifi
  "Remove certifi usage")

# https://github.com/Unidata/netcdf4-python/pull/1304
superbuild_apply_patch(pythonnetcdf4 szip-libname
  "Fix libname for szip on Windows")

# https://github.com/Unidata/netcdf4-python/pull/1305
superbuild_apply_patch(pythonnetcdf4 msmpi-fix
  "Fix MSMPI compilation")
