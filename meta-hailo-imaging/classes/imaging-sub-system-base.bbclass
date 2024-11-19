# imaging-sub-system base class - setting the code flow of imaging-sub-system installation. Allows recipes that inherits it to expand its functionality as needed

LIBS_FILES_TO_COPY ?= ""

copy_lib_files() {
    cp -R --no-dereference --preserve=mode,links -v ${B}/dist/lib/*${LIBS_FILES_TO_COPY} ${D}/lib
	cp -R --no-dereference --preserve=mode,links -v ${B}/dist/release/lib/*${LIBS_FILES_TO_COPY} ${D}/lib
}

install_isp_media_server() {
	install -m 0755 -D  ${B}/dist/release/bin/isp_media_server ${D}${bindir}
	install -m 0755 -D  ${S}/hailo_cfg/isp_media_server ${D}/etc/init.d
	ln -s -r ${D}/etc/init.d/isp_media_server ${D}/etc/rc5.d/S20isp_media_server
}

install_dist() {
	install -m 0644 -D  ${B}/dist/bin/sony_imx*.xml ${D}${bindir}
	install -m 0755 -D  ${B}/dist/bin/*.so ${D}${bindir}
	install -m 0755 -D  ${B}/dist/release/bin/*.json ${D}${bindir}
	install -m 0755 -D  ${B}/dist/release/bin/*.cfg ${D}${bindir}
	install -m 0755 -D  ${B}/dist/bin/raw_image_capture ${D}${bindir}
	install -m 0755 -D  ${B}/dist/bin/hailo_ctrl ${D}${bindir}
	install -m 0755 -D  ${S}/units/hailo/hdr_lib/hefs/hdr*.hef ${D}${bindir}
}

install_misc() {
	install -m 0755 -D  ${S}/mediacontrol/server/media_server_cfg*.json ${D}${bindir}
	
	install -d ${D}${includedir}/imaging
	cp ${S}/units/hailo/hdr_lib/src/*.hpp ${D}${includedir}/imaging
}

link_drivers() {
	ln -s -r ${D}/lib/libHAILO_IMX334.so ${D}${bindir}/HAILO_IMX334.drv
	ln -s -r ${D}/lib/libHAILO_IMX675.so ${D}${bindir}/HAILO_IMX675.drv
	ln -s -r ${D}/lib/libHAILO_IMX678.so ${D}${bindir}/HAILO_IMX678.drv
	ln -s -r ${D}/lib/libHAILO_IMX715.so ${D}${bindir}/HAILO_IMX715.drv
}

do_install() {
	install -d ${D}/lib
	install -d ${D}/etc
	install -d ${D}/etc/init.d
	install -d ${D}/etc/rc5.d
	install -d ${D}${bindir}

    copy_lib_files
	install_isp_media_server
    install_dist
	install_misc
	link_drivers
}

PACKAGES = "${PN} ${PN}-dev"
INSANE_SKIP:${PN}-dev =  "file-rpaths dev-so debug-files rpaths staticdev installed-vs-shipped"
INSANE_SKIP:${PN} =  "file-rpaths dev-so debug-files rpaths staticdev installed-vs-shipped"

# FIXME: why? arch? 
do_package_qa[noexec] = "1"
EXCLUDE_FROM_SHLIBS = "1"

FILES:${PN}     += "/lib/* /lib/*/*"
FILES:${PN}     += "${bindir}/*"
