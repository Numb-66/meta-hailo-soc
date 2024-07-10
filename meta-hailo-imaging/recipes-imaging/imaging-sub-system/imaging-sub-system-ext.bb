
inherit imaging-sub-system-base

INHERITS += " qmake5_paths"
RDEPENDS_IMAGING_SUB_SYSTEM += " qtmultimedia"
DEPENDS_IMAGING_SUB_SYSTEM += " qtbase-native ninja-native bash cmake-native qwt-qt5 qtbase qtdeclarative qtmultimedia qmllive boost"

install_isp_media_server:prepend() {
	install -m 0755 -D  ${B}/dist/bin/tuning-server ${D}${bindir}
	install -m 0755 -D  ${B}/dist/bin/tuning-lite ${D}${bindir}
}

install_isp_media_server:append() {
	install -m 0755 -D  ${B}/dist/bin/tuning-yuv-capture ${D}${bindir}
}

install_dist:append() {
	install -m 0644 -D  ${B}/dist/bin/HAILO_IMX334*.xml ${D}${bindir}
	install -m 0644 -D  ${B}/dist/bin/HAILO_IMX678*.xml ${D}${bindir}
	install -m 0755 -D  ${B}/dist/bin/raw_image_capture ${D}${bindir}
	install -m 0755 -D  ${B}/dist/bin/v4l_stream_example ${D}${bindir}
	install -m 0755 -D  ${B}/dist/bin/fe-read-reg ${D}${bindir}
	install -m 0755 -D  ${B}/dist/bin/v4l_ctrl_example ${D}${bindir}
	install -m 0755 -D  ${B}/dist/bin/hailo_ctrl ${D}${bindir}
	install -m 0755 -D  ${B}/dist/bin/fps ${D}${bindir}
	install -m 0755 -D  ${B}/dist/bin/mcm_manager ${D}${bindir}
	install -m 0755 -D  ${S}/units/hailo/mcm_manager/hdr*.hef ${D}${bindir}
    install -m 0755 -D  ${B}/dist/bin/v4l_event_handling_example ${D}${bindir}
}

link_drivers:prepend() {
	install -d ${D}${includedir}/imaging
	install -d ${D}${includedir}/imaging/cam_device
	install -d ${D}${includedir}/imaging/ebase
	install -d ${D}${includedir}/imaging/scmi
	install -d ${D}${includedir}/imaging/bufferpool
	install -d ${D}${includedir}/imaging/json
	install -d ${D}${includedir}/imaging/common
	install -d ${D}${includedir}/imaging/hal
	install -d ${D}${includedir}/imaging/oslayer
	install -d ${D}${includedir}/imaging/fpga
	install -d ${D}${includedir}/imaging/isi
	install -d ${D}${includedir}/imaging/cameric_drv
	
	cp -R --no-dereference --preserve=mode,links -v ${B}/dist/include/* ${D}${includedir}/imaging
	install -m 0755 -D ${S}/scripts/hailo_tuning_server.sh ${D}${bindir}
	install -m 0755 -D ${S}/scripts/hailo_tuning_server_nnhdr_fhd.sh ${D}${bindir}
	install -m 0755 -D ${S}/scripts/tuning_mcm_start.sh ${D}${bindir}
	install -m 0755 -D ${S}/scripts/capture_tool_sensor_params.py ${D}${bindir}


	# Add sensor/configuration specific setup scripts
	install -m 0755 -D ${S}/scripts/setup_imx*.sh ${D}${bindir}
	install -m 0755 -D ${S}/scripts/find_subdevice_path.sh ${D}${bindir}
	
	#install -m 0755 -D ${S}/scripts/*  ${D}${TARGET_SBIN_DIR}/scripts

	cp ${S}/units/cam_device/include/cam_device_2dnr/* ${D}${includedir}/imaging
	cp ${S}/units/cam_device/include/cam_device_3dnr/* ${D}${includedir}/imaging
	cp ${S}/units/cam_device/include/cam_device_gc2/* ${D}${includedir}/imaging
	cp ${S}/units/cam_device/include/cam_device_demosaic2/* ${D}${includedir}/imaging
	cp ${S}/units/cam_device/include/cam_device_wdr4/* ${D}${includedir}/imaging
	cp -R ${S}/units/common/include/* ${D}${includedir}/imaging
	cp ${S}/units/isi/include/* ${D}${includedir}/imaging
	cp ${S}/units/isi/include_priv/* ${D}${includedir}/imaging
	cp ${S}/units/3av2/include/* ${D}${includedir}/imaging
	cp -R ${S}/tuning-common/include/* ${D}${includedir}/imaging
	cp -R ${S}/utils3rd/include/* ${D}${includedir}/imaging
	cp -R ${S}/vvcam/v4l2/common/* ${D}${includedir}/imaging
	cp ${S}/vvcam/common/vvsensor.h ${D}${includedir}/imaging
	cp ${S}/vvcam/common/viv_video_kevent.h ${D}${includedir}/imaging
	cp -R ${S}/units/cam_device/include/* ${D}${includedir}/imaging/cam_device
	cp ${S}/units/ebase/include/* ${D}${includedir}/imaging/ebase
	cp ${S}/units/scmi/include/* ${D}${includedir}/imaging/scmi
	cp ${S}/units/bufferpool/include/* ${D}${includedir}/imaging/bufferpool
	cp ${S}/utils3rd/3rd/jsoncpp/include/json/* ${D}${includedir}/imaging/json
	cp ${S}/appshell/common/include/* ${D}${includedir}/imaging/common
	cp ${S}/units/hal/include/* ${D}${includedir}/imaging/hal
	cp ${S}/units/oslayer/include/* ${D}${includedir}/imaging/oslayer
	cp ${S}/units/fpga/fpga/include/* ${D}${includedir}/imaging/fpga
	cp ${S}/units/isi/include/* ${D}${includedir}/imaging/isi
	cp ${S}/units/cameric_drv/include/cameric_drv_common.h ${D}${includedir}/imaging/cameric_drv
}