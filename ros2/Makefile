################################################################################
#
#  Copyright (C) 2020 Garrett Brown
#  This file is part of the beachfronter repo - https://github.com/eigendude/beachfronter
#
#  SPDX-License-Identifier: Apache-2.0
#  See the file LICENSE.txt for more information.
#
################################################################################

################################################################################
#
# ROS 2 build chain
#
# Before running this script, prepare your system via the following steps.
#
# First, install required dependencies:
#
#   sudo apt install curl git gnupg2 lsb-release make
#
# Add the ROS 2 apt repository:
#
#   curl -s https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc | sudo apt-key add -
#
# Then add the repository to your sources list:
#
#   sudo sh -c 'echo "deb [arch=$(dpkg --print-architecture)] http://packages.ros.org/ros2/ubuntu $(lsb_release -cs) main" > /etc/apt/sources.list.d/ros2-latest.list'
#
# Install development tools and ROS tools:
#
#   sudo apt install build-essential cmake git gfortran libbullet-dev python3-colcon-common-extensions python3-flake8 python3-pip python3-pytest-cov python3-rosdep python3-setuptools python3-vcstool wget
#
# Install some pip packages needed for testing:
#
#   python3 -m pip install -U argcomplete flake8-blind-except flake8-builtins flake8-class-newline flake8-comprehensions flake8-deprecated flake8-docstrings flake8-import-order flake8-quotes pytest-repeat pytest-rerunfailures pytest
#
# Install Fast-RTPS dependencies:
#
#   sudo apt install --no-install-recommends libasio-dev libtinyxml2-dev
#
# Install Cyclone DDS dependencies:
#
#   sudo apt install --no-install-recommends libcunit1-dev
#

# Define the shell used to execute commands
SHELL := /bin/bash

# Build system setup
include setup_paths.mk

# Set the stage used when make is called with no arguments
all: $(S)/build-ros2

################################################################################
#
# Build system targets
#
# Defines the targets that are built when "make" is run.
#
################################################################################

#
# Create directory for Makefile stamp idiom
#
$(S)/base:
	mkdir -p "$(S)"

	sudo apt update

	# CMake dependencies
	sudo apt install -y libssl-dev

	touch "$@"

#
# Install prerequisite dependencies
#
$(S)/install-prereqs: $(S)/base
	# Install required dependencies
	sudo apt install -y curl gnupg2 lsb-release make

	# Add the ROS 2 apt repository
	curl -s https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc | sudo apt-key add -

	# Add the ROS 2 repository to our sources list
	# NOTE: hersute packages not currently available
	sudo sh -c 'echo "deb [arch=$(shell dpkg --print-architecture)] http://packages.ros.org/ros2/ubuntu $(shell lsb_release -cs) main" > /etc/apt/sources.list.d/ros2-latest.list'

	sudo apt update

	# Install development tools and ROS tools
	sudo apt install -y build-essential cmake git gfortran libbullet-dev python3-colcon-common-extensions python3-flake8 python3-pip python3-pytest-cov python3-rosdep python3-setuptools python3-vcstool wget

	touch "$@"

#
# Install pip packages
#
$(S)/install-pip: $(S)/install-prereqs
	# Install some pip packages needed for testing
	python3 -m pip install -U argcomplete flake8-blind-except flake8-builtins flake8-class-newline flake8-comprehensions flake8-deprecated flake8-docstrings flake8-import-order flake8-quotes pytest-repeat pytest-rerunfailures pytest

	touch "$@"

#
# Install DDS dependencies
#
$(S)/install-dds: $(S)/install-prereqs
	# Install Fast-RTPS dependencies
	sudo apt install -y --no-install-recommends libasio-dev libtinyxml2-dev

	# Install Cyclone DDS dependencies
	sudo apt install -y --no-install-recommends libcunit1-dev

	touch "$@"

#
# Install rosdep
#
$(S)/install-rosdep: $(S)/install-prereqs
	[ -f "/etc/ros/rosdep/sources.list.d/20-default.list" ] || sudo rosdep init

	rosdep update

	touch "$@"

#
# Base target for source code downloads
#
$(S)/download-base: $(S)/base
	mkdir -p "$(ROS2_DIR)/src"

	touch "$@"

#
# Download the ROS 2 source code
#
$(S)/download-ros2: $(S)/download-base $(S)/install-pip
	echo "Downloading ROS 2 source code..."

	cd "$(ROS2_DIR)" && \
	  wget --timestamping "https://raw.githubusercontent.com/ros2/ros2/foxy/ros2.repos" && \
	  vcs import "$(ROS2_DIR)/src" < ros2.repos

	touch "$@"

#
# Download local dependencies
#
$(S)/download-depends: $(S)/download-base $(S)/install-pip
	echo "Downloading local dependencies..."

	vcs import "$(ROS2_DIR)/src" < "$(TOP_DIR)/depends.repos"

	touch "$@"

#
# Patch local dependencies
#
$(S)/patch-depends: $(S)/download-depends
	echo "Patching ROS 2 dependencies..."

	cd "$(ROS2_DIR)/src/ros-perception/gscam2" && \
	  git am --3way < "$(TOP_DIR)/patches/0001-Fix-compiler-error-due-to-missing-include-directory.patch"

	touch "$@"

#
# Install ROS 2 and local dependencies
#
$(S)/install-depends: \
  $(S)/download-ros2 \
  $(S)/download-depends \
  $(S)/patch-depends \
  $(S)/install-rosdep
	cd "$(ROS2_DIR)" && \
	  rosdep install --from-paths src --ignore-src --rosdistro foxy -y --skip-keys "console_bridge fastcdr fastrtps rti-connext-dds-5.3.1 urdfdom_headers"

	touch "$@"

#
# CMake 3.10 (ships with Ubuntu 18.04) is too old, build newest CMake
#
$(S)/build-cmake: $(S)/base
	echo "Building CMake..."

	+$(TOP_DIR)/install-cmake.sh

	touch "$@"

#
# Build ROS 2 with colcon
#
$(S)/build-ros2: $(S)/build-cmake $(S)/install-depends
	echo "Building ROS 2..."

	+cd "$(ROS2_DIR)" && \
	  PATH="$(CMAKE_DIR)/bin:$${PATH}" colcon build --symlink-install

	touch "$@"
