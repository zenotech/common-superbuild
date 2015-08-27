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
else ()
  message(FATAL_ERROR "Unrecognized MSVC version")
endif ()

list(APPEND boost_extra_options
  --toolset=msvc-${msvc_ver})

include(boost.common)
