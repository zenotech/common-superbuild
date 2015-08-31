function (superbuild_osx_determine_target)
  if (NOT APPLE)
    return ()
  endif ()

  set(CMAKE_OSX_ARCHITECTURES "x86_64"
    CACHE STRING "By default, build for 64-bit Leopard")

  if (NOT CMAKE_OSX_SDK)
    execute_process(
      COMMAND   xcrun
                --show-sdk-version
      OUTPUT_VARIABLE
                CMAKE_OSX_SDK
      RESULT_VARIABLE
                res
      OUTPUT_STRIP_TRAILING_WHITESPACE)
    if (res)
      message(FATAL_ERROR "Failed to detect CMAKE_OSX_SDK; please set manually (e.g., \"macosx10.9\").")
    endif ()
  endif ()

  if (NOT CMAKE_OSX_SYSROOT)
    execute_process(
      COMMAND xcodebuild
              -sdk "${CMAKE_OSX_SDK}"
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
              -sdk "${CMAKE_OSX_SDK}"
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
endfunction ()

function (superbuild_osx_add_version_flags)
  if (NOT APPLE)
    return ()
  endif ()

  set(osx_flags
    "-arch ${CMAKE_OSX_ARCHITECTURES} -mmacosx-version-min=${CMAKE_OSX_DEPLOYMENT_TARGET} --sysroot=${CMAKE_OSX_SYSROOT}")

  foreach (var cxx_flags c_flags)
    set("superbuild_${var}"
      "${superbuild_${var}} ${osx_flags}"
      PARENT_SCOPE)
  endforeach ()
endfunction ()

function (superbuild_osx_pass_version_flags var)
  if (NOT APPLE)
    return ()
  endif ()

  set("${var}"
    -DCMAKE_OSX_ARCHITECTURES:STRING=${CMAKE_OSX_ARCHITECTURES}
    -DCMAKE_OSX_DEPLOYMENT_TARGET:STRING=${CMAKE_OSX_DEPLOYMENT_TARGET}
    -DCMAKE_OSX_SYSROOT:STRING=${CMAKE_OSX_SYSROOT}
    -DCMAKE_OSX_SDK:STRING=${CMAKE_OSX_SDK}
    PARENT_SCOPE)
endfunction ()

set(superbuild_fixup_bundle "${CMAKE_CURRENT_LIST_DIR}/scripts/fixup_bundle.py")
