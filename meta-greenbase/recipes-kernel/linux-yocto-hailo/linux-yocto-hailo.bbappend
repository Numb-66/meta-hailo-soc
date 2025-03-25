FILESEXTRAPATHS:prepend := "${THISDIR}:"
SRC_URI:append = " file://fragment.cfg"

LINUX_YOCTO_HAILO_URI = "github.com/Numb-66/linux-yocto-hailo.git"
LINUX_YOCTO_HAILO_BRANCH = "1.6.2-dev0"
LINUX_YOCTO_HAILO_SRCREV = "753267aaf1a38566f82c6d850e0c5971c2c4a752"

LINUX_YOCTO_HAILO_BOARD_VENDOR = "greenbase"
