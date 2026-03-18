FILESEXTRAPATHS:prepend := "${THISDIR}:"
SRC_URI:append = " file://fragment.cfg"

LINUX_YOCTO_HAILO_URI = "github.com/Numb-66/linux-yocto-hailo.git"
LINUX_YOCTO_HAILO_BRANCH = "1.10.1"
LINUX_YOCTO_HAILO_SRCREV = "5370bfd335933b07a928881d1197e544affd3641"

LINUX_YOCTO_HAILO_BOARD_VENDOR = "greenbase"
