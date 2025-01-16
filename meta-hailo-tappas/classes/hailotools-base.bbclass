# hailo-tools base class - setting the base configuration for meson (target, type, includes etc...)
# deppends on meta-hailo-libhailort recipes, opencv, xtensor and xtl

inherit tappas-base

S = "${WORKDIR}/git/core/hailo"

DEPENDS += " opencv xtensor xtl"

TAPPAS_BUILD_TARGET = "all"

TARGET_PLATFORM = "imx8"
TARGET_PLATFORM:hailo15 = "hailo15"

EXTRA_OEMESON += " \
        -Dlibxtensor='${STAGING_INCDIR}/xtensor' \
        -Dinclude_blas=false \
        -Dtarget='${TAPPAS_BUILD_TARGET}' \
        -Dtarget_platform='${TARGET_PLATFORM}' \
        "