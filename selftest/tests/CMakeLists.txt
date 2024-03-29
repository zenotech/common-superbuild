set(install_dir "${CMAKE_BINARY_DIR}/install")

if (APPLE)
  add_test(
    NAME apple-check-binaries
    COMMAND
      "${CMAKE_COMMAND}"
      "-Dinstall_dir=${install_dir}"
      "-Ddeployment_target=${CMAKE_OSX_DEPLOYMENT_TARGET}"
      "-Darch=${CMAKE_HOST_SYSTEM_PROCESSOR}"
      "-Dospray_SOURCE_SELECTION=${ospray_SOURCE_SELECTION}"
      -P "${CMAKE_CURRENT_SOURCE_DIR}/apple-check.cmake")
endif ()

if (APPLE AND CMAKE_OSX_DEPLOYMENT_TARGET VERSION_LESS "11.0"
    AND (TARGET numpy OR TARGET scipy))
  add_test(
    NAME no-accelerate-framework
    COMMAND
      "${CMAKE_COMMAND}"
      "-Dinstall_dir=${install_dir}"
      "-Dnumpy_enabled=$<TARGET_EXISTS:numpy>"
      "-Dscipy_enabled=$<TARGET_EXISTS:scipy>"
      -P "${CMAKE_CURRENT_SOURCE_DIR}/accelerate-check.cmake")
endif ()

if (UNIX)
  add_test(
    NAME unix-check-lib64
    COMMAND
      "${CMAKE_COMMAND}"
      "-Dinstall_dir=${install_dir}"
      -P "${CMAKE_CURRENT_SOURCE_DIR}/unix-check-lib64.cmake")
endif ()

function (add_license_test package)
  if (NOT TARGET "${package}")
    return ()
  endif ()

  if (USE_SYSTEM_${package})
    return ()
  endif ()

  add_test(
    NAME "license-${package}"
    COMMAND
      "${CMAKE_COMMAND}"
      "-Dlicense_dir=${install_dir}/share/licenses/${package}"
      -P "${CMAKE_CURRENT_SOURCE_DIR}/check-license.cmake")
endfunction ()

get_property(all_projects GLOBAL PROPERTY _superbuild_all_projects)

set(license_projects "${all_projects}")
# Remove projects which are known to not have licenses.
list(REMOVE_ITEM license_projects
  # Language utility projects
  cxx11
  cxx14
  cxx17

  # Feature projects
  fortran

  # Dummy projects
  exodus
  hdf5cpp
  ospraymodulempi

  # USE_SYSTEM projects
  openmp
  )

# Apple USE_SYSTEM projects
if (APPLE)
  list(REMOVE_ITEM license_projects
    qt5
    bzip2
    )
endif ()

# Win32 USE_SYSTEM projects
if (WIN32)
  list(REMOVE_ITEM license_projects
    qt5
    mpi
    )
endif ()

# Unix/Apple USE_SYSTEM projects
if (UNIX)
  list(REMOVE_ITEM license_projects
    egl
    flexbison
    )
endif ()

# Ninja logic
if (CMAKE_GENERATOR MATCHES "Ninja")
  list(REMOVE_ITEM license_projects
    ninja
    )
endif ()

foreach (project IN LISTS license_projects)
  add_license_test("${project}")
endforeach ()

function (add_python_import_test package module)
  if (NOT TARGET "${package}" OR NOT TARGET "python3")
    return ()
  endif ()

  add_test(
    NAME "python3-${package}-import-${module}"
    COMMAND
      "${superbuild_python_executable}"
      -c "import os; [os.add_dll_directory(p) for p in filter(lambda x: x, os.environ.get('PYTHON_WINDOWS_DLL_DIRECTORIES', '').split(';'))]; import ${module}; print(${module}.__file__.replace(os.sep, '/'))")
  if (NOT USE_SYSTEM_${package})
    set_property(TEST "python3-${package}-import-${module}"
      PROPERTY
        PASS_REGULAR_EXPRESSION "${install_dir}")
    if (NOT module STREQUAL "ssl")
      set_property(TEST "python3-${package}-import-${module}"
        PROPERTY
          FAIL_REGULAR_EXPRESSION "ModuleNotFoundError")
    endif ()
  endif ()

  if (USE_SYSTEM_python3)
    set_property(TEST "python3-${package}-import-${module}" APPEND
      PROPERTY
        ENVIRONMENT_MODIFICATION "PYTHONPATH=path_list_prepend:${install_dir}/lib/python${superbuild_python_version}/site-packages")
  endif ()
