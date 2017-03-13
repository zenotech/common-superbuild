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

# Patch for supporing newer Xcode versions.
superbuild_apply_patch(qt4 selection-flags-static_cast
  "Fix modal dialog state management for 10.9 and up")

# Query the version of the SDK being used
set(qt4_OSX_SDK_VERSION "" CACHE INTERNAL "")

if(NOT qt4_OSX_SDK_VERSION)

  # Use SDK version "macosx" unless another is explicitly chosen
  set(sdk "macosx")
  if (${CMAKE_OSX_SYSROOT})
    set(sdk ${CMAKE_OSX_SYSROOT})
  endif()

  execute_process(
    COMMAND xcodebuild -sdk ${sdk} -version SDKVersion
    RESULT_VARIABLE res
    OUTPUT_VARIABLE sdk_version
    OUTPUT_STRIP_TRAILING_WHITESPACE)
  if (res)
    message(FATAL_ERROR "${CMAKE_OSX_SYSROOT} is not a valid SDK.")
  endif ()
  if(sdk_version)
    message(STATUS "Identified OS X SDK version: ${sdk_version}")
    set(qt4_OSX_SDK_VERSION ${sdk_version})
  else()
    # If detecting Xcode version failed, set a crazy high version so we default
    # to the newest.
    set(qt4_OSX_SDK_VERSION 99)
    message(WARNING "Failed to detect the SDK version of an installed copy of Xcode, falling back to highest supported version.")
  endif()
endif()

# Patch for supporting OS X 10.12 and up. See
# https://gist.github.com/ejtttje/7163a9ced64f12ae9444
if (NOT qt4_OSX_SDK_VERSION VERSION_LESS 10.12)
  superbuild_apply_patch(qt4 osx-10.12-colorspace
    "Update qpaintengine to avoid using classes that were removed in 10.12.")
endif ()
