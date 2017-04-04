superbuild_add_project_python(h5py
  DEPENDS pythonsetuptools hdf5 numpy pythonpkgconfig pythonsix cython
  CONFIGURE_COMMAND
    "${superbuild_python_executable}"
      setup.py
      configure
      --hdf5 <INSTALL_DIR>)
