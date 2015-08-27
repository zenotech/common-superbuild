superbuild_add_project(bzip2
  CAN_USE_SYSTEM
  CMAKE_ARGS
    -DBUILD_SHARED_LIBS:BOOL=${BUILD_SHARED_LIBS})

#-------------------------------------------------------
# bzip2 needs a fix for '--version-script' linker option. The option needs to be
# removed on Macs. The fix to CMakeLists.txt works for all OSs.
superbuild_project_add_step(bzip2-patch-CMakeLists.txt
  COMMAND ${CMAKE_COMMAND} -E copy_if_different
          "${CMAKE_CURRENT_LIST_DIR}/patches/bzip2.CMakeLists.txt"
          "<SOURCE_DIR>/CMakeLists.txt"
  DEPENDEES update
  DEPENDERS patch)
