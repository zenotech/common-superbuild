set(package_name pywin32)
set(version 220)
include(python.bundle.common)

set(modules
  adodbapi
  isapi
  pythoncom
  win32com)
include(python.package.bundle)

install(
  DIRECTORY   "${superbuild_install_location}/bin/Lib/site-packages/pywin32_system32"
  DESTINATION "bin/Lib/site-packages"
  COMPONENT   "superbuild")
install(
  DIRECTORY   "${superbuild_install_location}/bin/Lib/site-packages/win32"
  DESTINATION "bin/Lib/site-packages"
  COMPONENT   "superbuild")
install(
  FILES       "${superbuild_install_location}/bin/Lib/site-packages/pywin32.pth"
              "${superbuild_install_location}/bin/Lib/site-packages/pywin32.version.txt"
  DESTINATION "bin/Lib/site-packages"
  COMPONENT   "superbuild")
