set(qt5_SKIP_PCH "ON" CACHE BOOL "")

if ("$ENV{CI_JOB_NAME}" MATCHES "windows")
  set(superbuild_replace_uncacheable_flags ON CACHE BOOL "")
endif ()

# Linux replaces `CC` and `CXX`
if (NOT "$ENV{CI_JOB_NAME}" MATCHES "linux")
  set(CMAKE_C_COMPILER_LAUNCHER "sccache" CACHE STRING "")
  set(CMAKE_CXX_COMPILER_LAUNCHER "sccache" CACHE STRING "")
endif ()
