superbuild_add_project_python(pythontwisted
  DEPENDS pythonsetuptools pythonconstantly pythonhyperlink pythonincremental pythonzopeinterface)

superbuild_apply_patch(pythontwisted macos-ssl
  "Fix issues with using really old OpenSSL on macOS")
