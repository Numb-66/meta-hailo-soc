FILESEXTRAPATHS:prepend := "${THISDIR}:"
SRC_URI:append = " file://fragment.cfg"

LINUX_YOCTO_HAILO_URI = "github.com/Numb-66/linux-yocto-hailo.git"
LINUX_YOCTO_HAILO_BRANCH = "1.7.0"
LINUX_YOCTO_HAILO_SRCREV = "d89d37fcf55b1ff7f2fed2ac82770d514b5efc6b"

LINUX_YOCTO_HAILO_BOARD_VENDOR = "greenbase"
