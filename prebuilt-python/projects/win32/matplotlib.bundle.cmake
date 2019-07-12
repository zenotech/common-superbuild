set(package_name matplotlib)
set(version 1.1.1)
include(python2.bundle.common)

set(modules matplotlib)
include(python2.package.bundle)

install(
  DIRECTORY   "${superbuild_install_location}/lib/site-packages/matplotlib/mpl-data/"
  DESTINATION "bin/Lib/site-packages/matplotlib/mpl-data"
  COMPONENT   superbuild)
