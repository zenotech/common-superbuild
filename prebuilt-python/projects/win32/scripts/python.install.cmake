file(INSTALL
  ${output_directory}/python.exe
  DESTINATION "${install_directory}/bin")
file(INSTALL
  ${output_directory}/python27.lib
  DESTINATION "${install_directory}/lib")

# Includes
file(INSTALL
  ${source_directory}/Include/
  DESTINATION "${install_directory}/include")
file(INSTALL
  ${source_directory}/PC/pyconfig.h
  DESTINATION "${install_directory}/include")

# Modules
file(INSTALL
  ${source_directory}/Lib/
  DESTINATION "${install_directory}/bin/Lib")
file(INSTALL
  ${output_directory}/
  DESTINATION "${install_directory}/bin/Lib"
  FILES_MATCHING
    PATTERN "*.pyd")

# Build tree structure
file(INSTALL
  ${source_directory}/Include/
  DESTINATION "${install_directory}/bin/Include")
file(INSTALL
  ${source_directory}/PC/pyconfig.h
  DESTINATION "${install_directory}/bin/Include")
file(INSTALL
  ${output_directory}/python27.lib
  DESTINATION "${install_directory}/bin/Libs")
