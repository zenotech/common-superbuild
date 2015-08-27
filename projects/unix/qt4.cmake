list(APPEND qt4_extra_depends
  freetype
  fontconfig
  png)
list(APPEND qt4_extra_options
  -system-libpng
  -I <INSTALL_DIR>/include/freetype2
  -I <INSTALL_DIR>/include/fontconfig)
list(APPEND qt4_extra_arguments
  # Fix Qt build failure with GCC 4.1.
  "${CMAKE_COMMAND}" -E copy_if_different
    "${CMAKE_CURRENT_LIST_DIR}/patches/qt4.src.3rdparty.webkit.Source.WebKit.pri"
    <SOURCE_DIR>/src/3rdparty/webkit/Source/WebKit.pri)

include(qt4.common)

if (NOT superbuild_is_64bit)
  # On 32-bit builds, we are incorrectly ending with QT_POINTER_SIZE chosen as
  # 8 (instead of 4) with GCC4.1 toolchain on old debians. This patch overcomes
  # that.
  superbuild_project_add_step(qt4-patch-configure
    COMMAND "${CMAKE_COMMAND}" -E copy_if_different
            "${CMAKE_CURRENT_LIST_DIR}/patches/qt4.configure"
            <SOURCE_DIR>/configure
    DEPENDEES update
    DEPENDERS patch)
endif ()
