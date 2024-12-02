DESCRIPTION = "Basic bash configuration for hailo images"
LICENSE = "CLOSED"

S = "${WORKDIR}"

FILESEXTRAPATHS:prepend:hailo15 := "${THISDIR}/files/:"
SRC_URI:append:hailo15 = "file://inputrc;striplevel=3 file://bashrc;striplevel=3 file://profile;striplevel=3 file://glib_always_malloc.sh;striplevel=3"

do_install:append () {
  install -d                                     ${D}${ROOT_HOME}
  install -m 0755 ${S}/bashrc                    ${D}${ROOT_HOME}/.bashrc
  install -m 0755 ${S}/profile                   ${D}${ROOT_HOME}/.profile
  install -m 0600 ${S}/inputrc                   ${D}${ROOT_HOME}/.inputrc

  install -d ${D}${sysconfdir}/profile.d
  install -m 0600 ${S}/glib_always_malloc.sh     ${D}${sysconfdir}/profile.d/glib_always_malloc.sh
}

FILES:${PN} += "/home/root /home/root/.bashrc /home/root/.profile /home/root/.inputrc /etc/profile.d/glib_always_malloc.sh"

