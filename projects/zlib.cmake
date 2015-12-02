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

# zlib needs a fix for '--version-script' linker option. The option needs to be
# removed on Macs.
superbuild_apply_patch(zlib version-script
  "Remove --version-script linker argument on OS X")
