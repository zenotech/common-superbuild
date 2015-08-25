cmake_minimum_required(VERSION 2.8.9)

project(common-superbuild)

list(INSERT CMAKE_MODULE_PATH 0
  "${CMAKE_CURRENT_LIST_DIR}/cmake")

if (APPLE)
  if(NOT CMAKE_OSX_DEPLOYMENT_TARGET)
    set(CMAKE_OSX_ARCHITECTURES "x86_64" CACHE STRING "By default, build for 64-bit Leopard")
  endif()

  if (CMAKE_OSX_SDK)
    if (NOT CMAKE_OSX_SYSROOT)
      execute_process(
        COMMAND xcodebuild
                -sdk ${CMAKE_OSX_SDK}
                -version Path
        OUTPUT_VARIABLE
                CMAKE_OSX_SYSROOT
        RESULT_VARIABLE
                res
        OUTPUT_STRIP_TRAILING_WHITESPACE)
      if (res)
        message(FATAL_ERROR "Cannot determine SDK path for SDK: ${CMAKE_OSX_SDK}")
      endif ()
    endif ()
    if (NOT CMAKE_OSX_DEPLOYMENT_TARGET)
      execute_process(
        COMMAND xcodebuild
                -sdk ${CMAKE_OSX_SDK}
                -version SDKVersion
        OUTPUT_VARIABLE
                CMAKE_OSX_DEPLOYMENT_TARGET
        RESULT_VARIABLE
                res
        OUTPUT_STRIP_TRAILING_WHITESPACE)
      if (res)
        message(FATAL_ERROR "Cannot determine SDK version for SDK: ${CMAKE_OSX_SDK}")
      endif ()
    endif ()
  else ()
    message(FATAL_ERROR "Ensure that CMAKE_OSX_SDK is set correctly")
  endif ()
endif()

set (SuperBuild_CMAKE_DIR "${CMAKE_CURRENT_SOURCE_DIR}/CMake")
set (SuperBuild_PROJECTS_DIR "${CMAKE_CURRENT_SOURCE_DIR}/Projects")
set (SuperBuild_BINARY_DIR ${ParaViewSuperBuild_BINARY_DIR})

# The external projects list separator string should be set ASAP so that
# anything else can use it that needs it.
set (ep_list_separator "-+-")

set (platform)
if (APPLE)
  set (platform "apple" "apple-unix")
elseif (UNIX)
  set (platform "unix" "apple-unix")
elseif (WIN32)
  set (platform "win32")
endif()

#-----------------------------------------------------------------------------
# Cross compilation
set (CROSS_BUILD_STAGE "HOST" CACHE STRING
  "Cross compilation stage: either HOST(ie no crosscompile)|TOOLS|CROSS")
set_property(CACHE CROSS_BUILD_STAGE PROPERTY STRINGS
   "HOST" "TOOLS" "CROSS")
if(CROSS_BUILD_STAGE STREQUAL "HOST")
  # Default to shared libs
  set(BUILD_SHARED_LIBS ON  CACHE BOOL "Enable shared libraries")
else()
  set(BUILD_SHARED_LIBS OFF CACHE BOOL "Enable shared libraries")
endif()

#-----------------------------------------------------------------------------
# Setup CMAKE_MODULE_PATH so that platform specific configurations are processed
# before the generic ones.
string(TOLOWER "${CROSS_BUILD_STAGE}" lstage)
set(SuperBuild_MODULE_PATH)
foreach(P IN LISTS platform)
  list(APPEND SuperBuild_MODULE_PATH "${SuperBuild_PROJECTS_DIR}/${P}/${lstage}")
  list(APPEND SuperBuild_MODULE_PATH "${SuperBuild_PROJECTS_DIR}/${P}/")
endforeach()
list(APPEND SuperBuild_MODULE_PATH "${SuperBuild_PROJECTS_DIR}/common/")
list(APPEND SuperBuild_MODULE_PATH "${SuperBuild_PROJECTS_DIR}")
list(APPEND SuperBuild_MODULE_PATH "${SuperBuild_CMAKE_DIR}")
list(APPEND SuperBuild_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}")
list(INSERT CMAKE_MODULE_PATH 0 ${SuperBuild_MODULE_PATH})

