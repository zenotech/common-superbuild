include(qt5.options)

if (qt5_ENABLE_SVG)
  list(APPEND qt5_components Svg)
endif ()

if (qt5_ENABLE_MULTIMEDIA)
  list(APPEND qt5_components Multimedia)
endif ()

if (qt5_ENABLE_WEBCHANNEL)
  list(APPEND qt5_components WebChannel)
endif ()

if (qt5_ENABLE_WEBENGINE)
  list(APPEND qt5_components WebEngine)
endif ()

if (qt5_ENABLE_WEBSOCKETS)
  list(APPEND qt5_components WebSockets)
endif ()

find_package(Qt5 REQUIRED
  COMPONENTS
    Core
    ${qt5_components})

superbuild_add_extra_cmake_args(
  -DQt5_DIR:PATH=${Qt5_DIR}
  -DQt5Core_DIR:PATH=${Qt5_DIR}/../Qt5Core)

foreach (qt5_component IN LISTS qt5_components)
  superbuild_add_extra_cmake_args(
    -DQt5${qt5_component}_DIR:PATH=${Qt5_DIR}/../Qt5${qt5_component})
endforeach ()

if (APPLE)
  get_filename_component(qt5_rpath "${Qt5_DIR}/../.." REALPATH)
endif ()

if (WIN32)
  # support python testing in the build tree
  get_filename_component(qt5_dllpath "${Qt5_DIR}/../../../bin" REALPATH)
endif()
