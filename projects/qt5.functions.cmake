#[==[.md
```
_superbuild_get_qt5_plugin_install_context(<OUT:ContextPath> <OUT:ContextExtension>)
```

**Warning** Internal function, see `superbuild_get_qt5_plugin_install_paths` and
`superbuild_get_qt5_plugin_optional_module_install_paths`

Returns the absolute path containing all Qt5 plugin directories,
as well as the extension for these plugins. Because path and
extensions can change according to the current plateform and whether
or not we use Qt system, this function ease the work for us.
#]==]
function (_superbuild_get_qt5_plugin_install_context out_path out_ext)
  if (USE_SYSTEM_qt5 AND UNIX)
    set(qt5_no_package_paths)
    if (APPLE)
      list(APPEND qt5_no_package_paths
        "/usr/lib/cmake/Qt5")
    elseif (UNIX)
      list(APPEND qt5_no_package_paths
        "/lib/cmake/Qt5"
        "/lib64/cmake/Qt5"
        "/usr/lib/cmake/Qt5"
        "/usr/lib64/cmake/Qt5"
        "/usr/local/lib/cmake/Qt5"
        "/usr/local/lib64/cmake/Qt5")
    endif ()

    # The package will not be installing Qt5 since it is provided by the
    # system; do not install the plugins.
    if (Qt5_DIR IN_LIST qt5_no_package_paths)
      return ()
    endif ()
  endif ()

  if (USE_SYSTEM_qt5)
    if (NOT Qt5_DIR)
      message(FATAL_ERROR
        "Installing plugins from a system Qt5 requires `Qt5_DIR` to be set.")
    endif ()

    set(qt5_base_libdir "${Qt5_DIR}/../..")
    if (EXISTS "${qt5_base_libdir}/qt5")
      # This is the layout for Linux distributions.
      set(qt5_base_libdir "${qt5_base_libdir}/qt5")
    elseif (EXISTS "${qt5_base_libdir}/../plugins")
      # This is the layout for Qt binaries.
      set(qt5_base_libdir "${qt5_base_libdir}/..")
    elseif (EXISTS "${qt5_base_libdir}/../libexec/qt5")
      # This is the layout for MacPorts.
      set(qt5_base_libdir "${qt5_base_libdir}/../libexec/qt5")
    endif ()
  else ()
    set(qt5_base_libdir "${superbuild_install_location}")
  endif ()

  set(qt5_plugin_path "${qt5_base_libdir}/plugins")
  if (WIN32)
    set(qt5_plugin_ext ".dll")
  elseif (APPLE)
    set(qt5_plugin_ext ".dylib")
  elseif (UNIX)
    set(qt5_plugin_ext ".so")
  else ()
    message(FATAL_ERROR
      "Unknown Qt5 plugin path for this platform.")
  endif ()

  set("${out_path}" "${qt5_plugin_path}" PARENT_SCOPE)
  set("${out_ext}" "${qt5_plugin_ext}" PARENT_SCOPE)
endfunction()

#[==[.md
```
superbuild_get_qt5_plugin_install_paths(<OUT:PathList> <IN:PluginList>)
```

Returns a list of absolute path of Qt5 plugins to install from a list of
required plugin. This input list take the form of the dynamic library name
with no extension but with their parent folder.

Also see : superbuild_install_qt5_optional_plugin_directory_paths

Example :

```
    superbuild_get_qt5_plugin_install_paths(output_paths
        "platforms/libqminimal;renderers/libopenglrenderer")
```
#]==]
function (superbuild_get_qt5_plugin_install_paths output)
  _superbuild_get_qt5_plugin_install_context(qt5_plugin_path qt5_plugin_ext)

  set(plugin_paths)
  foreach (plugin IN LISTS ARGN)
    set(plugin_path "${qt5_plugin_path}/${plugin}${qt5_plugin_ext}")
    if (NOT EXISTS "${plugin_path}")
      message(FATAL_ERROR
        "Unable to find the ${plugin} plugin from Qt5 under ${qt5_plugin_path}.")
    endif ()

    list(APPEND plugin_paths
      "${plugin_path}")
  endforeach ()

  set("${output}" "${plugin_paths}" PARENT_SCOPE)
endfunction ()

#[==[.md
```
superbuild_get_qt5_plugin_optional_module_install_paths(<OUT:PathList> <IN:ModuleList>)
```

Returns a list of absolute path of Qt5 plugins to install from a list of
required plugin directory. This function will not fail if a directory does not
exist, and will install every plugin it will find under the given directories.

Also see: superbuild_get_qt5_plugin_install_paths

Example :

```
    superbuild_get_qt5_plugin_optional_module_install_paths(output_paths
        "platforms;renderers")
```
#]==]
function (superbuild_get_qt5_plugin_optional_module_install_paths output)
  _superbuild_get_qt5_plugin_install_context(qt5_plugin_path qt5_plugin_ext)

  set(plugin_paths)
  foreach(directory IN LISTS ARGN)
    set(directory_abs_path "${qt5_plugin_path}/${directory}")
    if (EXISTS "${directory_abs_path}")
      file(GLOB plugins
        "${directory_abs_path}/*${qt5_plugin_ext}")
      foreach(plugin IN LISTS plugins)
        get_filename_component(stripped_plugin "${plugin}" NAME_WE)
        list(APPEND plugin_paths
          "${directory}/${stripped_plugin}")
      endforeach()
    else()
      message(STATUS "Qt5 plugin directory ${directory} not found, ignoring ..")
    endif()
  endforeach()

  set("${output}" "${plugin_paths}" PARENT_SCOPE)
endfunction ()
