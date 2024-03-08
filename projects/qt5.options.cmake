# Add option to build qtsvg, on by default for svg icon support
option(qt5_ENABLE_SVG "Build Qt5 SVG library." ON)
mark_as_advanced(qt5_ENABLE_SVG)

# Add option to build qtmultimedia, on by default
option(qt5_ENABLE_MULTIMEDIA "Build Qt5 Multimedia library." ON)
mark_as_advanced(qt5_ENABLE_MULTIMEDIA)

# Add option to build qtwebengine, off by default
option(qt5_ENABLE_WEBENGINE "Build Qt5 Webengine library." OFF)
mark_as_advanced(qt5_ENABLE_WEBENGINE)
