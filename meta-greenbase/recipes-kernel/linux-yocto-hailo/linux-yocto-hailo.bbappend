FILESEXTRAPATHS:prepend := "${THISDIR}:"
SRC_URI:append = " file://fragment.cfg"

LINUX_YOCTO_HAILO_URI = "github.com/Numb-66/linux-yocto-hailo.git"
LINUX_YOCTO_HAILO_BRANCH = "1.5.2_test2"
LINUX_YOCTO_HAILO_SRCREV = "./meta-greenbase/recipes-kernel/linux-yocto-hailo/linux-yocto-hailo.bbappend"

LINUX_YOCTO_HAILO_BOARD_VENDOR = "greenbase"
