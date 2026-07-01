FILESEXTRAPATHS:prepend := "${THISDIR}:"
SRC_URI:append = " file://fragment.cfg"

LINUX_YOCTO_HAILO_URI = "github.com/Numb-66/linux-yocto-hailo.git"
LINUX_YOCTO_HAILO_BRANCH = "1.11.0"
LINUX_YOCTO_HAILO_SRCREV = "f0b62ea1a9f5e84d24dbf3ed06be77c1b9d92b73"

LINUX_YOCTO_HAILO_BOARD_VENDOR = "greenbase"
