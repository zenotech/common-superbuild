if (qt_enabled AND NOT (qt5_enabled OR qt6_enabled))
  message(FATAL_ERROR
    "Qt is enabled, but neither Qt5 nor Qt6 has been enabled.")
endif ()

superbuild_add_dummy_project(qt
  DEPENDS_OPTIONAL qt5 qt6)

set(qt_version)
if (qt5_enabled)
  set(qt_version 5)
elseif (qt6_enabled)
  set(qt_version 6)
endif ()
