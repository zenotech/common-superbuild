file(INSTALL
  ${output_location}/python.exe
  DESTINATION "${install_location}/bin")
file(INSTALL
  ${output_location}/python27.dll
  DESTINATION "${install_location}/bin")
file(INSTALL
  ${output_location}/python27.lib
  DESTINATION "${install_location}/lib")

# Includes
file(INSTALL
  ${source_location}/Include/
  DESTINATION "${install_location}/include")
file(INSTALL
  ${source_location}/PC/pyconfig.h
  DESTINATION "${install_location}/include")

# Modules
file(INSTALL
  ${source_location}/Lib/
  DESTINATION "${install_location}/bin/Lib")
file(INSTALL
  ${output_location}/
  DESTINATION "${install_location}/bin/Lib"
  FILES_MATCHING
    PATTERN "*.pyd")

# Build tree structure
file(INSTALL
  ${source_location}/Include/
  DESTINATION "${install_location}/bin/Include")
file(INSTALL
  ${source_location}/PC/pyconfig.h
  DESTINATION "${install_location}/bin/Include")
file(INSTALL
  ${output_location}/python27.lib
  DESTINATION "${install_location}/bin/Libs")
