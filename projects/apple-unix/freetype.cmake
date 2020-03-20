if (BUILD_SHARED_LIBS)
  set(freetype_shared_args --enable-shared --disable-static)
else ()
  set(freetype_shared_args --disable-shared --enable-static)
endif ()

superbuild_add_project(freetype
  CAN_USE_SYSTEM
  DEPENDS zlib png
  CONFIGURE_COMMAND
    <SOURCE_DIR>/configure
      --prefix=<INSTALL_DIR>
      --with-harfbuzz=no
      ${shared_args}
      --with-sysroot=<INSTALL_DIR>
  BUILD_COMMAND
    $(MAKE)
  INSTALL_COMMAND
    $(MAKE) install)

# https://savannah.nongnu.org/bugs/?57206
superbuild_project_add_step(create-docs-reference-markdown
  COMMAND   "${CMAKE_COMMAND}"
            -E make_directory
            <SOURCE_DIR>/docs/reference/markdown
  DEPENDEES download
  DEPENDERS configure
  COMMENT   "Create docs/reference/markdown directory"
  WORKING_DIRECTORY <BINARY_DIR>)

if (APPLE AND __BUILDBOT_INSTALL_LOCATION)
  superbuild_project_add_step(clean-build
    COMMAND   make
              clean
    DEPENDEES configure
    DEPENDERS build
    COMMENT   "Cleaning the build tree for install name fixes"
    WORKING_DIRECTORY <BINARY_DIR>)
endif ()
