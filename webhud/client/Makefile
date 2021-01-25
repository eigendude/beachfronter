################################################################################
#
#  Copyright (C) 2020 Garrett Brown
#  This file is part of the beachfronter repo - https://github.com/eigendude/beachfronter
#
#  This file is derived from the GST webrtc example, available under the BSD
#  2-Clause license. Copyright (C) 2017 Centricular Ltd.
#  https://gitlab.freedesktop.org/gstreamer/gst-examples/-/tree/master/webrtc
#
#  SPDX-License-Identifier: Apache-2.0 AND BSD-2-Clause
#  See the file LICENSE.txt for more information.
#
################################################################################

DEPENDS = \
  glib-2.0 \
  gstreamer-1.0 \
  gstreamer-sdp-1.0 \
  gstreamer-webrtc-1.0 \
  json-glib-1.0 \
  libsoup-2.4 \

CC := gcc

LIBS := $(shell pkg-config --libs --cflags $(DEPENDS))

CFLAGS := \
  -O0 \
  -ggdb \
  -Wall \
  -fno-omit-frame-pointer \
  $(shell pkg-config --cflags $(DEPENDS)) \

webrtc-sendrecv: webrtc-sendrecv.cpp
	"$(CC)" $(CFLAGS) $^ $(LIBS) -o $@

clean:
	rm webrtc-sendrecv
