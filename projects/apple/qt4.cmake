set(qt4_extra_options)

# Set the platform to be clang if on apple and not gcc
# This doesn't work on 10.5 (leopard) 10.6 (snow leopard) toolchain, however.
# So, we check for that.
if (CMAKE_CXX_COMPILER_ID MATCHES "Clang" AND
    CMAKE_OSX_DEPLOYMENT_TARGET AND
    CMAKE_OSX_DEPLOYMENT_TARGET VERSION_GREATER "10.6")
  list(APPEND qt4_extra_options
    -platform unsupported/macx-clang)
endif ()

list(APPEND qt4_extra_options
  -qt-libpng)

if (CMAKE_OSX_SYSROOT)
  list(APPEND qt4_extra_options
    -sdk "${CMAKE_OSX_SYSROOT}")
endif ()

if (CMAKE_OSX_ARCHITECTURES)
  list(APPEND qt4_extra_options
    -arch "${CMAKE_OSX_ARCHITECTURES}")
endif ()

include(qt4.common)

# corewlan .pro file needs to be patched to find newer OS X versions.
superbuild_apply_patch(qt4 corewlan-new-osx
  "Fix corewlan to be able to detect newer OS X SDK versions")

# Patch for modal dialog errors on 10.9 and up
# See https://bugreports.qt-project.org/browse/QTBUG-37699?focusedCommentId=251106#comment-251106
superbuild_project_add_step(qt4-patch-modal-dialogs
  COMMAND "${CMAKE_COMMAND}" -E copy_if_different
          "${CMAKE_CURRENT_LIST_DIR}/patches/qt4.src.gui.kernel.qeventdispatcher_mac.mm"
          <SOURCE_DIR>/src/gui/kernel/qeventdispatcher_mac.mm
  DEPENDEES configure
  DEPENDERS build)
