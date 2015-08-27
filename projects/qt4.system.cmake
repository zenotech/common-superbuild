find_package(Qt4 REQUIRED)

superbuild_add_extra_cmake_args(
  -DQT_QMAKE_EXECUTABLE:FILEPATH=${QT_QMAKE_EXECUTABLE})
