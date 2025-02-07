include(qt6.options)

if (qt6_ENABLE_SVG)
  list(APPEND qt6_components Svg)
endif ()

if (qt5_ENABLE_MULTIMEDIA)
  list(APPEND qt6_components Multimedia)
endif ()

if (qt6_ENABLE_WEBCHANNEL)
  list(APPEND qt6_components WebChannel)
endif ()

if (qt6_ENABLE_WEBENGINE)
  list(APPEND qt6_components WebEngine)
endif ()

if (qt6_ENABLE_WEBSOCKETS)
  list(APPEND qt6_components WebSockets)
endif ()

find_package(Qt6 REQUIRED
  COMPONENTS
    Core
    ${qt6_components})

superbuild_add_extra_cmake_args(
  -DQt6_DIR:PATH=${Qt6_DIR}
  -DQt6Core_DIR:PATH=${Qt6_DIR}/../Qt6Core)

foreach (qt6_component IN LISTS qt6_components)
  superbuild_add_extra_cmake_args(
    -DQt6${qt6_component}_DIR:PATH=${Qt6_DIR}/../Qt6${qt6_component})
endforeach ()

if (UNIX)
  get_filename_component(qt6_rpath "${Qt6_DIR}/../.." REALPATH)
endif ()

if (WIN32)
  # support python testing in the build tree
  get_filename_component(qt6_dllpath "${Qt6_DIR}/../../../bin" REALPATH)
endif()
