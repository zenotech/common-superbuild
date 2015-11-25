function (superbuild_osx_add_version_flags)
  if (NOT APPLE)
    return ()
  endif ()

  set(osx_flags)
  if (CMAKE_OSX_ARCHITECTURES)
    list(APPEND osx_flags
      -arch "${CMAKE_OSX_ARCHITECTURES}")
  endif ()
  if (CMAKE_OSX_DEPLOYMENT_TARGET)
    list(APPEND osx_flags
      "-mmacosx-version-min=${CMAKE_OSX_DEPLOYMENT_TARGET}")
  endif ()
  if (CMAKE_OSX_SYSROOT)
    list(APPEND osx_flags
      "--sysroot=${CMAKE_OSX_SYSROOT}")
  endif ()
  string(REPLACE ";" " " osx_flags "${osx_flags}")

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
    -DCMAKE_OSX_SYSROOT:PATH=${CMAKE_OSX_SYSROOT}
    -DCMAKE_OSX_SDK:STRING=${CMAKE_OSX_SDK}
    PARENT_SCOPE)
endfunction ()

set(superbuild_fixup_bundle "${CMAKE_CURRENT_LIST_DIR}/scripts/fixup_bundle.py")
