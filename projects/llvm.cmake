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
  list(APPEND llvm_cmake_shared_flags
    -DBUILD_SHARED_LIBS:BOOL=${BUILD_SHARED_LIBS})
else ()
  # Force usage of the shared runtime.
  list(APPEND llvm_cmake_shared_flags
    -DCMAKE_MSVC_RUNTIME_LIBRARY:STRING=MultiThreadedDLL
    -DCMAKE_POLICY_DEFAULT_CMP0091:STRING=NEW)
endif ()

superbuild_add_project(llvm
  CAN_USE_SYSTEM
  DEPENDS python3 cxx17
  LICENSE_FILES
    llvm/LICENSE.TXT
    llvm/lib/Support/COPYRIGHT.regex
    llvm/test/YAMLParser/LICENSE.txt
  SOURCE_SUBDIR llvm
  CMAKE_ARGS
    -DCMAKE_BUILD_TYPE:STRING=Release
    ${llvm_cmake_shared_flags}
    -DCMAKE_INSTALL_PREFIX:PATH=<INSTALL_DIR>
    -DLLVM_ENABLE_RTTI:BOOL=ON
    -DLLVM_INSTALL_UTILS:BOOL=ON
    -DLLVM_ENABLE_LIBXML2:BOOL=OFF
    -DLLVM_ENABLE_BINDINGS:BOOL=OFF
    -DLLVM_INCLUDE_BENCHMARKS:BOOL=OFF
    -DLLVM_INCLUDE_EXAMPLES:BOOL=OFF
    -DLLVM_INCLUDE_RUNTIMES:BOOL=OFF
    -DLLVM_INCLUDE_TESTS:BOOL=OFF
    -DLLVM_INCLUDE_UTILS:BOOL=OFF
    -DLLVM_TARGETS_TO_BUILD:STRING=${llvm_TARGETS_TO_BUILD}
    -DPYTHON_EXECUTABLE:FILEPATH=${superbuild_python_executable})

set(llvm_dir "<INSTALL_DIR>")
