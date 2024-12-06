FILESEXTRAPATHS:prepend := "${THISDIR}:"
SRC_URI:append = " file://fragment.cfg"

LINUX_YOCTO_HAILO_URI = "github.com/Numb-66/linux-yocto-hailo.git"
LINUX_YOCTO_HAILO_BRANCH = "1.5.2_test1"
LINUX_YOCTO_HAILO_SRCREV = "a7970a153be976ad9707e9cf7557b4232c8c0583"

LINUX_YOCTO_HAILO_BOARD_VENDOR = "greenbase"


