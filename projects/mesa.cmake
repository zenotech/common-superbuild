set(mesa_type_args -Dosmesa=false)
set(mesa_type_deps)
set(mesa_has_glx 0)
if (APPLE)
  set(mesa_has_glx 1)
  list(APPEND mesa_type_args
    -Dglx=xlib)
elseif (UNIX)
  set(mesa_has_glx 1)
  list(APPEND mesa_type_args
    -Dplatforms=x11
    -Dglx=xlib)
  list(APPEND mesa_type_deps
    glproto)
else ()
  list(APPEND mesa_type_args
    -Dplatforms=windows)
endif ()
include(mesa.common)

if (WIN32)
  set(mesa_library libGL.lib)
elseif (BUILD_SHARED_LIBS)
  if (APPLE)
    set(mesa_library libGL.dylib)
  else ()
    set(mesa_library libGL.so)
  endif ()
else ()
  set(mesa_library libGL.a)
endif ()

superbuild_add_extra_cmake_args(
  -DOPENGL_INCLUDE_DIR:PATH=<INSTALL_DIR>/include
  -DOPENGL_xmesa_INCLUDE_DIR:PATH=<INSTALL_DIR>/include
  -DOPENGL_gl_LIBRARY:FILEPATH=<INSTALL_DIR>/lib/${mesa_library}
  -DOpenGL_GL_PREFERENCE:STRING=LEGACY
  -DOPENGL_egl_LIBRARY:FILEPATH=
  -DOPENGL_glx_LIBRARY:FILEPATH=
  -DOPENGL_opengl_LIBRARY:FILEPATH=
  -DOPENGL_EGL_INCLUDE_DIR:FILEPATH=
  -DOPENGL_GLX_INCLUDE_DIR:FILEPATH=
  -DOPENGL_xmesa_INCLUDE_DIR:FILEPATH=
  )
