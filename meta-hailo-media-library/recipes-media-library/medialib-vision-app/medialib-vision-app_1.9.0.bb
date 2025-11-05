DESCRIPTION = "Media Library vision control application \
               fetches the client application that allows control media library image properties"

LICENSE = "CLOSED"
LIC_FILES_CHKSUM = ""

<<<<<<<< HEAD:meta-hailo-media-library/recipes-media-library/medialib-vision-app/medialib-vision-app_1.8.1.bb
SRC_URI = "https://hailo-hailort.s3.eu-west-2.amazonaws.com/CrossProducts/1.8.1/vision_control.tar.gz"
SRC_URI[sha256sum] = "6f66399c270157ca8ffd0e2764bac6950b241baab2e0580a62b420ae1cbf2e9f"
========
SRC_URI = "https://hailo-hailort.s3.eu-west-2.amazonaws.com/CrossProducts/1.9.0/vision_control.tar.gz"
SRC_URI[sha256sum] = "bd0b37f272dde74ccc58c278afb3869e0d31a6d42820aac8322ea63af80629c2"
>>>>>>>> upstream/1.9.0:meta-hailo-media-library/recipes-media-library/medialib-vision-app/medialib-vision-app_1.9.0.bb

ROOTFS_CONFIGS_DIR = "${D}/usr/share/hailo/webpage"
S = "${WORKDIR}/vision_control"

do_install() {
	# install config path on the rootfs
    install -d ${ROOTFS_CONFIGS_DIR}
	    # copy the required files into the config path
    cp -R --no-dereference --preserve=mode,links -v ${S}/* ${ROOTFS_CONFIGS_DIR}
}

FILES:${PN} += " /usr/share/hailo/webpage/*"
