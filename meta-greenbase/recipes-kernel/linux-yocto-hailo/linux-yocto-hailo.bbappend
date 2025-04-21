FILESEXTRAPATHS:prepend := "${THISDIR}:"
SRC_URI:append = " file://fragment.cfg"

LINUX_YOCTO_HAILO_URI = "github.com/Numb-66/linux-yocto-hailo.git"
LINUX_YOCTO_HAILO_BRANCH = "1.7.0"
LINUX_YOCTO_HAILO_SRCREV = "4406dd721594bf151c3b2aabdf6c89625598c04a"

LINUX_YOCTO_HAILO_BOARD_VENDOR = "greenbase"
