cmake_minimum_required(VERSION 3.14)
project(openssl-check C)

message(CTEST_FULL_OUTPUT)

function (check_target target)
  if (NOT TARGET "${target}")
    message(SEND_ERROR
      "Target `${target}` not defined.")
  endif ()
endfunction ()

find_package(OpenSSL REQUIRED)

check_target(OpenSSL::SSL)
check_target(OpenSSL::Crypto)

add_executable(openssltest openssl.c)
target_link_libraries(openssltest PRIVATE OpenSSL::Crypto OpenSSL::SSL)

include(CTest)
enable_testing()

add_test(NAME openssltest COMMAND openssltest)
string(REPLACE ";" "\;" curpath "$ENV{PATH}")
set_property(TEST openssltest APPEND PROPERTY ENVIRONMENT "PATH=${curpath}\;${CMAKE_PREFIX_PATH}/bin")
