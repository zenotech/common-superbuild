set(mesa_swr_arch "")
list(APPEND mesa_drivers
  swrast)

if (mesa_SOURCE_SELECTION STREQUAL "21.2.1")
  set(mesa_swr_default ON)
  if (DEFINED MESA_SWR_ENABLED)
    message(WARNING
      "The MESA_SWR_ENABLED setting is deprecated in favor of mesa_USE_SWR.")
    set(mesa_swr_default "${MESA_SWR_ENABLED}")
  endif ()

  option(mesa_USE_SWR "Enable the OpenSWR driver" "${mesa_swr_default}")
  mark_as_advanced(mesa_USE_SWR)

  set(mesa_swr_arch_default)
  set(mesa_swr_arch_options)
  # Intel compilers
  if (CMAKE_HOST_SYSTEM_PROCESSOR STREQUAL "x86_64" OR
      CMAKE_HOST_SYSTEM_PROCESSOR STREQUAL "AMD64")
    set(mesa_swr_arch_default "avx,avx2")
    list(APPEND mesa_swr_arch_options
      ""
      "avx" "avx2" "knl" "skx"
      "avx,avx2" "avx2,knl" "knl,skx"
      "avx,avx2,knl" "avx,avx2,skx"
      "avx,avx2,knl,skx")
  endif ()

  if (mesa_swr_arch_options)
    if (NOT mesa_swr_arch_default IN_LIST mesa_swr_arch_options)
      string(REPLACE ";" "`, `" mesa_swr_arch_options_string "${mesa_swr_arch_options}")
      message(FATAL_ERROR
        "Default for `mesa_SWR_ARCH` (${mesa_swr_arch_default}) is not valid "
        "(`${mesa_swr_arch_options_string}`).")
    endif ()

    set(mesa_SWR_ARCH "${mesa_swr_arch_default}"
      CACHE STRING "backend architectures to be used by the SWR driver")
    mark_as_advanced(mesa_USE_SWR_ARCH)
    set_property(CACHE mesa_SWR_ARCH PROPERTY STRINGS
      ${mesa_swr_arch_options})

    if (mesa_enabled AND NOT mesa_SWR_ARCH IN_LIST mesa_swr_arch_options)
      string(REPLACE ";" "`, `" mesa_swr_arch_options_string "${mesa_swr_arch_options}")
      message(FATAL_ERROR
        "The requested `mesa_SWR_ARCH` (${mesa_SWR_ARCH}) is not valid "
        "(`${mesa_swr_arch_options_string}`).")
    endif ()
  else ()
    set(mesa_SWR_ARCH "")
  endif ()

  if (mesa_USE_SWR AND mesa_SWR_ARCH)
    list(APPEND mesa_drivers swr)
    set(mesa_swr_arch "-Dswr-arches=${mesa_SWR_ARCH}")
  endif ()
endif ()

string(REPLACE ";" "," mesa_drivers "${mesa_drivers}")

# FIXME: need to use static llvm libs when appropriate

set(mesa_common_config_args
  --libdir lib
  --buildtype=release
  --prefix=<INSTALL_DIR>
  ${mesa_swr_arch}
  -Dauto_features=disabled
  -Dzstd=disabled
  -Dgallium-drivers=${mesa_drivers}
  -Dvulkan-drivers=
  -Dshared-glapi=enabled
  -Degl=disabled
  -Dllvm=enabled
  -Dgles1=disabled
  -Dgles2=disabled)

if (mesa_SOURCE_SELECTION STREQUAL "21.2.1" OR
    mesa_SOURCE_SELECTION STREQUAL "22.3.3")
  list(APPEND mesa_common_config_args
    -Ddri-drivers=)
endif()

if (NOT llvm_is_shared)
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

set(mesa_environment)
if (WIN32)
  list(APPEND mesa_environment
    PATH <INSTALL_DIR>/Python
    PATH <INSTALL_DIR>/bin)
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
  BUILD_IN_SOURCE 1
  PROCESS_ENVIRONMENT
    ${mesa_environment})

superbuild_append_flags(ld_flags
  "-Wl,-rpath,<INSTALL_DIR>/lib"
  PROJECT_ONLY)
