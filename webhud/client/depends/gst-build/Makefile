build-gst:
	[ -d "gst-build" ] || git clone https://gitlab.freedesktop.org/gstreamer/gst-build.git
	cd "gst-build" && meson "build"
	ninja -C "gst-build/build"
