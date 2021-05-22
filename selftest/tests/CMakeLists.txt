set(install_dir "${CMAKE_BINARY_DIR}/install")

if (APPLE)
  add_test(
    NAME apple-check-binaries
    COMMAND
      "${CMAKE_COMMAND}"
      "-Dinstall_dir=${install_dir}"
      "-Ddeployment_target=${CMAKE_OSX_DEPLOYMENT_TARGET}"
      "-Darch=${CMAKE_HOST_SYSTEM_PROCESSOR}"
      -P "${CMAKE_CURRENT_SOURCE_DIR}/apple-check.cmake")
endif ()

function (add_python_import_test package module)
  if (NOT TARGET "${package}")
    return ()
  endif ()

  if (TARGET "python3")
    set(test_prefix "python3")
  else ()
    set(test_prefix "python2")
  endif ()

  add_test(
    NAME "${test_prefix}-${package}-import-${module}"
    COMMAND
      "${superbuild_python_executable}"
      -c "import ${module}; import os; print(${module}.__file__.replace(os.sep, '/'))")
  if (NOT USE_SYSTEM_${package})
    set_property(TEST "${test_prefix}-${package}-import-${module}"
      PROPERTY
        PASS_REGULAR_EXPRESSION "${install_dir}")
  endif ()
endfunction ()

add_python_import_test(python3 this)
add_python_import_test(matplotlib matplotlib)
add_python_import_test(numpy numpy)
add_python_import_test(pythonattrs attr)
add_python_import_test(pythonautobahn autobahn)
add_python_import_test(pythoncffi cffi)
add_python_import_test(pythonconstantly constantly)
add_python_import_test(pythoncryptography cryptography)
add_python_import_test(pythoncycler cycler)
add_python_import_test(pythoncython cython)
add_python_import_test(pythondateutil dateutil)
add_python_import_test(pythonhyperlink hyperlink)
add_python_import_test(pythonincremental incremental)
add_python_import_test(pythonkiwisolver kiwisolver)
add_python_import_test(pythonpycparser pycparser)
add_python_import_test(pythonpygments pygments)
add_python_import_test(pythonpyparsing pyparsing)
add_python_import_test(pythonsemanticversion semantic_version)
add_python_import_test(pythonsetuptools setuptools)
add_python_import_test(pythonsetuptoolsscm setuptools_scm)
add_python_import_test(pythonsetuptoolsrust setuptools_rust)
add_python_import_test(pythonsix six)
add_python_import_test(pythontoml toml)
add_python_import_test(pythontwisted twisted)
add_python_import_test(pythontxaio txaio)
add_python_import_test(pythonwheel wheel)
add_python_import_test(pythonwslink wslink)
add_python_import_test(pythonzope App)
add_python_import_test(pythonzope OFS)
add_python_import_test(pythonzopeinterface zope.interface)
add_python_import_test(pytz pytz)
add_python_import_test(scipy scipy)

# Verify that Python3 support for ssl is removed from a built-in Python if not
# enabled.
add_python_import_test(python3 ssl)
if (NOT TARGET "openssl" AND NOT USE_SYSTEM_python3)
  # Require that the `_ssl` module is not found.
  set_property(TEST "python3-python3-import-ssl"
    PROPERTY
      PASS_REGULAR_EXPRESSION "ModuleNotFoundError: No module named '_ssl'")
endif ()
