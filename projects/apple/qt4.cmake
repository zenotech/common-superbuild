set(qt4_extra_options)

# Set the platform to be clang if on OS X and not GCC.
if (CMAKE_CXX_COMPILER_ID MATCHES "Clang")
  if (cxx11_enabled)
    list(APPEND qt4_extra_options
      -platform unsupported/macx-clang-libc++)
  else ()
    list(APPEND qt4_extra_options
      -platform unsupported/macx-clang)
  endif ()
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

# Patch for modal dialog errors on 10.9 and up See
# https://bugreports.qt-project.org/browse/QTBUG-37699?focusedCommentId=251106#comment-251106
superbuild_apply_patch(qt4 osx-10.9-modal-dialogs
  "Fix modal dialog state management for 10.9 and up")
