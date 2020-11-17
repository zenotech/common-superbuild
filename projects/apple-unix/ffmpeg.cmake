if (BUILD_SHARED_LIBS)
  set(ffmpeg_shared_args --enable-shared --disable-static)
else ()
  set(ffmpeg_shared_args --disable-shared --enable-static)
endif ()

set(ffmpeg_c_flags "${superbuild_c_flags}")
if (APPLE AND CMAKE_OSX_SYSROOT)
  string(APPEND ffmpeg_c_flags " --sysroot=${CMAKE_OSX_SYSROOT}")
endif ()
set(ffmpeg_ld_flags "${superbuild_ld_flags}")
if (APPLE AND CMAKE_OSX_DEPLOYMENT_TARGET)
  string(APPEND ffmpeg_ld_flags " -isysroot ${CMAKE_OSX_SYSROOT} -mmacosx-version-min=${CMAKE_OSX_DEPLOYMENT_TARGET}")
endif ()

superbuild_add_project(ffmpeg
  DEPENDS zlib
  CONFIGURE_COMMAND
    <SOURCE_DIR>/configure
      --prefix=<INSTALL_DIR>
      --disable-avdevice
      --disable-bzlib
      --disable-decoders
      --disable-doc
      --disable-ffplay
      --disable-ffprobe
      --disable-ffserver
      --disable-network
      --disable-yasm
      ${ffmpeg_shared_args}
      --cc=${CMAKE_C_COMPILER}
      "--extra-cflags=${ffmpeg_c_flags}"
      "--extra-ldflags=${ffmpeg_ld_flags}"
  BUILD_COMMAND
    $(MAKE)
  INSTALL_COMMAND
    make install
  BUILD_IN_SOURCE 1)
