if (WIN32)
  set(dir "bin/Lib/site-packages")
else ()
  set(dir "lib/python2.7/site-packages")
endif ()

file(MAKE_DIRECTORY
  "${install_dir}/${dir}/zope")
file(WRITE "${install_dir}/${dir}/zope/__init__.py")