endfunction ()

function (add_python_script_test package script)
  if (NOT TARGET "${package}")
    return ()
  endif ()

  add_test(
    NAME "python3-${package}-script-${script}"
    COMMAND
      "${superbuild_python_executable}"
      "${CMAKE_CURRENT_SOURCE_DIR}/${script}.py")
endfunction ()

if (TARGET hdf5)
  add_test(
    NAME hdf5-check
    COMMAND
      "${CMAKE_CTEST_COMMAND}"
        --build-generator "${CMAKE_GENERATOR}"
        --build-and-test "${CMAKE_CURRENT_SOURCE_DIR}/hdf5-check" "${CMAKE_CURRENT_BINARY_DIR}/hdf5-check"
        --build-options "-DCMAKE_PREFIX_PATH=${install_dir}" "-Dwith_mpi=$<TARGET_EXISTS:mpi>"
        --test-command "${CMAKE_CTEST_COMMAND}" --output-on-failure)
endif ()

if (TARGET mpi)
  add_test(
    NAME mpi-check
    COMMAND
      "${CMAKE_CTEST_COMMAND}"
        --build-generator "${CMAKE_GENERATOR}"
        --build-and-test "${CMAKE_CURRENT_SOURCE_DIR}/mpi-check" "${CMAKE_CURRENT_BINARY_DIR}/mpi-check"
        --build-options "-DCMAKE_PREFIX_PATH=${install_dir}"
        --test-command "${CMAKE_CTEST_COMMAND}")
endif ()

if (TARGET tbb)
  add_test(
    NAME tbb-check
    COMMAND
      "${CMAKE_CTEST_COMMAND}"
        --build-generator "${CMAKE_GENERATOR}"
        --build-and-test "${CMAKE_CURRENT_SOURCE_DIR}/tbb-check" "${CMAKE_CURRENT_BINARY_DIR}/tbb-check"
        --build-options "-DCMAKE_PREFIX_PATH=${install_dir}")
endif ()

if (TARGET sqlite)
  add_test(
    NAME sqlite-check
    COMMAND
      "${CMAKE_CTEST_COMMAND}"
        --build-generator "${CMAKE_GENERATOR}"
        --build-and-test "${CMAKE_CURRENT_SOURCE_DIR}/sqlite-check" "${CMAKE_CURRENT_BINARY_DIR}/sqlite-check"
        --build-options "-DCMAKE_PREFIX_PATH=${install_dir}"
        --test-command "${CMAKE_CTEST_COMMAND}")
endif ()

if (TARGET openssl)
  add_test(
    NAME openssl-check
    COMMAND
      "${CMAKE_CTEST_COMMAND}"
        --build-generator "${CMAKE_GENERATOR}"
        --build-and-test "${CMAKE_CURRENT_SOURCE_DIR}/openssl-check" "${CMAKE_CURRENT_BINARY_DIR}/openssl-check"
        --build-options "-DCMAKE_PREFIX_PATH=${install_dir}"
        --test-command "${CMAKE_CTEST_COMMAND}")
endif ()

