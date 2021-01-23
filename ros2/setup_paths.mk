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
# Set paths for build system
#
################################################################################

# Directory for this Makefile
TOP_DIR = $(shell pwd)

# Directory of stamps for tracking build progress
STAMP_DIR = $(TOP_DIR)/stamps

# Shorten variable name for Makefile stamp idiom
S = $(STAMP_DIR)

# Directory of CMake binary
CMAKE_DIR = $(TOP_DIR)/cmake

# Directory of ROS 2 source code
ROS2_DIR = $(TOP_DIR)/ros2
