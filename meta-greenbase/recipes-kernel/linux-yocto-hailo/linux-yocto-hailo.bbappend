FILESEXTRAPATHS:prepend := "${THISDIR}:"
SRC_URI:append = " file://fragment.cfg"

LINUX_YOCTO_HAILO_URI = "github.com/Numb-66/linux-yocto-hailo.git"
LINUX_YOCTO_HAILO_BRANCH = "1.5.2_test1"
LINUX_YOCTO_HAILO_SRCREV = "559d7783eff13877eda25b1ae54a4d3c38a4dae6"

LINUX_YOCTO_HAILO_BOARD_VENDOR = "greenbase"
