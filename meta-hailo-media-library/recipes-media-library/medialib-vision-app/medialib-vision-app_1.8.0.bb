DESCRIPTION = "Media Library vision control application \
               fetches the client application that allows control media library image properties"

LICENSE = "CLOSED"
LIC_FILES_CHKSUM = ""

<<<<<<<< HEAD:meta-hailo-media-library/recipes-media-library/medialib-vision-app/medialib-vision-app_1.7.1.bb
SRC_URI = "https://hailo-hailort.s3.eu-west-2.amazonaws.com/Hailo15/1.7.1/vision_control.tar.gz"
SRC_URI[sha256sum] = "fcb7a52895c81c14b5e8904bf6c8851f054ac4f5c6676fccd104e1a30d402ed8"
========
SRC_URI = "https://hailo-hailort.s3.eu-west-2.amazonaws.com/Hailo15/1.8.0/vision_control.tar.gz"
SRC_URI[sha256sum] = "a7119365a51a6e38e25dc2299c61adb06cd03181ca27cb0b3dd087f2ae12f45f"
>>>>>>>> upstream/1.8.0:meta-hailo-media-library/recipes-media-library/medialib-vision-app/medialib-vision-app_1.8.0.bb

ROOTFS_CONFIGS_DIR = "${D}/usr/share/hailo/webpage"
S = "${WORKDIR}/vision_control"

do_install() {
	# install config path on the rootfs
    install -d ${ROOTFS_CONFIGS_DIR}
	    # copy the required files into the config path
    cp -R --no-dereference --preserve=mode,links -v ${S}/* ${ROOTFS_CONFIGS_DIR}
}

FILES:${PN} += " /usr/share/hailo/webpage/*"
