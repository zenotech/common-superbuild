file(TO_NATIVE_PATH "${install_location}" install_location)

execute_process(
  COMMAND "${python_executable}"
          setup.py
          install
          "--prefix=${install_location}/bin")
