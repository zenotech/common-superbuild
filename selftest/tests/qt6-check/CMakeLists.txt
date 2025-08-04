cmake_minimum_required(VERSION 3.14)
project(qt6-check CXX)

message(CTEST_FULL_OUTPUT)

function (check_target target)
  if (NOT TARGET "${target}")
    message(SEND_ERROR
      "Target `${target}` not defined.")
  endif ()
endfunction ()

set(qt6_components
  Core
  Core5Compat
  Help
  LinguistTools
  Network
  PrintSupport
  Test
  Widgets)
if (qt6_ENABLE_SVG)
  list(APPEND qt6_components
    Svg)
endif ()
if (qt6_ENABLE_MULTIMEDIA)
  list(APPEND qt6_components
    Multimedia)
endif ()
if (qt6_ENABLE_WEBCHANNEL)
  list(APPEND qt6_components
    WebChannel)
endif ()
if (qt6_ENABLE_WEBENGINE)
  list(APPEND qt6_components
    WebEngineWidgets)
endif ()
if (qt6_ENABLE_WEBSOCKETS)
  list(APPEND qt6_components
    WebSockets)
endif ()

find_package(Qt6
  COMPONENTS ${qt6_components})
if (NOT Qt6_FOUND)
  message(FATAL_ERROR
    "Failed to find Qt6: ${Qt6_NOT_FOUND_MESSAGE}")
endif ()

list(REMOVE_ITEM qt6_components
  # Not a target component.
  LinguistTools)

foreach (qt6_component IN LISTS qt6_components)
  check_target("Qt6::${qt6_component}")
endforeach ()
