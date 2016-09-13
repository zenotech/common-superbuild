set(package_name numpy)
set(version 1.8.1)
include(python.bundle.common)

# Install the headers and library.
install(
  DIRECTORY   "${superbuild_install_location}/bin/Lib/site-packages/numpy/core/include"
  DESTINATION "bin/Lib/site-packages/numpy/core/")
install(
  DIRECTORY   "${superbuild_install_location}/bin/Lib/site-packages/numpy/core/lib"
  DESTINATION "bin/Lib/site-packages/numpy/core/")
install(
  DIRECTORY   "${superbuild_install_location}/bin/Lib/site-packages/numpy/f2py/src"
  DESTINATION "bin/Lib/site-packages/numpy/f2py/")
install(
  DIRECTORY   "${superbuild_install_location}/bin/Lib/site-packages/numpy/numarray/include"
  DESTINATION "bin/Lib/site-packages/numpy/numarray/")

set(modules numpy)
include(python.package.bundle)
