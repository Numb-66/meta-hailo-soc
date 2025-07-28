DESCRIPTION = "TAPPAS Hailo15 reference camera api recipe, \
               the recipe compiles and copies headers/pkgconfig"

inherit tappas-base

PV_PARSED = "${@ '${PV}'.replace('.0', '')}"
<<<<<<<< HEAD:meta-hailo-tappas/recipes-native-apps/reference-camera-api/reference-camera-api_1.7.1.bb
SRC_URI = "git://git@github.com/hailo-ai/hailo-camera-apps.git;protocol=https;branch=1.7.1"

SRCREV = "e4355770ee1dbeccfa1e885dab357ae1d720e8bf"
========
SRC_URI = "git://git@github.com/hailo-ai/hailo-camera-apps.git;protocol=https;branch=1.8.0"

SRCREV = "db7b4134a1acebaa763bea8ee1e2d444842c54c4"
>>>>>>>> upstream/1.8.0:meta-hailo-tappas/recipes-native-apps/reference-camera-api/reference-camera-api_1.8.0.bb
LICENSE = "LGPLv2.1"
LIC_FILES_CHKSUM += "file://../../../LICENSE;md5=4fbd65380cdd255951079008b364516c"

DEPENDS += " gstreamer1.0 gstreamer1.0-plugins-base cxxopts rapidjson libgsthailotools libmedialib-api"
RDEPENDS:${PN} += " bash libgsthailotools"

S = "${WORKDIR}/git/apps/h15/native"

DEPENDS += " opencv"
# meson configuration
EXTRA_OEMESON += " \
        -Dtarget='api' \
        "

FILES:${PN} += " ${incdir}/hailo/tappas/* ${libdir}/libhailo_reference_camera*"
FILES:${PN}-lib += ""
RDEPENDS:${PN}-staticdev = ""
RDEPENDS:${PN}-dev = ""
RDEPENDS:${PN}-dbg = ""