FILESEXTRAPATHS:prepend := "${THISDIR}:"
SRC_URI:append = " file://fragment.cfg"

LINUX_YOCTO_HAILO_URI = "github.com/Numb-66/linux-yocto-hailo.git"
LINUX_YOCTO_HAILO_BRANCH = "1.9.0"
LINUX_YOCTO_HAILO_SRCREV = "1b2e90411400c695d8dd33c233ddcd498b08ea4c"

LINUX_YOCTO_HAILO_BOARD_VENDOR = "greenbase"
