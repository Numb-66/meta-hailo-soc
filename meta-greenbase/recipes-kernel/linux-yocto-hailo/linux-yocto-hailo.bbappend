FILESEXTRAPATHS:prepend := "${THISDIR}:"
SRC_URI:append = " file://fragment.cfg"

LINUX_YOCTO_HAILO_URI = "github.com/Numb-66/linux-yocto-hailo.git"
LINUX_YOCTO_HAILO_BRANCH = "1.7.1"
LINUX_YOCTO_HAILO_SRCREV = "0f13bef53f7231dbde789e7d160c5454ede3ad41"

LINUX_YOCTO_HAILO_BOARD_VENDOR = "greenbase"
