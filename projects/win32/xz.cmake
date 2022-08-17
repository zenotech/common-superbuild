# 11.0 and below unsupported anyways.
if (NOT MSVC_VERSION VERSION_GREATER 1700)
  message(FATAL_ERROR "At least Visual Studio 12.0 is required")
elseif (NOT MSVC_VERSION VERSION_GREATER 1800)
  set(xz_vs_version 2015)
elseif (NOT MSVC_VERSION VERSION_GREATER 1900)
  set(xz_vs_version 2017)
elseif (NOT MSVC_VERSION VERSION_GREATER 1930)
  set(xz_vs_version 2019)
elseif (NOT MSVC_VERSION VERSION_GREATER 1932)
  set(xz_vs_version 2019) # actually 2022, but this should work
else ()
  message(FATAL_ERROR "Unrecognized MSVC version: ${MSVC_VERSION}")
endif ()

superbuild_add_project(xz
  LICENSE_FILES
    COPYING.LGPLv2.1
  CONFIGURE_COMMAND ""
  BUILD_COMMAND
    msbuild
      "windows\\\\vs${xz_vs_version}\\\\liblzma_dll.vcxproj"
      -p:Configuration=Release
  INSTALL_COMMAND
    "${CMAKE_COMMAND}"
      -Dinstall_location=<INSTALL_DIR>
      -Dvs_version=${xz_vs_version}
      -P "${CMAKE_CURRENT_LIST_DIR}/scripts/xz.install.cmake"
  BUILD_IN_SOURCE 1)
