find_package(Qt4 REQUIRED)

superbuild_add_extra_cmake_args(
  -DQT_QMAKE_EXECUTABLE:FILEPATH=${QT_QMAKE_EXECUTABLE})

get_filename_component(qt4_path "${QT_QMAKE_EXECUTABLE}" DIRECTORY)
superbuild_add_path("${qt4_path}")
