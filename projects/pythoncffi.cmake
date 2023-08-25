set(pythoncffi_depends)
set(pythoncffi_env)
if (UNIX)
  list(APPEND pythoncffi_depends
    pkgconf ffi)
  list(APPEND pythoncffi_env
    PKG_CONFIG ${superbuild_pkgconf})
endif ()

superbuild_add_project_python(pythoncffi
  PACKAGE cffi
  DEPENDS pythonsetuptools ${pythoncffi_depends}
  LICENSE_FILES LICENSE
  PROCESS_ENVIRONMENT ${pythoncffi_env})
