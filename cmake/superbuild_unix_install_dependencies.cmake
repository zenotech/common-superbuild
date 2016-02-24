set(library_paths
  "${superbuild_install_location}/lib")
foreach (extra_path IN LISTS extra_paths)
  list(APPEND library_paths
    "${superbuild_install_location}/lib/${extra_path}")
endforeach ()

find_file(executable
  NAMES "${executable_name}"
  PATHS ${library_paths})

if (NOT executable)
  message(FATAL_ERROR "Failed to find the ${executable_name} executable")
endif ()

get_filename_component(exepath "${executable}" PATH)
get_filename_component(exename "${executable}" NAME)

set(prerequisites)
message(STATUS "Determining dependencies for ${exename}...")

include(GetPrerequisites)
get_prerequisites(
  "${executable}"
  prerequisites
  1 # exclude system libraries
  1 # resolve dependencies recursively
  "${exepath}"
  "${library_paths}")

# gp_resolve_item_override aren't storing the full system path, so lets fix-up
# the prerequisites
set(resolved_prerequisites)
foreach (link IN LISTS prerequisites)
  get_filename_component(linkname "${link}" NAME)

  set(full_path full_path-NOTFOUND)
  find_file(full_path
    NAMES "${linkname}"
    PATHS ${library_paths}
    NO_DEFAULT_PATH)

  message(STATUS "Resolving ${linkname} to path ${full_path}...")

  if (IS_SYMLINK "${full_path}")
    get_filename_component(resolved_link "${full_path}" REALPATH)
    # Now link may not directly point to resolved_link, so we install the
    # resolved link as the link.
    get_filename_component(resolved_name "${full_path}" NAME)

    file(INSTALL
      FILES       "${resolved_link}"
      DESTINATION "${CMAKE_INSTALL_PREFIX}/lib/${target_path}"
      TYPE        PROGRAM
      RENAME      "${resolved_name}")
  else ()
    list(APPEND resolved_prerequisites
      "${full_path}")
  endif ()
endforeach ()

file(
  INSTALL     ${resolved_prerequisites}
  DESTINATION "${CMAKE_INSTALL_PREFIX}/lib/${target_path}"
  USE_SOURCE_PERMISSIONS)
