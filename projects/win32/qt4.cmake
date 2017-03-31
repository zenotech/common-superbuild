set(qt4_extra_options)

# Set the silence flag to remove a warning in 2015 that is really an error.
if (NOT MSVC_VERSION VERSION_LESS 1900)
  list(APPEND qt4_extra_options
    -D _SILENCE_STDEXT_HASH_DEPRECATION_WARNINGS)
endif ()

include(qt4.common)

# see https://connect.microsoft.com/VisualStudio/feedback/details/1424082/vs2015-rc-c-compiler-mixes-up-template-parameter-with-identical-named-inherited-typedef
superbuild_apply_patch(qt4 VS2015
  "Replace reserved variables that conflict with VS2015")
