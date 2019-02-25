set(package_name numpy)
set(version 1.15.1)
include(python.bundle.common)

set(numpy_egg_name
  "numpy-${version}-py2.7-win-amd64.egg")
set(numpy_egg_dir
  "bin/Lib/site-packages/${numpy_egg_name}")

# Install the headers and library.
install(
  DIRECTORY   "${superbuild_install_location}/${numpy_egg_dir}/numpy/core/include"
  DESTINATION "bin/Lib/site-packages/numpy/core/")
install(
  DIRECTORY   "${superbuild_install_location}/${numpy_egg_dir}/numpy/core/lib"
  DESTINATION "bin/Lib/site-packages/numpy/core/")
install(
  DIRECTORY   "${superbuild_install_location}/${numpy_egg_dir}/numpy/f2py/src"
  DESTINATION "bin/Lib/site-packages/numpy/f2py/")

set(modules numpy)
list(APPEND python_extra_modules_directories
  "${superbuild_install_location}/${numpy_egg_dir}")
include(python.package.bundle)
