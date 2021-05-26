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
# If ROS 2 is installed to the system, source the setup script before calling
# make. This is not needed if the ROS 2 desktop components are also being built.
#
# Before running this script, prepare your system via the following steps.
#
# First, install required dependencies:
#
#   sudo apt install curl git gnupg2 lsb-release make python3-pip wget
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
all: $(S)/build-project-depends

# Define the ROS distro to use
ROS_DISTRO := foxy

# Root ROS 2 install directory
ROS_ROOT := /opt/ros/$(ROS_DISTRO)

# Setup script for ROS 2
ROS_SETUP := $(ROS_ROOT)/setup.bash

# Get current OS distro
DISTRO := $(shell lsb_release -cs)

# Decide if ROS 2 needs to be compiled or installed via apt
ifeq ($(DISTRO),bionic)
  # Ubuntu 18.04
  BUILD_ROS2_DESKTOP := 1
else ifeq ($(DISTRO),focal)
  # Ubuntu 20.04
  BUILD_ROS2_DESKTOP := 0
else ifeq ($(DISTRO),hirsute)
  # Ubuntu 21.04
  BUILD_ROS2_DESKTOP := 1
else
  BUILD_ROS2_DESKTOP := 1
endif

# Read system CMake version
CMAKE_VERSION := $(shell cmake --version | head -n 1 | awk '{print $$3}')
CMAKE_VERSION_MAJOR := $(shell echo $(CMAKE_VERSION) | cut -f1 -d.)
CMAKE_VERSION_MINOR := $(shell echo $(CMAKE_VERSION) | cut -f2 -d.)

# Decide if we should build CMake
CMAKE_MIN_REQUIRED := 16
ifeq ($(shell [ $(CMAKE_VERSION_MINOR) -lt $(CMAKE_MIN_REQUIRED) ] && echo 1),1)
  BUILD_CMAKE := 1
else
  BUILD_CMAKE := 0
endif

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
	sudo apt install -y curl gnupg2 lsb-release make python3-pip

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
# Base target for ROS 2 repos
#
$(S)/download-desktop-base: $(S)/base
	mkdir -p "$(ROS2_DESKTOP_DIR)/src"

	touch "$@"

#
# Base target for project dependency repos
#
# See the file depends.repo.
#
$(S)/download-project-base: $(S)/base
	mkdir -p "$(ROS2_PROJECT_DIR)/src"

	touch "$@"

#
# Download the ROS 2 source code
#
$(S)/download-ros2: \
  $(S)/download-desktop-base \
  $(S)/install-pip
	echo "Downloading ROS 2 source code..."

	cd "$(ROS2_DESKTOP_DIR)" && \
	  wget --timestamping "https://raw.githubusercontent.com/ros2/ros2/foxy/ros2.repos" && \
	  vcs import "$(ROS2_DESKTOP_DIR)/src" < ros2.repos

	touch "$@"

#
# Install ROS 2 rosdep dependencies
#
$(S)/install-desktop-rosdeps: \
  $(S)/download-ros2 \
  $(S)/install-dds \
  $(S)/install-rosdep
	cd "$(ROS2_DESKTOP_DIR)" && \
	  rosdep install --from-paths src --ignore-src --rosdistro foxy -y --skip-keys "console_bridge fastcdr fastrtps rti-connext-dds-5.3.1 urdfdom_headers"

	touch "$@"

#
# CMake 3.10 (ships with Ubuntu 18.04) is too old, build newest CMake
#
$(S)/build-cmake: $(S)/base
	echo "Building CMake..."

	+$(TOP_DIR)/install-cmake.sh

	touch "$@"

# Calculate targets to build before ROS 2
ROS2_BUILD_DEPS := $(S)/install-desktop-rosdeps # Need rosdeps
ifeq ($(BUILD_CMAKE),1)
  ROS2_BUILD_DEPS += $(S)/build-cmake # Need CMake
endif

#
# Build ROS 2 with colcon
#
$(S)/build-ros2: $(ROS2_BUILD_DEPS)
	echo "Building ROS 2..."

	+cd "$(ROS2_DESKTOP_DIR)" && \
	  PATH="$(CMAKE_DIR)/bin:$${PATH}" \
	  `#MAKEFLAGS="-j1 -l1"` \
	  colcon build `#--executor sequential`

	touch "$@"

#
# Install ROS 2 to /opt/ros
#
$(S)/install-ros2: $(S)/build-ros2
	echo "Installing ROS 2..."

	# Create ROS root
	sudo mkdir -p "$(ROS_ROOT)"
	sudo chown $(shell whoami):$(shell whoami) "$(ROS_ROOT)"

	# Install ROS 2
	mkdir -p "${ROS_ROOT}"
	rm -rf "${ROS_ROOT}/"*
	cp -r "$(ROS2_DESKTOP_DIR)/install/"* "${ROS_ROOT}"

	touch "$@"

#
# Download project dependencies
#
# TODO: sudo apt install ros-foxy-v4l2-camera
#
$(S)/download-project-depends: \
  $(S)/download-project-base \
  $(S)/install-pip
	echo "Downloading project dependencies..."

	vcs import "$(ROS2_PROJECT_DIR)/src" < "$(TOP_DIR)/depends.repos"

	touch "$@"

#
# Patch project dependencies
#
$(S)/patch-project-depends: $(S)/download-project-depends
	echo "Patching ROS 2 dependencies..."

	#cd "$(ROS2_PROJECT_DIR)/src/ros-perception/opencv_cam" && \
	#  git am --3way < "$(TOP_DIR)/patches/0001-package.xml-Add-missing-rclcpp_components-dependency.patch" && \
	#  git am --3way < "$(TOP_DIR)/patches/0002-Fix-compiler-error-due-to-missing-include-directory.patch"

	touch "$@"

# Calculate targets to build before installing project rosdeps
INSTALL_PROJECT_DEPENDS := $(S)/patch-project-depends # Needs patched sources
INSTALL_PROJECT_DEPENDS += $(S)/install-rosdep # Needs rosdep
ifeq ($(BUILD_ROS2_DESKTOP),1)
  INSTALL_PROJECT_DEPENDS += $(S)/install-ros2 # If not using system ROS
endif

#
# Install project rosdeps
#
$(S)/install-project-rosdeps: $(INSTALL_PROJECT_DEPENDS)
	source "$(ROS_SETUP)" && \
	  cd "$(ROS2_PROJECT_DIR)" && \
	  rosdep install --from-paths src --ignore-src --rosdistro foxy -y --skip-keys "console_bridge fastcdr fastrtps rti-connext-dds-5.3.1 urdfdom_headers"

	touch "$@"

#
# Build project dependencies with colcon
#
$(S)/build-project-depends: $(S)/install-project-rosdeps
	echo "Building project dependencies..."

	+source "$(ROS_SETUP)" && \
	  cd "$(ROS2_PROJECT_DIR)" && \
	  PATH="$(CMAKE_DIR)/bin:$${PATH}" \
	  `#MAKEFLAGS="-j1 -l1"` \
	  colcon build `#--executor sequential`

	touch "$@"
