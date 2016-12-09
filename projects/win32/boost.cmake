set(boost_extra_options)

# 8.0 and below unsupported anyways.
if (MSVC90)
  set(msvc_ver 9.0)
elseif (MSVC10)
  set(msvc_ver 10.0)
elseif (MSVC11)
  set(msvc_ver 11.0)
elseif (MSVC12)
  set(msvc_ver 12.0)
elseif (MSVC13)
  set(msvc_ver 13.0)
elseif (MSVC14)
  set(msvc_ver 14.0)
elseif (MSVC15)
  set(msvc_ver 15.0)
else ()
  message(FATAL_ERROR "Unrecognized MSVC version")
endif ()

list(APPEND boost_extra_options
  "--toolset=msvc-${msvc_ver}")

if (superbuild_is_64bit)
  list(APPEND boost_extra_options
    address-model=64)
else ()
  list(APPEND boost_extra_options
    address-model=32)
endif ()

include(boost.common)

# This patch is applied so that a rogue junction is not left inside of the
# build tree for dashboard machines. CMake cannot delete such files, so we just
# remove the code which creates such things here.
superbuild_apply_patch(boost no-junction-test
  "Assume junctions work on Windows")

superbuild_project_add_step(boost-copylibs
  COMMAND   "${CMAKE_COMMAND}"
            -Dinstall_location:PATH=<INSTALL_DIR>
            -P "${CMAKE_CURRENT_LIST_DIR}/scripts/boost.copylibs.cmake"
  DEPENDEES install
  COMMENT   "Copy .dll files to the bin/ directory"
  WORKING_DIRECTORY <SOURCE_DIR>)
