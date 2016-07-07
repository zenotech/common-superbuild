set(package_name python)
set(version 2.7.2)
include(python.bundle.common)

superbuild_windows_install_program(python "")

include(python.functions)
superbuild_install_superbuild_python()
