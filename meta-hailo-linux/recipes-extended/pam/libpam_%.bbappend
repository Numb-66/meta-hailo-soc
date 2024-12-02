do_install:append() {
    # Enable pam_limits.so
    echo "session required pam_limits.so" >> ${D}${sysconfdir}/pam.d/common-session
    # Set limit of max open files
    echo "*       soft    nofile  ${FD_MAX_OPEN_FILES}" >> ${D}${sysconfdir}/security/limits.conf
}
