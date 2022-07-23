file(INSTALL windows/vs${vs_version}/Release/x64/liblzma_dll/liblzma.dll
    DESTINATION "${install_location}/bin")
file(INSTALL windows/vs${vs_version}/Release/x64/liblzma_dll/liblzma.lib
    DESTINATION "${install_location}/lib")
file(INSTALL src/liblzma/api/lzma src/liblzma/api/lzma.h
    DESTINATION "${install_location}/include")
