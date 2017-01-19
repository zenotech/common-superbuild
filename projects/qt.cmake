if (qt_enabled AND NOT (qt4_enabled OR qt5_enabled))
  message(FATAL_ERROR
    "Qt is enabled, but neither Qt4 nor Qt5 has been enabled.")
endif ()

superbuild_add_dummy_project(qt
  DEPENDS_OPTIONAL qt4 qt5)

set(qt_version)
if (qt4_enabled)
  set(qt_version 4)
elseif (qt5_enabled)
  set(qt_version 5)
endif ()
