#!/bin/sh
################################################################################
#
#  Copyright (C) 2020 Garrett Brown
#  This file is part of the beachfronter repo - https://github.com/eigendude/beachfronter
#
#  Copyright (C) 2017 Centricular Ltd.
#  This file is derived from the GST webrtc example available under the BSD
#  2-Clause license:
#  https://gitlab.freedesktop.org/gstreamer/gst-examples/-/tree/master/webrtc
#
#  SPDX-License-Identifier: Apache-2.0 AND BSD-2-Clause
#  See the file LICENSE.txt for more information.
#
################################################################################

#
# Simple script to generate SSL certs.
#
# Output:
#
#   - cert.pem - The generated cert
#   - key.pem - The generated private key
#

BASE_DIR=$(dirname $0)

OUTDIR=""
if [ $# -eq 1 ]; then
  OUTDIR=$1/
fi

output=$(openssl req -x509 -newkey rsa:4096 -keyout ${OUTDIR}key.pem -out ${OUTDIR}cert.pem -days 365 -nodes -subj "/CN=example.com" 2>&1)

ret=$?
if [ ! $ret -eq 0 ]; then
  echo "${output}" 1>&2
  exit $ret
fi
