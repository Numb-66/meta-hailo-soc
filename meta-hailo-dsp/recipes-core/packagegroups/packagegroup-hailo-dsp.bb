SUMMARY = "Hailo DSP requirements"
DESCRIPTION = "The set of packages required to enable DSP functionality"

PACKAGE_ARCH = "${MACHINE_ARCH}"

inherit packagegroup

PACKAGEGROUP_DISABLE_COMPLEMENTARY = "1"
PACKAGES = "\
            packagegroup-hailo-dsp \
            packagegroup-hailo-dsp-dev-pkg"

RDEPENDS:${PN} = "\
    dsp-fw \
    libhailodsp"

# Development package group
RDEPENDS:${PN}-dev-pkg = "\
    packagegroup-hailo-dsp \
    libhailodsp-dev"
