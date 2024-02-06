#!/bin/sh

set -e

# Install build requirements.
yum install --setopt=install_weak_deps=False -y \
    autoconf automake libtool make

# Install tools used during the build of various projects.
yum install --setopt=install_weak_deps=False -y \
    file which libxkbcommon-x11-devel mesa-libGL-devel mesa-libEGL-devel \
    python-unversioned-command python36-devel perl-FindBin perl-lib \
    bison flex libXext-devel libXrandr-devel xcb-util-wm-devel xcb-util-devel \
    xcb-util-image-devel xcb-util-keysyms-devel xcb-util-renderutil-devel

# Install development tools
yum install --setopt=install_weak_deps=False -y \
    git-core \
    git-lfs

# Install toolchains.
yum install --setopt=install_weak_deps=False -y \
    gcc-c++ \
    gcc \
    gcc-gfortran

yum clean all
