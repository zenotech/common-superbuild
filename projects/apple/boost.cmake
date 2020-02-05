include("${CMAKE_CURRENT_LIST_DIR}/../boost.common.cmake")

# Patch reqiured to build boost 1.71 on macOS 10.13
cmake_host_system_information(RESULT os_release QUERY OS_RELEASE)
if (os_release VERSION_GREATER "10.13" AND os_release VERSION_LESS "10.14")
  superbuild_apply_patch(boost-iostreams pull103
    "Patch boost for macOS 10.13"
  )
endif()
