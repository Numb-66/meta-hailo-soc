FILESEXTRAPATHS:prepend := "${THISDIR}:"
SRC_URI:append = " file://fragment.cfg"

LINUX_YOCTO_HAILO_URI = "github.com/Numb-66/linux-yocto-hailo.git"
LINUX_YOCTO_HAILO_BRANCH = "1.6.0"
LINUX_YOCTO_HAILO_SRCREV = "55a5d8b1130a8019ecab1e43303d98284ed44bef"

LINUX_YOCTO_HAILO_BOARD_VENDOR = "greenbase"
