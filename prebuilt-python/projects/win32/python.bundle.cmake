set(package_name python)
set(version 2.7.3)
include(python.bundle.common)

superbuild_windows_install_program(python "")

# Install the headers and library.
install(
  DIRECTORY   "${superbuild_install_location}/bin/Include/"
  DESTINATION "include/python2.7")
install(
  DIRECTORY   "${superbuild_install_location}/bin/Include"
  DESTINATION "bin")
install(
  FILES       "${superbuild_install_location}/lib/python27.lib"
  DESTINATION "lib")
install(
  FILES       "${superbuild_install_location}/lib/python27.lib"
  DESTINATION "bin/Lib")

include(python.functions)
superbuild_install_superbuild_python()
