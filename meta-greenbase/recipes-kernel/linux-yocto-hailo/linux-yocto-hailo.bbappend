FILESEXTRAPATHS:prepend := "${THISDIR}:"
SRC_URI:append = " file://fragment.cfg"

LINUX_YOCTO_HAILO_URI = "github.com/Numb-66/linux-yocto-hailo.git"
LINUX_YOCTO_HAILO_BRANCH = "1.6.2-dev0"
LINUX_YOCTO_HAILO_SRCREV = "cf371d7697320e65e6bc7d8ea5f0f9438195c74d"

LINUX_YOCTO_HAILO_BOARD_VENDOR = "greenbase"
