get_property(pythoncryptography_source GLOBAL
  PROPERTY pythoncryptography_source)

if (pythoncryptography_source)
  superbuild_add_project_python(pythoncryptography
    PACKAGE cryptography
    DEPENDS pythonsetuptools pythoncffi pythonsetuptoolsrust pythonsemanticversion
    LICENSE_FILES LICENSE.APACHE)
else ()
  superbuild_add_project_python_wheel(pythoncryptography
    DEPENDS pythonsetuptools pythoncffi pythonpycparser pythontoml
    LICENSE_FILES_WHEEL
      cryptography-${pythoncryptography_version}.dist-info/LICENSE
      cryptography-${pythoncryptography_version}.dist-info/LICENSE.APACHE
    )
endif ()
