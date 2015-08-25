superbuild_add_project(zlib
  CAN_USE_SYSTEM
  # zlib supports CMake. The only problem is that we need to remove the zconf.h
  # file.
  PATCH_COMMAND
    "${CMAKE_COMMAND}" -E remove
    -f
    "<SOURCE_DIR>/zconf.h"
  CMAKE_ARGS
    -DBUILD_SHARED_LIBS:BOOL=${BUILD_SHARED_LIBS})

#-------------------------------------------------------
# zlib needs a fix for '--version-script' linker option. The option needs to be
# removed on Macs. The fix to CMakeLists.txt works for all OSs.
superbuild_project_add_step(zlib-patch-CMakeLists.txt
  COMMAND "${CMAKE_COMMAND}" -E copy_if_different
          "${CMAKE_CURRENT_LIST_DIR}/patches/zlib.CMakeLists.txt"
          "<SOURCE_DIR>/CMakeLists.txt"
  DEPENDEES update
  DEPENDERS patch)
