function (superbuild_python_write_reqs path)
  get_property(packages GLOBAL
    PROPERTY _superbuild_python_packages)

  file(WRITE "${path}" "")
  foreach (package IN LISTS packages)
    file(APPEND "${path}"
      "${package}\n")
  endforeach ()
endfunction ()
