# Add option to build qtsvg, on by default for svg icon support
option(qt6_ENABLE_SVG "Build Qt6 SVG library." ON)
mark_as_advanced(qt6_ENABLE_SVG)

# Add option to build qtmultimedia, on by default
option(qt6_ENABLE_MULTIMEDIA "Build Qt6 Multimedia library." ON)
mark_as_advanced(qt6_ENABLE_MULTIMEDIA)

# Add option to build qtwebchannel, off by default
option(qt6_ENABLE_WEBCHANNEL "Build Qt6 Webchannel library." OFF)
mark_as_advanced(qt6_ENABLE_WEBCHANNEL)

# Add option to build qtwebengine, off by default
option(qt6_ENABLE_WEBENGINE "Build Qt6 Webengine library." OFF)
mark_as_advanced(qt6_ENABLE_WEBENGINE)

# Add option to build qtwebsockets, off by default
option(qt6_ENABLE_WEBSOCKETS "Build Qt6 Websockets library." OFF)
mark_as_advanced(qt6_ENABLE_WEBSOCKETS)
