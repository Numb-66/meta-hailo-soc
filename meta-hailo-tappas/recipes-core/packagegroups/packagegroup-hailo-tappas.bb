SUMMARY = "Hailo Tappas requirements"
DESCRIPTION = "The minimal set of packages required to boot the system"

PACKAGE_ARCH = "${MACHINE_ARCH}"

inherit packagegroup

PACKAGEGROUP_DISABLE_COMPLEMENTARY = "1"
PACKAGES = "\
            packagegroup-hailo-tappas \
            packagegroup-hailo-tappas-dev-pkg"

RDEPENDS:${PN} = "\
    hailo-post-processes \
    libgsthailo \
    libgsthailotools"

RDEPENDS:${PN}-dev-pkg = "\
    packagegroup-hailo-tappas \
    tappas-apps \
    tappas-tracers \
    opencv \
        "

RDEPENDS:${PN}-dev-pkg:append:hailo15 = "\
    tappas-native-apps \
    "