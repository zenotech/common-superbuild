if (NOT EXISTS "${license_dir}")
  message(FATAL_ERROR
    "License directory does not exist.")
endif ()

file(GLOB_RECURSE licenses "${license_dir}/*"
  LIST_DIRECTORIES 0)
set(have_license 0)
foreach (license IN LISTS licenses)
  set(have_license 1)
  message("${license}")
endforeach ()

if (NOT have_license)
  message(FATAL_ERROR
    "No licenses found")
endif ()
