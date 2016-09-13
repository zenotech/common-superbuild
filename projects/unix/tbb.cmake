if (superbuild_is_64bit)
  set(tbb_archdir intel64)
else ()
  set(tbb_archdir ia32)
endif ()

set(tbb_libdir "lib/${tbb_archdir}/gcc4.4")
set(tbb_libsuffix "${CMAKE_SHARED_LIBRARY_SUFFIX}*")
include(tbb.common)

superbuild_apply_patch(tbb gcc5x-warning-fix
  "Tell TBB about GCC 5.1 stdlib support")
