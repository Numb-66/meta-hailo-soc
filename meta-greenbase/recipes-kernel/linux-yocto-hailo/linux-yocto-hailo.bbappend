FILESEXTRAPATHS:prepend := "${THISDIR}:"
SRC_URI:append = " file://fragment.cfg"

LINUX_YOCTO_HAILO_URI = "github.com/Numb-66/linux-yocto-hailo.git"
LINUX_YOCTO_HAILO_BRANCH = "1.6.0_test"
LINUX_YOCTO_HAILO_SRCREV = "27ecd0ef9ae8786b5d392017cadaad6f4b985bd9"

LINUX_YOCTO_HAILO_BOARD_VENDOR = "greenbase"
