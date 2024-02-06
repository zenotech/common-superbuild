set(USE_SYSTEM_python3 ON CACHE BOOL "")

set(meson_SOURCE_SELECTION "0.61.5" CACHE STRING "")
set(numpy_SOURCE_SELECTION "1.19.5" CACHE STRING "")
set(pythonaiosignal_SOURCE_SELECTION "1.2.0" CACHE STRING "")
set(pythonchardet_SOURCE_SELECTION "5.0.0" CACHE STRING "")
set(pythoncppy_SOURCE_SELECTION "1.1.0" CACHE STRING "")
set(pythoncryptography_SOURCE_SELECTION "40.0.2" CACHE STRING "")
set(pythonfonttools_SOURCE_SELECTION "4.27.1" CACHE STRING "")
set(pythonfrozenlist_SOURCE_SELECTION "1.2.0" CACHE STRING "")
set(pythonkiwisolver_SOURCE_SELECTION "1.2.0" CACHE STRING "")
set(pythonmako_SOURCE_SELECTION "1.1.6" CACHE STRING "")
set(pythonpackaging_SOURCE_SELECTION "21.3" CACHE STRING "")
set(pythonpathspec_SOURCE_SELECTION "0.9.0" CACHE STRING "")
set(pythonpluggy_SOURCE_SELECTION "1.0.0" CACHE STRING "")
set(pythonpygments_SOURCE_SELECTION "2.14.0" CACHE STRING "")
set(pythonsetuptools_SOURCE_SELECTION "58.5.3" CACHE STRING "")
set(pythonsetuptoolsscm_SOURCE_SELECTION "6.4.2" CACHE STRING "")
set(pythonsetuptoolsrust_SOURCE_SELECTION "1.1.2" CACHE STRING "")
set(pythontomli_SOURCE_SELECTION "1.2.3" CACHE STRING "")
set(pythontypingextensions_SOURCE_SELECTION "4.1.1" CACHE STRING "")
set(pythonwheel_SOURCE_SELECTION "0.37.1" CACHE STRING "")
set(sympy_SOURCE_SELECTION "1.9" CACHE STRING "")

# Compiler is too old; turn off bits that require C++17.
set(ENABLE_cxx17 OFF CACHE BOOL "")
set(ENABLE_openxrsdk OFF CACHE BOOL "")
set(ENABLE_openimagedenoise OFF CACHE BOOL "") # doesn't support GCC 4.8.5
set(ENABLE_seacas OFF CACHE BOOL "")
set(ENABLE_utillinux OFF CACHE BOOL "") # doesn't support GCC 4.8.5

# Not supported by Python 3.6.
set(ENABLE_pythoncontourpy OFF CACHE BOOL "")
set(ENABLE_pythonhatchling OFF CACHE BOOL "")
set(ENABLE_pythonpandas OFF CACHE BOOL "")
set(ENABLE_pythonpyprojectmetadata OFF CACHE BOOL "")
set(ENABLE_scipy OFF CACHE BOOL "")

set(ENABLE_fontconfig OFF CACHE BOOL "") # Requires utillinux
set(ENABLE_matplotlib OFF CACHE BOOL "") # Requires pythoncontourpy
set(ENABLE_ospray OFF CACHE BOOL "") # Requires openimagedenoise
set(ENABLE_pythonaiohttp OFF CACHE BOOL "") # Requires pythonattrs
set(ENABLE_pythonattrs OFF CACHE BOOL "") # Requires pythonhatchling
set(ENABLE_pythonhatchfancypypireadme OFF CACHE BOOL "") # Requires pythonhatchling
set(ENABLE_pythonhatchvcs OFF CACHE BOOL "") # Requires pythonhatchling
set(ENABLE_pythonmesonpython OFF CACHE BOOL "") # Requires pythonpyprojectmetadata
set(ENABLE_pythonwslinkasync OFF CACHE BOOL "") # Requires pythonaiohttp

# Not interested in testing here.
set(ENABLE_llvm OFF CACHE BOOL "")
set(ENABLE_mesa OFF CACHE BOOL "")
set(ENABLE_osmesa OFF CACHE BOOL "")
set(ENABLE_qt5 OFF CACHE BOOL "")

include("${CMAKE_CURRENT_LIST_DIR}/configure_common.cmake")
