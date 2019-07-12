set(package_name python)
set(version 2.7.15)
include(python2.bundle.common)

superbuild_windows_install_program(python
  "bin"
  SEARCH_DIRECTORIES "bin")

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
  DESTINATION "bin/libs")

include(python2.functions)
superbuild_install_superbuild_python2()