add_python_import_test(python3 this)
add_python_import_test(matplotlib matplotlib)
add_python_script_test(matplotlib matplotlib-render)
add_python_import_test(numpy numpy)
add_python_import_test(pythonaiohttp aiohttp)
add_python_import_test(pythonaiosignal aiosignal)
add_python_import_test(pythonasynctimeout async_timeout)
add_python_import_test(pythonattrs attr)
add_python_import_test(pythonbeniget beniget)
add_python_import_test(pythoncffi cffi)
add_python_import_test(pythoncftime cftime)
add_python_import_test(pythonchardet chardet)
add_python_import_test(pythoncharsetnormalizer charset_normalizer)
add_python_import_test(pythoncontourpy contourpy)
add_python_import_test(pythoncppy cppy)
add_python_import_test(pythoncryptography cryptography)
add_python_import_test(pythoncycler cycler)
add_python_import_test(pythoncython cython)
add_python_import_test(pythondateutil dateutil)
add_python_import_test(pythonflitcore flit_core)
add_python_import_test(pythonfonttools fontTools)
add_python_import_test(pythonfrozenlist frozenlist)
add_python_import_test(pythongast gast)
add_python_import_test(pythonhatchfancypypireadme hatch_fancy_pypi_readme)
add_python_import_test(pythonhatchling hatchling)
add_python_import_test(pythonhatchvcs hatch_vcs)
add_python_import_test(pythonidna idna)
add_python_import_test(pythonkiwisolver kiwisolver)
add_python_import_test(pythonmarkupsafe markupsafe)
add_python_import_test(pythonmesonpython mesonpy)
add_python_import_test(pythonmpi4py mpi4py)
add_python_import_test(pythonmpmath mpmath)
add_python_import_test(pythonmultidict multidict)
if (superbuild_python_version VERSION_GREATER_EQUAL "3.7")
  add_python_import_test(pythonnetcdf4 netCDF4)
endif ()
add_python_import_test(pythonpackaging packaging)
add_python_import_test(pythonpandas pandas)
add_python_import_test(pythonpathspec pathspec)
add_python_import_test(pythonpillow PIL)
add_python_import_test(pythonpillow PIL.Image)
add_python_import_test(pythonpluggy pluggy)
add_python_import_test(pythonply ply)
add_python_import_test(pythonpycparser pycparser)
add_python_import_test(pythonpygments pygments)
add_python_import_test(pythonpyparsing pyparsing)
add_python_import_test(pythonpyprojectmetadata pyproject_metadata)
add_python_import_test(pythonpythran pythran)
add_python_import_test(pythonsemanticversion semantic_version)
add_python_import_test(pythonsetuptools setuptools)
add_python_import_test(pythonsetuptoolsscm setuptools_scm)
add_python_import_test(pythonsetuptoolsrust setuptools_rust)
add_python_import_test(pythonsix six)
add_python_import_test(pythontoml toml)
add_python_import_test(pythontomli tomli)
add_python_import_test(pythontroveclassifiers trove_classifiers)
add_python_import_test(pythontypingextensions typing_extensions)
add_python_import_test(pythontzdata tzdata)
add_python_import_test(pythonversioneer versioneer)
add_python_import_test(pythonwheel wheel)
add_python_import_test(pythonwslinkasync wslink)
add_python_import_test(pythonyarl yarl)
add_python_import_test(pytz pytz)
add_python_import_test(pywin32 adodbapi)
add_python_import_test(scipy scipy)
add_python_import_test(sympy sympy)
# lzma comes with Python stdlib and will always import properly.
if (NOT USE_SYSTEM_python3)
  add_python_import_test(xz lzma)
endif ()

if (WIN32)
  set(dll_assisted_tests
    # Python 3.9 needs help finding dependent DLLs and Pillow doesn't do this on
    # its own, so extra work is needed to make this happy.
    "python3-matplotlib-import-matplotlib"
    "python3-matplotlib-script-matplotlib-render"
    "python3-pythonpillow-import-PIL.Image"

    # netCDF4 needs help too.
    "python3-pythonnetcdf4-import-netCDF4")
  foreach (dll_assisted_test IN LISTS dll_assisted_tests)
    if (TEST "${dll_assisted_test}")
      set_property(TEST "${dll_assisted_test}" APPEND
        PROPERTY
          ENVIRONMENT "PYTHON_WINDOWS_DLL_DIRECTORIES=${install_dir}/bin")
    endif ()
  endforeach ()
endif ()

# Verify that Python3 support for ssl is removed from a built-in Python if not
# enabled.
add_python_import_test(python3 ssl)
if (NOT TARGET "openssl" AND NOT USE_SYSTEM_python3 AND TEST "python3-python3-import-ssl")
  # Require that the `_ssl` module is not found.
  set_property(TEST "python3-python3-import-ssl"
    PROPERTY
      PASS_REGULAR_EXPRESSION "ModuleNotFoundError: No module named '_ssl'")
endif ()
