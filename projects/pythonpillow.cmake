set(pythonpillow_process_environment)
if (WIN32)
  list(APPEND pythonpillow_process_environment
    INCLUDE "<INSTALL_DIR>/include"
    LIB     "<INSTALL_DIR>/lib")
endif ()

superbuild_add_project_python(pythonpillow
  PACKAGE
    PIL
  DEPENDS
    pythonsetuptools
    libjpegturbo
  LICENSE_FILES
    LICENSE
  SPDX_LICENSE_IDENTIFIER
    HPND
  SPDX_COPYRIGHT_TEXT
    "Copyright © 1997-2011 by Secret Labs AB"
    "Copyright © 1995-2011 by Fredrik Lundh"
    "Copyright © 2010-2023 by Jeffrey A. Clark (Alex) and contributors"
  PROCESS_ENVIRONMENT
    ${pythonpillow_process_environment})
