################################################################################
#
#  Copyright (C) 2020 Garrett Brown
#  This file is part of the beachfronter repo - https://github.com/eigendude/beachfronter
#
#  SPDX-License-Identifier: Apache-2.0
#  See the file LICENSE.txt for more information.
#
################################################################################

import setuptools


# Get the long description from README
with open("README.md") as file:
    long_description = file.read()


setuptools.setup(
    name="webhud",
    version="1.0.0",
    author="Garrett Brown",
    author_email="eigendebugger@gmail.com",
    description="Web-based Heads Up Display for robots",
    long_description=long_description,
    long_description_content_type="text/markdown",
    url="https://github.com/eigendebugger/beachfronter",
    license="MIT",
    classifiers=[
        "License :: OSI Approved :: MIT License",
        "Programming Language :: Python :: 3",
        "Programming Language :: Python :: 3.6",
        "Programming Language :: Python :: 3.7",
        "Programming Language :: Python :: 3.8",
        "Programming Language :: Python :: 3.9",
        "Topic :: Scientific/Engineering",
        "Topic :: Scientific/Engineering :: Robotics",
    ],
    packages=setuptools.find_packages(exclude=["test", "test.*"]),
    install_requires=["websockets"],
)
