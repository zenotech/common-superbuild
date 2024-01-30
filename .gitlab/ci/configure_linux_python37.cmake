set(USE_SYSTEM_python3 ON CACHE BOOL "")

set(numpy_SOURCE_SELECTION "1.19.5" CACHE STRING "") # 1.21.6 available; broken?
set(pythoncontourpy_SOURCE_SELECTION "1.0.6" CACHE STRING "")
set(pythonfonttools_SOURCE_SELECTION "4.38.0" CACHE STRING "")
set(pythonfrozenlist_SOURCE_SELECTION "1.3.3" CACHE STRING "")
set(pythonhatchling_SOURCE_SELECTION "1.17.1" CACHE STRING "")
set(pythonpluggy_SOURCE_SELECTION "1.2.0" CACHE STRING "")
set(pythonsetuptools_SOURCE_SELECTION "67.8.0" CACHE STRING "")
set(sympy_SOURCE_SELECTION "1.10.1" CACHE STRING "")

# Not supported by Python 3.7.
set(ENABLE_matplotlib OFF CACHE BOOL "")
set(ENABLE_pythonpandas OFF CACHE BOOL "")
set(ENABLE_scipy OFF CACHE BOOL "")

# Not interested in testing here.
set(ENABLE_llvm OFF CACHE BOOL "")
set(ENABLE_mesa OFF CACHE BOOL "")
set(ENABLE_osmesa OFF CACHE BOOL "")
set(ENABLE_qt5 OFF CACHE BOOL "")

include("${CMAKE_CURRENT_LIST_DIR}/configure_common.cmake")
