list(APPEND qt5_extra_options
  -sdk ${CMAKE_OSX_SDK}
  -qt-libpng)

include(qt5.common)

# modal dialog problems
# https://bugreports.qt.io/browse/QTBUG-40585
superbuild_project_add_step(qt5-patch-qcocoaeventdispatcher
  COMMAND "${CMAKE_COMMAND" -E copy_if_different
          "${CMAKE_CURRENT_LIST_DIR}/patches/qt5.qtbase.plugins.platforms.cocoa.qcocoaeventdispatcher.mm"
          <SOURCE_DIR>/qtbase/plugins/platforms/cocoa/qcocoaeventdispatcher.mm
  DEPENDEES configure
  DEPENDERS build)
