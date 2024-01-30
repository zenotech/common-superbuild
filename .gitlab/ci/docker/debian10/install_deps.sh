#!/bin/sh

set -e

apt update

# Install build requirements.
apt install -y \
    autoconf automake libtool make curl

# Install tools used during the build of various projects.
apt install -y \
    file debianutils libxkbcommon-x11-dev libgl1-mesa-dev \
    python3.7 libpython3.7-dev libfindbin-libs-perl libperl-dev \
    bison flex libxext-dev libxrandr-dev libxcb-util0-dev \
    libxcb-image0-dev libxcb-keysyms1-dev libxcb-render-util0-dev \
    libegl1-mesa-dev python3-venv libx11-dev

# Install development tools
apt install -y \
    git-core \
    git-lfs

# Install toolchains.
apt install -y \
    g++ \
    gcc \
    gfortran

apt clean
