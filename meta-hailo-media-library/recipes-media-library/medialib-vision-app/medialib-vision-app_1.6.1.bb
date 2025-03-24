DESCRIPTION = "Media Library vision control application \
               fetches the client application that allows control media library image properties"

LICENSE = "CLOSED"
LIC_FILES_CHKSUM = ""

SRC_URI = "https://hailo-hailort.s3.eu-west-2.amazonaws.com/Hailo15/1.6.2-dev0/vision_control.tar.gz"
SRC_URI[sha256sum] = "cf5fc220ebb8689070a2e3eb1488c11337476f9b1565f3dd61883458db1e0f7f"

ROOTFS_CONFIGS_DIR = "${D}/usr/share/hailo/webpage"
S = "${WORKDIR}/vision_control"

do_install() {
	# install config path on the rootfs
    install -d ${ROOTFS_CONFIGS_DIR}
	    # copy the required files into the config path
    cp -R --no-dereference --preserve=mode,links -v ${S}/* ${ROOTFS_CONFIGS_DIR}
}

FILES:${PN} += " /usr/share/hailo/webpage/*"
