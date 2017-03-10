if (NOT superbuild_use_prebuilt_python)
  superbuild_set_revision(python
    URL     "http://paraview.org/files/dependencies/Python-2.7.3.tgz"
    URL_MD5 2cf641732ac23b18d139be077bd906cd)
endif ()
