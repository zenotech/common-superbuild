function (superbuild_osx_determine_target)
  if (NOT APPLE)
    return ()
  endif ()

  set(CMAKE_OSX_ARCHITECTURES "x86_64"
    CACHE STRING "By default, build for 64-bit Leopard")

  if (CMAKE_OSX_SDK)
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
  else ()
    message(FATAL_ERROR "Ensure that CMAKE_OSX_SDK is set correctly")
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
