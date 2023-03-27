# FIXME: need to use static llvm libs when appropriate

set(mesa_common_config_args
  --libdir lib
  --buildtype=release
  --prefix=<INSTALL_DIR>
  -Dauto_features=disabled
  -Dgallium-drivers=swrast
  -Dvulkan-drivers=
  -Ddri-drivers=
  -Dshared-glapi=enabled
  -Degl=disabled
  -Dllvm=enabled
  -Dgles1=disabled
  -Dgles2=disabled)

if (WIN32)
  list(APPEND mesa_common_config_args
    -Dshared-llvm=disabled)
else ()
  list(APPEND mesa_common_config_args
    -Dshared-llvm=enabled)
endif ()

if (CMAKE_CXX_COMPILER_ID MATCHES "Intel")
  superbuild_append_flags(
    c_flags "-diag-disable=279,557,10006"
    PROJECT_ONLY)
  superbuild_append_flags(
    cxx_flags "-diag-disable=177,279,557,873,10006"
    PROJECT_ONLY)
endif ()

set(mesa_platform_deps)
if (NOT WIN32)
  list(APPEND mesa_platform_deps
    expat)
endif ()

superbuild_add_project(${project}
  CAN_USE_SYSTEM
  DEPENDS llvm zlib ${mesa_type_deps} ${mesa_platform_deps} pythonmako meson python3
          flexbison
  LICENSE_FILES
    docs/license.rst
  CONFIGURE_COMMAND
    ${meson_command}
      ${mesa_common_config_args}
      ${mesa_type_args}
      build
  BUILD_COMMAND
    ${superbuild_ninja_command} -C build
  INSTALL_COMMAND
    ${superbuild_ninja_command} -C build install
  BUILD_IN_SOURCE 1)

superbuild_append_flags(ld_flags
  "-Wl,-rpath,<INSTALL_DIR>/lib"
  PROJECT_ONLY)
