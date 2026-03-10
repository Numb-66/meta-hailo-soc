FILESEXTRAPATHS:prepend := "${THISDIR}:"
SRC_URI:append = " file://fragment.cfg"

LINUX_YOCTO_HAILO_URI = "github.com/Numb-66/linux-yocto-hailo.git"
LINUX_YOCTO_HAILO_BRANCH = "1.10.0"
LINUX_YOCTO_HAILO_SRCREV = "f3620a79ef0799cbe9d3405a29b0ed26c402cc38"

LINUX_YOCTO_HAILO_BOARD_VENDOR = "greenbase"
