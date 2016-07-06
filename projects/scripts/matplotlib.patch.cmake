# SOURCE_DIR matplotlib source directory
# PATCHES_DIR superbuild patches directory
# INSTALL_DIR superbuild install prefix

# Matplotlib expects these libraries to be named differently on Windows...
if (WIN32)
  configure_file(
    "${INSTALL_DIR}/lib/zlib.lib"
    "${INSTALL_DIR}/lib/z.lib"
    COPYONLY)
  configure_file(
    "${INSTALL_DIR}/lib/libpng16.lib"
    "${INSTALL_DIR}/lib/png.lib"
    COPYONLY)
endif ()

configure_file(
  "${PATCHES_DIR}/matplotlib.setup.cfg.in"
  "${SOURCE_DIR}/setup.cfg")
