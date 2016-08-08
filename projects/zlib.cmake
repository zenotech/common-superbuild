superbuild_add_project(zlib
  CAN_USE_SYSTEM
  CMAKE_ARGS
    -DBUILD_SHARED_LIBS:BOOL=${BUILD_SHARED_LIBS})

# Remove the zconf.h file since the CMake build doesn't work with it.
superbuild_apply_patch(zlib remove-zconf.h
  "Remove zconf.h for the CMake build")

# zlib needs a fix for '--version-script' linker option. The option needs to be
# removed on Macs.
superbuild_apply_patch(zlib version-script
  "Remove --version-script linker argument on OS X")
