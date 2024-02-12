set(fontconfig_process_environment)
if (BUILD_SHARED_LIBS)
  set(fontconfig_shared_args --enable-shared --disable-static)
else ()
  set(fontconfig_shared_args --disable-shared --enable-static)
endif ()

set(fontconfig_depends)
if (NOT APPLE)
  list(APPEND fontconfig_depends
    utillinux)
endif ()
if (APPLE OR UNIX)
  list(APPEND fontconfig_depends
    pkgconf)

  if (pkgconf_enabled)
    list(APPEND fontconfig_process_environment
      PKG_CONFIG "${superbuild_pkgconf} --keep-system-cflags --keep-system-libs")
  endif ()
endif ()


superbuild_add_project(fontconfig
  DEPENDS freetype libxml2 png gperf python3 ${fontconfig_depends}
  LICENSE_FILES
    COPYING
  SPDX_LICENSE_IDENTIFIER
    MIT
  SPDX_COPYRIGHT_TEXT
    "Copyright © 2000,2001,2002,2003,2004,2006,2007 Keith Packard"
    "Copyright © 2005 Patrick Lam"
    "Copyright © 2007 Dwayne Bailey and Translate.org.za"
    "Copyright © 2009 Roozbeh Pournader"
    "Copyright © 2008,2009,2010,2011,2012,2013,2014,2015,2016,2017,2018,2019,2020 Red Hat, Inc."
    "Copyright © 2008 Danilo Šegan"
    "Copyright © 2012 Google, Inc."
  BUILD_IN_SOURCE 1
  CONFIGURE_COMMAND
    <SOURCE_DIR>/configure
      --prefix=<INSTALL_DIR>
      --disable-docs
      --enable-libxml2
      ${fontconfig_shared_args}

      # Use the system configuration and cachedirs.
      --sysconfdir=/etc
      --localstatedir=/var
  BUILD_COMMAND
    $(MAKE)
  INSTALL_COMMAND
    $(MAKE) install-exec install-pkgconfigDATA installdirs
  PROCESS_ENVIRONMENT
    ${fontconfig_process_environment})

superbuild_project_add_step(install-headers
  COMMAND   make install-fontconfigincludeHEADERS
  DEPENDEES install
  COMMENT   ""
  WORKING_DIRECTORY <SOURCE_DIR>/fontconfig)
