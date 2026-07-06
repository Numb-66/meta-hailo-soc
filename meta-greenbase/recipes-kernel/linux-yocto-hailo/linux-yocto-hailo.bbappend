FILESEXTRAPATHS:prepend := "${THISDIR}:"
SRC_URI:append = " file://fragment.cfg"

LINUX_YOCTO_HAILO_URI = "github.com/Numb-66/linux-yocto-hailo.git"
LINUX_YOCTO_HAILO_BRANCH = "1.12.0"
LINUX_YOCTO_HAILO_SRCREV = "6e55056506c4abfe5e4c2c9a5d9d9cd218d48872"

LINUX_YOCTO_HAILO_BOARD_VENDOR = "greenbase"
