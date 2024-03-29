superbuild_python_version_check(pythoncryptography
  "3.5" "0" # Unsupported
  "3.6" "40.0.2"
  "3.7" "41.0.3")

get_property(pythoncryptography_source GLOBAL
  PROPERTY pythoncryptography_source)

if (pythoncryptography_source)
  superbuild_add_project_python(pythoncryptography
    PACKAGE
      cryptography
    DEPENDS
      pythonsetuptools
      pythoncffi
      pythonsetuptoolsrust
      pythonsemanticversion
    LICENSE_FILES
      LICENSE.APACHE
    SPDX_LICENSE_IDENTIFIER
      Apache-2.0
    SPDX_COPYRIGHT_TEXT
      "Copyright individual cryptography developers"
    )
else ()
  superbuild_add_project_python_wheel(pythoncryptography
    DEPENDS
      pythonsetuptools
      pythoncffi
      pythonpycparser
      pythontoml
    LICENSE_FILES_WHEEL
      cryptography-${pythoncryptography_SOURCE_SELECTION}.dist-info/LICENSE
      cryptography-${pythoncryptography_SOURCE_SELECTION}.dist-info/LICENSE.APACHE
    SPDX_LICENSE_IDENTIFIER
      Apache-2.0
    SPDX_COPYRIGHT_TEXT
      "Copyright individual cryptography developers"
    )
endif ()
