foreach (dir IN ITEMS bin include lib share)
  file(GLOB files "${dir}/*")
  # exclude the windows runtime libraries from the install
  if (dir STREQUAL "bin")
    file(GLOB files_to_exclude "bin/msvc*.dll")
    foreach (file IN LISTS files_to_exclude)
      list(REMOVE_ITEM files ${file})
    endforeach ()
  endif ()
  file(INSTALL ${files}
       DESTINATION "${install_location}/${dir}")
endforeach ()
