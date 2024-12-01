
EXTRA_OEMAKE:append = " DTC_FLAGS=-@"
# Add the gyro device tree overlay to the kernel on hailo15-sbc
KERNEL_OVERLAYS:hailo15-sbc = " ${LINUX_YOCTO_HAILO_BOARD_VENDOR}/hailo15-sbc-gyro.dtbo" 

KERNEL_DEVICETREE:append = " ${KERNEL_OVERLAYS}"
