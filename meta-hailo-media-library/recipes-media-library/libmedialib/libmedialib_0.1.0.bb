DESCRIPTION = "Media Library package recipe \
               compiles medialibrary vision_pre_proc shared object and copies it to usr/lib/ "

LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://LICENSE;md5=031eb3f48c82f13ff6cdb783af612501"

SRC_URI = "git://git@github.com/hailo-ai/hailo-media-library.git;protocol=https;branch=1.5.0"
SRCREV = "b554242e94895a016d8a3ed8e79e1ecc96afba79"

inherit media-library-base

MEDIA_LIBRARY_BUILD_TARGET = "core"

DEPENDS:append = " gstreamer1.0-plugins-good rapidjson json-schema-validator expected httplib cli11 fast-cpp-csv-parser libiio libdatachannel"

# Hailo-15 Dependencies
DEPENDS:append = " video-encoder libhailodsp libhailort"
# Hailo-15 Runtime-Dependencies
RDEPENDS:${PN} += " medialib-configs"

do_install:append() {
    install -d ${D}/${sysconfdir}/medialib
    install -m 0644 ${S}/media_library/src/hailo_encoder/encoder_presets.csv ${D}/${sysconfdir}/medialib
}

FILES:${PN} += "${libdir}/libdis_library.so ${libdir}/libhailo_media_library_common.so ${libdir}/libhailo_media_library_frontend.so ${libdir}/libhailo_media_library_encoder.so ${libdir}/libhailo_encoder.so ${incdir}/medialibrary/*.hpp ${sysconfdir}/medialib/encoder_presets.csv"
FILES:${PN}-lib += "${libdir}/libdis_library.so ${libdir}/libhailo_media_library_common.so ${libdir}/libhailo_media_library_frontend.so ${libdir}/libhailo_media_library_encoder.so ${libdir}/libhailo_encoder.so"
