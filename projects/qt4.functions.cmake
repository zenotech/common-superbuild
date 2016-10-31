function (superbuild_install_qt4_plugin_paths output)
  if (USE_SYSTEM_qt4 AND UNIX)
    set(qt4_no_package_paths)
    if (APPLE)
      list(APPEND qt4_no_package_paths
        "/usr/lib")
    elseif (UNIX)
      list(APPEND qt4_no_package_paths
        "/lib"
        "/lib64"
        "/usr/lib"
        "/usr/lib64"
        "/usr/local/lib"
        "/usr/local/lib64")
    endif ()
    list(FIND qt4_no_package_paths "${QT_LIBRARY_DIR}" idx)

    # The package will not be installing Qt4 since it is provided by the
    # system; do not install the plugins.
    if (NOT idx EQUAL "-1")
      return ()
    endif ()
  endif ()

  if (USE_SYSTEM_qt4)
    if (NOT QT_LIBRARY_DIR)
      message(FATAL_ERROR
        "Installing plugins from a system Qt4 requires `QT_LIBRARY_DIR` to be set.")
    endif ()

    set(qt4_base_libdir "${QT_LIBRARY_DIR}")
  else ()
    set(qt4_base_libdir "${superbuild_install_location}")
  endif ()

  set(qt4_plugin_path "${qt4_base_libdir}/../plugins")
  if (WIN32)
    set(qt4_plugin_ext ".dll")
  elseif (APPLE)
    set(qt4_plugin_ext ".dylib")
  elseif (UNIX)
    set(qt4_plugin_ext ".so")
  else ()
    message(FATAL_ERROR
      "Unknown Qt4 plugin path for this platform.")
  endif ()

  set(plugin_paths)
  foreach (plugin IN LISTS ARGN)
    set(plugin_path "${qt4_plugin_path}/${plugin}${qt4_plugin_ext}")
    if (NOT EXISTS "${plugin_path}")
      message(FATAL_ERROR
        "Unable to find the ${plugin} plugin from Qt4 under ${qt4_plugin_path}.")
    endif ()

    list(APPEND plugin_paths
      "${plugin_path}")
  endforeach ()

  set("${output}" "${plugin_paths}" PARENT_SCOPE)
endfunction ()
