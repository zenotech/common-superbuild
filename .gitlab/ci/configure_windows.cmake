file(TO_CMAKE_PATH "$ENV{CI_PROJECT_DIR}/.gitlab/qt" cmake_qt_prefix)
set(CMAKE_PREFIX_PATH "${cmake_qt_prefix}" CACHE STRING "")

set(qt5_ENABLE_WEBENGINE "OFF" CACHE STRING "") # Not installed on Windows CI

include("${CMAKE_CURRENT_LIST_DIR}/configure_common.cmake")
