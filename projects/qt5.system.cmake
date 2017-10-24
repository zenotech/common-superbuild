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
