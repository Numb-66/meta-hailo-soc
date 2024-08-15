SUMMARY = "Hailo Media library requirements"
DESCRIPTION = "The minimal set of packages required to boot the system"

PACKAGE_ARCH = "${MACHINE_ARCH}"

inherit packagegroup

PACKAGEGROUP_DISABLE_COMPLEMENTARY = "1"
PACKAGES = "\
            packagegroup-hailo-media-library \
            packagegroup-hailo-media-library-dev-pkg"

RDEPENDS:${PN} = "\
    glib-2.0 \
    gstreamer1.0 \
    gstreamer1.0-plugins-bad \
    gstreamer1.0-plugins-base \
    gstreamer1.0-plugins-good \
    libmedialib-api \
    libgstmedialib"

RDEPENDS:${PN}-dev-pkg = "\
    packagegroup-hailo-media-library \
    gdb \
    gst-instruments \
    gstreamer1.0-libav \
    gstreamer1.0-plugins-ugly \
    htop \
    tmux \
    ulimit \
    vim \
    x264"
