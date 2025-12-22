FILESEXTRAPATHS:prepend := "${THISDIR}:"
SRC_URI:append = " file://fragment.cfg"

LINUX_YOCTO_HAILO_URI = "github.com/Numb-66/linux-yocto-hailo.git"
LINUX_YOCTO_HAILO_BRANCH = "1.9.1"
LINUX_YOCTO_HAILO_SRCREV = "56d6d26df848a08bda06c1194359de51da342d01"

LINUX_YOCTO_HAILO_BOARD_VENDOR = "greenbase"
