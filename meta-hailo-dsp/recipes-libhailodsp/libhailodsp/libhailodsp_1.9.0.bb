DESCRIPTION = "libhailodsp - Hailo's API for DSP"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://LICENSE;md5=2740b88bd0ffad7eda222e6f5cd097f4"

<<<<<<<< HEAD:meta-hailo-dsp/recipes-libhailodsp/libhailodsp/libhailodsp_1.8.1.bb
BRANCH = "1.8.1"
SRCREV = "4508b0930554aa100c0913cabedeff6677ca905e"
========
BRANCH = "1.9.0"
SRCREV = "94430008a583dd01bd80c4288f4efd5f454cc532"
>>>>>>>> upstream/1.9.0:meta-hailo-dsp/recipes-libhailodsp/libhailodsp/libhailodsp_1.9.0.bb

SRC_URI = "git://git@github.com/hailo-ai/hailodsp.git;protocol=https;branch=${BRANCH}"
S = "${WORKDIR}/git"
OECMAKE_SOURCEPATH = "${S}/libhailodsp"

DSP_COMPILATION_MODE ??= "release"
DEPENDS:prepend := "catch2 spdlog cli11 "
BUILD_TYPE = "${@bb.utils.contains('DSP_COMPILATION_MODE', 'release', 'Release', 'Debug', d)}"
EXTRA_OECMAKE:append = "-DCMAKE_BUILD_TYPE=${BUILD_TYPE}"
inherit cmake
