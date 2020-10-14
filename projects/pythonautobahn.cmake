superbuild_add_project_python(pythonautobahn
  PACKAGE autobahn
  DEPENDS pythonsetuptools pythonsix pythontwisted pythontxaio pythonzopeinterface)

# https://github.com/crossbario/autobahn-python/commit/897c349952ead7f69f6e720183a2b4c17987a64b
superbuild_apply_patch(pythonautobahn python3.8
  "Support for Python 3.8")
