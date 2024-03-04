DESCRIPTION = "Media Library GStreamer plugin \
               compiles the medialibrary gstreamer plugin \
               and copies it to usr/lib/gstreamer-1.0 (gstreamer's plugins directory) "

LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://LICENSE;md5=8349eaff29531f0a3c4f4c8b31185958"


SRC_URI = "git://git@github.com/hailo-ai/hailo-media-library.git;protocol=https;branch=1.2.2"
SRCREV = "1a115b3af37400edbfb6136d91b0b7d7266008dd"

RESOURCE_DIR = "${S}/resources"
ROOTFS_HOME_DIR = "/home/root"
inherit media-library-base

ROOTFS_APPS_DIR = "/home/root/apps"
MEDIA_LIBRARY_BUILD_TARGET = "gst"

do_install:append() {
    rm -f ${D}/${libdir}/gstreamer-1.0/libgstmedialib.so
    find ${D}/${libdir}/gstreamer-1.0/ -name 'libgstmedialib.so.[0-9]' -delete
    mv -f ${D}/${libdir}/gstreamer-1.0/libgstmedialib.so.${PV} ${D}/${libdir}/gstreamer-1.0/libgstmedialib.so

    # copy media library resources
    install -d ${D}/${ROOTFS_APPS_DIR}/resources
    install -m 0755 ${RESOURCE_DIR}/* ${D}/${ROOTFS_APPS_DIR}/resources
    install -m 0755 ${RESOURCE_DIR}/${@'cam_intrinsics_334.txt' if 'imx334' in d.getVar('MACHINE_FEATURES') else 'cam_intrinsics_678.txt'} ${D}/${ROOTFS_APPS_DIR}/resources/cam_intrinsics.txt
}

# Gstreamer Dependencies
DEPENDS:append = " glib-2.0-native glib-2.0 gstreamer1.0 gstreamer1.0-plugins-base gstreamer1.0-plugins-good"
# Hailo-15 Dependencies
DEPENDS:append = " libhailodsp libmedialib libgsthailo libhailort"

PACKAGECONFIG:append:pn-opencv = "freetype "

FILES:${PN} += "${libdir}/gstreamer-1.0/libgstmedialib.so ${ROOTFS_APPS_DIR}/resources/*"
FILES:${PN}-lib += "${libdir}/gstreamer-1.0/libgstmedialib.so"
RDEPENDS:${PN}-staticdev = ""
RDEPENDS:${PN}-dev = ""
RDEPENDS:${PN}-dbg = ""
