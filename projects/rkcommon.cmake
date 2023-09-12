superbuild_add_project(rkcommon
  LICENSE_FILES
    LICENSE.txt
  DEPENDS cxx11 tbb
  CMAKE_ARGS
     -DBUILD_TESTING:BOOL=OFF
     -DCMAKE_INSTALL_LIBDIR:STRING=lib
     -DCMAKE_INSTALL_NAME_DIR:PATH=<INSTALL_DIR>/lib
     -DINSTALL_DEPS:BOOL=OFF
     -DCMAKE_INSTALL_RPATH=<INSTALL_DIR>/lib
     # Disable SIMD support here. This avoids setting floating point rounding
     # mode to "towards zero" which ends up making `numpy` unimportable on
     # macOS x86_64 (but almost certainly affects it on other Intel-based
     # platforms).
     # See: https://github.com/numpy/numpy/issues/20895
     # See: https://github.com/ospray/rkcommon/issues/9
     -DRKCOMMON_NO_SIMD:BOOL=ON
)

if (ospray_SOURCE_SELECTION STREQUAL "2.12.0")
  # https://github.com/ospray/rkcommon/pull/10
  superbuild_apply_patch(rkcommon force-no-simd
    "Force SIMD off even with TBB")
endif ()
