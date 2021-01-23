#!/bin/bash
################################################################################
#
#  Copyright (C) 2020 Garrett Brown
#  This file is part of the beachfronter repo - https://github.com/eigendude/beachfronter
#
#  SPDX-License-Identifier: Apache-2.0
#  See the file LICENSE.txt for more information.
#
################################################################################

# Enable strict mode
set -o errexit
set -o pipefail
set -o nounset

#
# CMake build script
#
# This script is included because ROS 2 requires a newer version of CMake, and
# most distros have an older version in their package manager.
#
# Required dependencies:
#
#   * cmake (any version)
#   * tar
#   * wget
#
# Optional dependencies:
#
#   * ccache
#

# Version (TODO: 3.18.3)
CMAKE_VERSION="3.19.2"

# URL
CMAKE_URL="https://github.com/Kitware/CMake/releases/download/v${CMAKE_VERSION}/cmake-${CMAKE_VERSION}.tar.gz"

#
# Directory and path definitions
#

# Get the absolute path to this script
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Define directories
DOWNLOAD_DIR="${SCRIPT_DIR}/downloads"
EXTRACT_DIR="${SCRIPT_DIR}/extracted"
BUILD_DIR="${SCRIPT_DIR}/work"
INSTALL_DIR="${SCRIPT_DIR}/cmake"

# Define paths
CMAKE_ARCHIVE_PATH="${DOWNLOAD_DIR}/cmake-${CMAKE_VERSION}.tar.gz"
CMAKE_SOURCE_DIR="${EXTRACT_DIR}/cmake-${CMAKE_VERSION}"
CMAKE_LISTS_PATH="${CMAKE_SOURCE_DIR}/CMakeLists.txt"
CMAKE_BUILD_DIR="${BUILD_DIR}/cmake-${CMAKE_VERSION}"
CMAKE_MAKEFILE_PATH="${CMAKE_BUILD_DIR}/Makefile"

# Create directories
mkdir -p "${DOWNLOAD_DIR}"
mkdir -p "${EXTRACT_DIR}"
mkdir -p "${BUILD_DIR}"

#
# Build procedures
#

# Download CMake
if [ ! -f "${CMAKE_ARCHIVE_PATH}" ]; then
  echo "Downloading CMake..."
  wget "${CMAKE_URL}" -O "${CMAKE_ARCHIVE_PATH}"
fi

# Extract CMake
if [ ! -f "${CMAKE_LISTS_PATH}" ]; then
  echo "Extracting CMake..."
  tar -zxf "${CMAKE_ARCHIVE_PATH}" --directory="${EXTRACT_DIR}"
fi

# Configure CMake
# Takes about 5 minutes on a slow netbook, 10 minutes on a BeagleBone AI
if [ ! -f "${CMAKE_MAKEFILE_PATH}" ]; then
  (
    echo "Configuring CMake..."
    mkdir -p "${CMAKE_BUILD_DIR}"
    cd "${CMAKE_BUILD_DIR}"
    cmake \
      "${CMAKE_SOURCE_DIR}" \
      -DCMAKE_INSTALL_PREFIX="${INSTALL_DIR}" \
      -DCMAKE_BUILD_PARALLEL_LEVEL="$(getconf _NPROCESSORS_ONLN)" \
      $(! command -v ccache &> /dev/null || echo "-DCMAKE_CXX_COMPILER_LAUNCHER=ccache")
  )
fi

# Build CMake
# Takes about 90 minutes on a slow netbook
echo "Building CMake..."
make -C "${CMAKE_BUILD_DIR}" -j$(getconf _NPROCESSORS_ONLN)

# Install CMake
echo "Installing CMake..."
make -C "${CMAKE_BUILD_DIR}" install
