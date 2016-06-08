find_package(Qt4 REQUIRED)

superbuild_add_extra_cmake_args(
  -DQT_QMAKE_EXECUTABLE:FILEPATH=${QT_QMAKE_EXECUTABLE})

set(qt4_paths "$ENV{PATH}")
if (UNIX)
  string(REPLACE ":" ";" qt4_paths "${qt4_paths}")
endif ()

get_filename_component(qt4_path "${QT_QMAKE_EXECUTABLE}" DIRECTORY)
list(FIND qt4_paths "${qt4_path}" qt4_path_index)

if (qt4_path_index EQUAL "-1")
  superbuild_add_path("${qt4_path}")
endif ()
