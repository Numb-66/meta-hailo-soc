DESCRIPTION = "Media Library vision control application \
               fetches the client application that allows control media library image properties"

LICENSE = "CLOSED"
LIC_FILES_CHKSUM = ""

SRC_URI = "sftp://hailo@192.168.12.21:/mnt/v02/sdk/validation/vision_app_releases/2024-11-15_14-58-46/vision_control.tar.gz"
SRC_URI[sha256sum] = "32f44faec55ed70e7c9db94d142515ba8df591f80f7b7d3fd5164af7bc93c12d"

ROOTFS_CONFIGS_DIR = "${D}/usr/share/hailo/webpage"
S = "${WORKDIR}/vision_control"

do_install() {
	# install config path on the rootfs
    install -d ${ROOTFS_CONFIGS_DIR}
	    # copy the required files into the config path
    cp -R --no-dereference --preserve=mode,links -v ${S}/* ${ROOTFS_CONFIGS_DIR}
}

FILES:${PN} += " /usr/share/hailo/webpage/*"
