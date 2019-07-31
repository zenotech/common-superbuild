file(INSTALL
  "${source_location}/objs/freetype.lib"
  DESTINATION "${install_location}/lib")
file(INSTALL
  "${source_location}/include/ft2build.h"
  DESTINATION "${install_location}/include/")
file(INSTALL
  "${source_location}/include/freetype"
  DESTINATION "${install_location}/include/")
