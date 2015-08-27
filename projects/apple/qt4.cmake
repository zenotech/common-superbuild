# Set the platform to be clang if on apple and not gcc
# This doesn't work on 10.5 (leopard) 10.6 (snow leopard) toolchain, however.
# So, we check for that.
if (CMAKE_CXX_COMPILER_ID STREQUAL "Clang" AND
    CMAKE_OSX_DEPLOYMENT_TARGET AND
    CMAKE_OSX_DEPLOYMENT_TARGET VERSION_GREATER "10.6")
  list(APPEND qt4_extra_options
    -platform unsupported/macx-clang)
endif ()

list(APPEND qt4_extra_options
  -sdk ${CMAKE_OSX_SYSROOT}
  -arch ${CMAKE_OSX_ARCHITECTURES}
  -qt-libpng)

include(qt4.common)

# corewlan .pro file needs to be patched to find
superbuild_project_add_step(qt4-patch-corewlan
  COMMAND "${CMAKE_COMMAND}" -E copy_if_different
          "${CMAKE_CURRENT_LIST_DIR}/patches/qt4.src.plugins.bearer.corewlan.corewlan.pro"
          <SOURCE_DIR>/src/plugins/bearer/corewlan/corewlan.pro
  DEPENDEES configure
  DEPENDERS build)

# Patch for modal dialog errors on 10.9 and up
# See https://bugreports.qt-project.org/browse/QTBUG-37699?focusedCommentId=251106#comment-251106
superbuild_project_add_step(qt4-patch-modal-dialogs
  COMMAND "${CMAKE_COMMAND}" -E copy_if_different
          "${CMAKE_CURRENT_LIST_DIR}/patches/qt4.src.gui.kernel.qeventdispatcher_mac.mm"
          <SOURCE_DIR>/src/gui/kernel/qeventdispatcher_mac.mm
  DEPENDEES configure
  DEPENDERS build)
