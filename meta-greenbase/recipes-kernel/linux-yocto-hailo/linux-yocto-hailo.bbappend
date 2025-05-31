FILESEXTRAPATHS:prepend := "${THISDIR}:"
SRC_URI:append = " file://fragment.cfg"

LINUX_YOCTO_HAILO_URI = "github.com/Numb-66/linux-yocto-hailo.git"
LINUX_YOCTO_HAILO_BRANCH = "1.7.1"
LINUX_YOCTO_HAILO_SRCREV = "7f7f3ef536877aef5f659d7939a1bf02a2b99709"

LINUX_YOCTO_HAILO_BOARD_VENDOR = "greenbase"
