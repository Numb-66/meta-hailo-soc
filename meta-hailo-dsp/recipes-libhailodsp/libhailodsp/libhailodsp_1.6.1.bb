DESCRIPTION = "libhailodsp - Hailo's API for DSP"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://LICENSE;md5=2740b88bd0ffad7eda222e6f5cd097f4"

BRANCH = "1.6.2-dev0"
SRCREV = "72e070a5e3b1771312d6ffd0d55a6af28e6a5ed8"

SRC_URI = "git://git@github.com/hailo-ai/hailodsp.git;protocol=https;branch=${BRANCH}"
S = "${WORKDIR}/git"
OECMAKE_SOURCEPATH = "${S}/libhailodsp"

DSP_COMPILATION_MODE ??= "release"
DEPENDS:prepend := "catch2 spdlog cli11 "
BUILD_TYPE = "${@bb.utils.contains('DSP_COMPILATION_MODE', 'release', 'Release', 'Debug', d)}"
EXTRA_OECMAKE:append = "-DCMAKE_BUILD_TYPE=${BUILD_TYPE}"
inherit cmake
