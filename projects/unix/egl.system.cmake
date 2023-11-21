find_package(EGL REQUIRED)

# This will add EGL_INCLUDE_DIR, EGL_LIBRARY, GL_gldispatch_LIBRARY and EGL_opengl_LIBRARY
# variables. User can set/override these to change then whenever needed.
superbuild_add_extra_cmake_args(
  -DEGL_INCLUDE_DIR:PATH=${EGL_INCLUDE_DIR}
  -DEGL_LIBRARY:FILEPATH=${EGL_LIBRARY}
  -DEGL_gldispatch_LIBRARY:FILEPATH=${EGL_gldispatch_LIBRARY}
  -DEGL_opengl_LIBRARY:FILEPATH=${EGL_opengl_LIBRARY})
