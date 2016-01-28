if (CMAKE_OSX_SDK)
  list(APPEND qt5_extra_options
    -sdk ${CMAKE_OSX_SDK})
else()
  message(ERROR "Please set the CMAKE_OSX_SDK to use in Qt's build")
endif()

list(APPEND qt5_extra_options
  -qt-libpng)

include(qt5.common)

# Modal dialog problems
# https://bugreports.qt.io/browse/QTBUG-40585
superbuild_apply_patch(qt5 osx-10.9-modal-dialog
  "Fix modal dialog state management for 10.9 and up")
