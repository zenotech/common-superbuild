file(GLOB files "*")
file(INSTALL ${files}
     DESTINATION "${install_location}")
