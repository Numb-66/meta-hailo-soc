DESCRIPTION = "Media Library Configuration files recipe \
               fetches the configuration files for the media library and sets hierarchy in /usr/lib"

LICENSE = "Proprietary"
LIC_FILES_CHKSUM = "file://${RESOURCES_DIR}/sensors/LICENSE;md5=263ee034adc02556d59ab1ebdaea2cda"

SRC_URI = "git://git@github.com/hailo-ai/hailo-media-library.git;protocol=https;branch=1.6.0"
SRC_URI += "https://hailo-hailort.s3.eu-west-2.amazonaws.com/Hailo15/1.6.0/hefs.tar.gz;name=hefs"
SRCREV = "cf22ce7d0088c2cec5538e78975f607fdb569a3a"
SRC_URI[hefs.sha256sum] = "bb12ce1ff8d15a8fa1495535a9107ece4b9625af7037bc776a0611f84466ec75"

S = "${WORKDIR}/git"
RESOURCES_DIR = "${S}/resources"
HEFS_DIR = "${WORKDIR}/hefs"

ROOTFS_APPS_DIR = "/home/root/apps"
ROOTFS_HOME_DIR = "/home/root"
ROOTFS_CONFIGS_DIR = "${D}/usr/lib/medialib"
VISION_GUI_DEFAULT_CONFIG ="default_config"
THEIA_4K_CONFIG_PATH = "imx678/theia_sl410m/4k"
KIT_4K_CONFIG_PATH = "imx678/kit_sc65a/4k"

do_install() {
    install -d ${ROOTFS_CONFIGS_DIR}

    # Copy the extracted files into the config path
    cp -R --no-dereference --preserve=mode,links -v ${RESOURCES_DIR}/* ${ROOTFS_CONFIGS_DIR}
    cp -R --no-dereference --preserve=mode,links -v ${HEFS_DIR}/* ${ROOTFS_CONFIGS_DIR}

    # copy media library resources
    install -d ${D}/${ROOTFS_APPS_DIR}/resources
    install -m 0755 ${RESOURCES_DIR}/sensors/${KIT_4K_CONFIG_PATH}/dewarp/cam_intrinsics.txt \
        ${D}/${ROOTFS_APPS_DIR}/resources/cam_intrinsics_678.txt
    install -m 0755 ${RESOURCES_DIR}/sensors/imx678/kit_sc65a/fhd/dewarp/cam_intrinsics.txt \
        ${D}/${ROOTFS_APPS_DIR}/resources/cam_intrinsics_imx678_fhd.txt
    install -m 0755 ${RESOURCES_DIR}/sensors/imx678/theia_sl410m/4k/dewarp/cam_intrinsics.txt \
        ${D}/${ROOTFS_APPS_DIR}/resources/cam_intrinsics_theia_678.txt
    install -m 0755 ${RESOURCES_DIR}/sensors/imx334/kit_sc65a/4k/dewarp/cam_intrinsics.txt \
        ${D}/${ROOTFS_APPS_DIR}/resources/cam_intrinsics_334.txt
    install -m 0755 ${RESOURCES_DIR}/sensors/${KIT_4K_CONFIG_PATH}/dewarp/cam_intrinsics.txt \
        ${D}/${ROOTFS_APPS_DIR}/resources/cam_intrinsics.txt

    ln -s -r ${ROOTFS_CONFIGS_DIR}/sensors/${THEIA_4K_CONFIG_PATH} \
        ${ROOTFS_CONFIGS_DIR}/${VISION_GUI_DEFAULT_CONFIG}

}

FILES:${PN} += " /usr/lib/medialib/* ${ROOTFS_APPS_DIR}/resources/*"
