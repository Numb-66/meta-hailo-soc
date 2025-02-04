DESCRIPTION = "Media Library Encoder OSD API \
               compiles the medialibrary encoder osd API \
               and copies it to usr/lib/ "

LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://LICENSE;md5=031eb3f48c82f13ff6cdb783af612501"

SRC_URI = "git://git@github.com/hailo-ai/hailo-media-library.git;protocol=https;branch=1.5.1"
SRCREV = "ed235d6f7418e11a9e39c5c3d3ba044235c60e42"

inherit media-library-base

MEDIA_LIBRARY_BUILD_TARGET = "api"

# Gstreamer Dependencies
DEPENDS:append = " glib-2.0-native glib-2.0 gstreamer1.0 gstreamer1.0-plugins-base gstreamer1.0-plugins-good json-schema-validator"
# Hailo-15 Dependencies
DEPENDS:append = " libgstmedialib"

do_install:append(){
    install -d ${D}/${bindir}
    install -m 0644 ${S}/api/examples/*.json ${D}/${bindir}
}

FILES:${PN} += "${libdir}/libhailo_media_library_api.so ${bindir}/frontend_example ${bindir}/*.json  ${incdir}/medialibrary/*.hpp"
FILES:${PN}-lib += "${libdir}/libhailo_media_library_api.so"
RDEPENDS:${PN}-staticdev = ""
RDEPENDS:${PN}-dev = ""
RDEPENDS:${PN}-dbg = ""
