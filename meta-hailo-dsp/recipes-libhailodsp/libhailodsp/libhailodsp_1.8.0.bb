DESCRIPTION = "libhailodsp - Hailo's API for DSP"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://LICENSE;md5=2740b88bd0ffad7eda222e6f5cd097f4"

<<<<<<<< HEAD:meta-hailo-dsp/recipes-libhailodsp/libhailodsp/libhailodsp_1.7.1.bb
BRANCH = "1.7.1"
SRCREV = "acea0f34c716b08d7a73c6cbe1ba3eaadf908bc0"
========
BRANCH = "1.8.0"
SRCREV = "617e5cf5189d4442c904a7f87ac04d430a607b46"
>>>>>>>> upstream/1.8.0:meta-hailo-dsp/recipes-libhailodsp/libhailodsp/libhailodsp_1.8.0.bb

SRC_URI = "git://git@github.com/hailo-ai/hailodsp.git;protocol=https;branch=${BRANCH}"
S = "${WORKDIR}/git"
OECMAKE_SOURCEPATH = "${S}/libhailodsp"

DSP_COMPILATION_MODE ??= "release"
DEPENDS:prepend := "catch2 spdlog cli11 "
BUILD_TYPE = "${@bb.utils.contains('DSP_COMPILATION_MODE', 'release', 'Release', 'Debug', d)}"
EXTRA_OECMAKE:append = "-DCMAKE_BUILD_TYPE=${BUILD_TYPE}"
inherit cmake
