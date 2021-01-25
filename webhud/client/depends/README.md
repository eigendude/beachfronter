## Build dependencies

```bash
sudo apt install libcairo2-dev ninja-build python3-pip
sudo apt remove meson
pip3 install meson
```

## Build instructions

```bash
[ -d "gst-build" ] || git clone https://gitlab.freedesktop.org/gstreamer/gst-build.git
cd "gst-build"
meson builddir
ninja -C builddir
```