#-----------------------------------------------------------------------------
if (NOT CROSS_BUILD_STAGE STREQUAL "HOST")
  include(CrossCompilationMacros)

  #ask user to say what machine they are compiling onto
  #so we can get the right environment settings
  query_target_machine()

  if (CROSS_BUILD_STAGE STREQUAL "CROSS")
    #configure the platform dependent settings
    #64bit_build, static_only, mpi search path
    do_cross_platform_settings()

    #find location of hosttools or host build to get compilation tools from
    find_hosttools()
  endif()
endif()

#-----------------------------------------------------------------------------
# Collect information about the build platform.
include(CheckTypeSize)

if (NOT CROSS_BUILD_STAGE STREQUAL "CROSS")
  check_type_size(void* VOID_PTR_SIZE BUILTIN_TYPES_ONLY)
  if (VOID_PTR_SIZE EQUAL 8)
    set (64bit_build TRUE)
  else ()
    set (64bit_build FALSE)
  endif()
endif()


#-----------------------------------------------------------------------------
# Setup some standard variables that control various locations and flags.
set (install_location "${CMAKE_CURRENT_BINARY_DIR}/install")
set (download_location "${CMAKE_CURRENT_BINARY_DIR}/downloads"
     CACHE PATH "Location where source tar-balls are (to be) downloaded.")
mark_as_advanced(download_location)

if (WIN32)
  set (ldflags)
  set (cppflags)
  set (cxxflags)
  set (ld_library_path)
else ()
  # FIXME: currently, if any of these are empty, we have build issues on Unix.
  set (ldflags "$ENV{LDFLAGS} -L${install_location}/lib")
  if (NOT CROSS_BUILD_STAGE STREQUAL "CROSS")
    set (cppflags "$ENV{CPPFLAGS} -fPIC")
    set (cxxflags "$ENV{CXXFLAGS} -fPIC")
    set (cflags "$ENV{CFLAGS} -fPIC")
  endif()
  set (ld_library_path "${install_location}/lib:$ENV{LD_LIBRARY_PATH}")
endif()

#-----------------------------------------------------------------------------
# Make sure install/lib directories exist by creating them
# Windows doesn't like it if that directory does not exist even if it is empty
file(MAKE_DIRECTORY "${install_location}/lib")


if (UNIX AND NOT APPLE)
  # I am not exactly sure about the cause of these issues and how to cleanly
  # overcome them, however, on some linuxes when Cmake is built shared, we end
  # if we set LD_LIBRARY_PATH to the install/lib dir, we end up with errors
  # due to conflicts with system libz. So for now, I am making this an option.
  # By default we will let the superbuild scripts set LD_LIBRARY_PATH. However
  # if users get errors like: libz.so.1: no version information available, then
  # users should turn this flag off.
  option(PASS_LD_LIBRARY_PATH_FOR_BUILDS
         "Pass LD_LIBRARY_PATH to build scripts."
         ON)
  mark_as_advanced(PASS_LD_LIBRARY_PATH_FOR_BUILDS)
endif()

if (APPLE)
  set (cflags "${cflags} -arch x86_64 -mmacosx-version-min=${CMAKE_OSX_DEPLOYMENT_TARGET} --sysroot=${CMAKE_OSX_SYSROOT} ")
  set (cppflags "${cppflags} -arch x86_64 -mmacosx-version-min=${CMAKE_OSX_DEPLOYMENT_TARGET} --sysroot=${CMAKE_OSX_SYSROOT} ")
  set (cxxflags "${cxxflags} -arch x86_64 -mmacosx-version-min=${CMAKE_OSX_DEPLOYMENT_TARGET} --sysroot=${CMAKE_OSX_SYSROOT} ")
endif()
set (prefix_path "${install_location}")

# merge in default/user-specified CMake flags.
set (ldflags "${CMAKE_SHARED_LINKER_FLAGS} ${ldflags}")
set (cppflags "${CMAKE_CXX_FLAGS} ${cppflags}")
set (cxxflags "${CMAKE_CXX_FLAGS} ${cxxflags}")
set (cflags "${CMAKE_C_FLAGS} ${cflags}")

string (STRIP "${ldflags}" ldflags)
string (STRIP "${cppflags}" cppflags)
string (STRIP "${cxxflags}" cxxflags)
string (STRIP "${cflags}"  cflags)

include (ParaViewModules)

#-----------------------------------------------------------------------------
set (CM_PROJECTS_ALL)

process_dependencies()
