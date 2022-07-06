file(INSTALL sqlite3.exe sqlite3.dll
    DESTINATION "${install_location}/bin")
file(INSTALL sqlite3.lib
    DESTINATION "${install_location}/lib")
file(INSTALL sqlite3.h sqlite3ext.h sqlite3rc.h
    DESTINATION "${install_location}/include")
