set(llvm_TARGETS_TO_BUILD ""
  CACHE STRING "Codegen architectures for llvm (leave empty for host cpu)")
mark_as_advanced(llvm_TARGETS_TO_BUILD)

# This lookup table is taken from a subset of architectures targeted by the
# superbuild from the llvm source in cmake/config-ix.cmake
if (NOT llvm_TARGETS_TO_BUILD)
  if ((CMAKE_SYSTEM_PROCESSOR MATCHES "i[2-6]86") OR
      (CMAKE_SYSTEM_PROCESSOR STREQUAL "x86") OR
      (CMAKE_SYSTEM_PROCESSOR STREQUAL "amd64") OR
      (CMAKE_SYSTEM_PROCESSOR STREQUAL "AMD64") OR
      (CMAKE_SYSTEM_PROCESSOR STREQUAL "x86_64"))
    set_property(CACHE llvm_TARGETS_TO_BUILD PROPERTY VALUE "X86")
  elseif (CMAKE_SYSTEM_PROCESSOR MATCHES "sparc")
    set_property(CACHE llvm_TARGETS_TO_BUILD PROPERTY VALUE "Sparc")
  elseif ((CMAKE_SYSTEM_PROCESSOR MATCHES "powerpc") OR
          (CMAKE_SYSTEM_PROCESSOR MATCHES "ppc64le"))
    set_property(CACHE llvm_TARGETS_TO_BUILD PROPERTY VALUE "PowerPC")
  elseif ((CMAKE_SYSTEM_PROCESSOR MATCHES "aarch64") OR
          (CMAKE_SYSTEM_PROCESSOR MATCHES "arm64"))
    set_property(CACHE llvm_TARGETS_TO_BUILD PROPERTY VALUE "AArch64")
  elseif (CMAKE_SYSTEM_PROCESSOR MATCHES "arm")
    set_property(CACHE llvm_TARGETS_TO_BUILD PROPERTY VALUE "ARM")
  else ()
    message(FATAL_ERROR "Unsupported llvm target: ${CMAKE_SYSTEM_PROCESSOR}")
  endif ()
endif ()

if (CMAKE_CXX_COMPILER_ID MATCHES "Intel")
  superbuild_append_flags(
    c_flags   "-diag-disable=11074,11076"
    PROJECT_ONLY)
  superbuild_append_flags(
    cxx_flags "-diag-disable=68,177,188,191,597,654,873,1098,1125,1292,1875,2026,3373,3656,3884,11074,11076"
    PROJECT_ONLY)
endif ()

set(llvm_cmake_shared_flags)
if (NOT WIN32)
  # LLVM errors if told anything about this on Windows.
  set(llvm_BUILD_SHARED_LIBS "<SAME>"
    CACHE STRING "Build LLVM as static or shared")
  set_property(CACHE llvm_BUILD_SHARED_LIBS
    PROPERTY
      STRINGS "<SAME>;ON;OFF")
  if (llvm_BUILD_SHARED_LIBS STREQUAL "<SAME>")
    set(llvm_BUILD_SHARED_LIBS "${BUILD_SHARED_LIBS}")
  endif ()
  list(APPEND llvm_cmake_shared_flags
    -DBUILD_SHARED_LIBS:BOOL=${llvm_BUILD_SHARED_LIBS})
  if (llvm_BUILD_SHARED_LIBS)
    set(llvm_is_shared 1)
  else ()
    set(llvm_is_shared 0)
  endif ()
else ()
  # Force usage of the shared runtime.
  list(APPEND llvm_cmake_shared_flags
    -DCMAKE_MSVC_RUNTIME_LIBRARY:STRING=MultiThreadedDLL
    -DCMAKE_POLICY_DEFAULT_CMP0091:STRING=NEW)
  set(llvm_is_shared 0)
endif ()

set(llvm_version "${llvm_version_${llvm_SOURCE_SELECTION}}")

set(llvm_depends_7.0.0
  cxx11)
set(llvm_depends_15.0.6
  cxx17)

set(llvm_licenses_7.0.0
  LICENSE.TXT
  lib/Support/COPYRIGHT.regex
  test/YAMLParser/LICENSE.txt
  lib/Target/ARM/LICENSE.TXT)
set(llvm_licenses_15.0.6
  llvm/LICENSE.TXT
  llvm/lib/Support/COPYRIGHT.regex
  llvm/test/YAMLParser/LICENSE.txt)

set(llvm_source_args_7.0.0)
set(llvm_source_args_15.0.6
  SOURCE_SUBDIR llvm)

set(llvm_configure_args_7.0.0
  -DPYTHON_EXECUTABLE:FILEPATH=${superbuild_python_executable}
  -DLLVM_INCLUDE_UTILS:BOOL=ON)
set(llvm_configure_args_15.0.6
  -DLLVM_INCLUDE_TESTS:BOOL=OFF
  -DLLVM_INCLUDE_UTILS:BOOL=OFF)

set(llvm_depends ${llvm_depends_${llvm_version}})
set(llvm_licenses ${llvm_licenses_${llvm_version}})
if (superbuild_build_phase)
  if (NOT llvm_licenses)
    message(FATAL_ERROR
      "Unknown licenses for LLVM licenses version ${llvm_version}")
  endif ()
endif ()
set(llvm_source_args ${llvm_source_args_${llvm_version}})
set(llvm_configure_args ${llvm_configure_args_${llvm_version}})

superbuild_add_project(llvm
  CAN_USE_SYSTEM
  DEPENDS python3 ${llvm_depends}
  LICENSE_FILES
    ${llvm_licenses}
  ${llvm_source_args}
  CMAKE_ARGS
    # Handle rpath settings
    -DCMAKE_INSTALL_RPATH:STRING=:

    -DCMAKE_BUILD_TYPE:STRING=Release
    ${llvm_cmake_shared_flags}
    -DCMAKE_INSTALL_PREFIX:PATH=<INSTALL_DIR>
    -DCMAKE_INSTALL_NAME_DIR:STRING=<INSTALL_DIR>/lib
    -DLLVM_ENABLE_RTTI:BOOL=ON
    -DLLVM_INSTALL_UTILS:BOOL=ON
    -DLLVM_ENABLE_LIBXML2:BOOL=OFF
    -DLLVM_ENABLE_BINDINGS:BOOL=OFF
    -DLLVM_INCLUDE_BENCHMARKS:BOOL=OFF
    -DLLVM_INCLUDE_EXAMPLES:BOOL=OFF
    -DLLVM_INCLUDE_RUNTIMES:BOOL=OFF
    ${llvm_configure_args}
    -DLLVM_TARGETS_TO_BUILD:STRING=${llvm_TARGETS_TO_BUILD}
    -DPython3_EXECUTABLE:FILEPATH=${superbuild_python_executable})

set(llvm_dir "<INSTALL_DIR>")

if (llvm_version VERSION_LESS_EQUAL "7.0.0")
  # https://github.com/spack/spack/pull/22516
  superbuild_apply_patch(llvm intel
    "Fix ambiguous namespace reference with Intel compiler")
endif ()

superbuild_apply_patch(llvm ${llvm_version}-no-force-install-name-dir
  "Don't force using the install name dir in the build tree")
