FILESEXTRAPATHS:prepend := "${THISDIR}:"
SRC_URI:append = " file://fragment.cfg"

LINUX_YOCTO_HAILO_URI = "github.com/Numb-66/linux-yocto-hailo.git"
LINUX_YOCTO_HAILO_BRANCH = "1.6.1"
LINUX_YOCTO_HAILO_SRCREV = "36a31d4f2671985797dfa559a3d228dcf7913d94"

LINUX_YOCTO_HAILO_BOARD_VENDOR = "greenbase"
