superbuild_add_project(python2
  MUST_USE_SYSTEM)

set(superbuild_python_version "2.7")

file(MAKE_DIRECTORY
  "${superbuild_install_location}/lib/python2.7/site-packages")
