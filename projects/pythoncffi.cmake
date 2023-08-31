set(pythoncffi_depends)
if (UNIX)
  list(APPEND pythoncffi_depends
    pkgconf ffi)
endif ()

superbuild_add_project_python(pythoncffi
  PACKAGE cffi
  DEPENDS pythonsetuptools ${pythoncffi_depends}
  LICENSE_FILES LICENSE)
