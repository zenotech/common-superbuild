superbuild_add_project_python(pythontwisted
  PACKAGE twisted
  DEPENDS pythonsetuptools pythonconstantly pythonhyperlink pythonincremental pythonzopeinterface pythonattrs)

if (NOT (ENABLE_python3 OR python3_enabled))
  superbuild_apply_patch(pythontwisted macos-ssl
    "Fix issues with using really old OpenSSL on macOS")
endif ()
