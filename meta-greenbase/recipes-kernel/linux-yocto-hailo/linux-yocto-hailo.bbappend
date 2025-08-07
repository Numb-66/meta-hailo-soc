FILESEXTRAPATHS:prepend := "${THISDIR}:"
SRC_URI:append = " file://fragment.cfg"

LINUX_YOCTO_HAILO_URI = "github.com/Numb-66/linux-yocto-hailo.git"
LINUX_YOCTO_HAILO_BRANCH = "1.7.0-patched"
LINUX_YOCTO_HAILO_SRCREV = "0581e081967b6c5fdb5839517d256d7164621e65"

LINUX_YOCTO_HAILO_BOARD_VENDOR = "greenbase"
