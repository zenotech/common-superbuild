#[==[.md INTERNAL
# Utility functions
This module contains a cmake script to generate a SPDX file from
the template.spdx.in for a specific project
#]==]

if (NOT SOURCE_DIR)
  message(FATAL_ERROR "A SOURCE_DIR should be provided")
endif ()
if (NOT OUTPUT_DIR)
  message(FATAL_ERROR "An OUTPUT_DIR should be provided")
endif ()
if (NOT SPDX_PACKAGE_NAME)
  message(FATAL_ERROR "A SPDX_PACKAGE_NAME should be provided")
endif ()
if (NOT SPDX_DOCUMENT_NAMESPACE)
  message(FATAL_ERROR "A SPDX_DOCUMENT_NAMESPACE should be provided")
endif ()
if (NOT SPDX_LICENSE)
  message(FATAL_ERROR "A SPDX_LICENSE should be provided")
endif ()
if (NOT SPDX_COPYRIGHT_TEXT)
  message(FATAL_ERROR "A SPDX_COPYRIGHT_TEXT should be provided")
endif ()
if (NOT SPDX_DOWNLOAD_LOCATION)
  message(FATAL_ERROR "A SPDX_DOWNLOAD_LOCATION should be provided")
endif ()

# Recover generic spdx information
string(TIMESTAMP spdx_creation_time "%Y-%m-%dT%H:%M:%SZ")
if (SPDX_CUSTOM_LICENSE_FILE)
  if (NOT SPDX_CUSTOM_LICENSE_NAME)
    message(FATAL_ERROR "A SPDX_CUSTOM_LICENSE_NAME is expected with a SPDX_CUSTOM_LICENSE_FILE")
  endif ()
  if (NOT IS_ABSOLUTE "${SPDX_CUSTOM_LICENSE_FILE}")
    set(SPDX_CUSTOM_LICENSE_FILE "${SOURCE_DIR}/${SPDX_CUSTOM_LICENSE_FILE}")
  endif ()
  file(READ ${SPDX_CUSTOM_LICENSE_FILE} spdx_package_custom_license_text)
  set(spdx_package_custom_license_part "
LicenseID: ${SPDX_CUSTOM_LICENSE_NAME}
ExtractedText: <text>${spdx_package_custom_license_text}</text>
")
endif ()

get_filename_component(superbuild_cmake_directory ${CMAKE_SCRIPT_MODE_FILE} DIRECTORY)
configure_file(
  "${superbuild_cmake_directory}/template.spdx.in"
  "${OUTPUT_DIR}/${SPDX_PACKAGE_NAME}.spdx"
  @ONLY)
