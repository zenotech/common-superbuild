list(APPEND qt4_extra_depends
  freetype
  fontconfig
  png)
list(APPEND qt4_extra_options
  -system-libpng
  -I <INSTALL_DIR>/include/freetype2
  -I <INSTALL_DIR>/include/fontconfig)

include(qt4.common)

superbuild_apply_patch(qt4 webkit-gcc-4.1
  "Remove -Werror from WebKit build")

if (NOT superbuild_is_64bit)
  # On 32-bit builds, we are incorrectly ending with QT_POINTER_SIZE chosen as
  # 8 (instead of 4) with GCC4.1 toolchain on old debians. This patch overcomes
  # that.
  superbuild_apply_patch(qt4 qt-pointer-size
    "Fix GCC 4.1 configure check failure")
endif ()
