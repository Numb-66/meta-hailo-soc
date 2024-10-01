DESCRIPTION = "Hailo SCU bootloader. \
               This recipe will download the SCU bootloader binary from AWS and add it to deploy"

inherit deploy
inherit hailo-cc312-sign

LICENSE = "Proprietary"
LIC_FILES_CHKSUM = "file://../LICENSE;md5=263ee034adc02556d59ab1ebdaea2cda"

BASE_URI = "https://hailo-hailort.s3.eu-west-2.amazonaws.com/Hailo15/1.5.0/scu-bl"
BL = "hailo15_scu_bl.bin"
BL_UNSIGNED = "${SCU_BL_UNSIGNED_BINARY_NAME}"
BL_CUSTOMER_SIGNED = "${SCU_BL_CUSTOMER_SIGNED_BINARY_NAME}"
LICENSE_FILE = "LICENSE"

scu_bl_cfg_targetdir = "/etc/scu_bl_cfg"

CONFIG_MANAGER_PY = "scu_bootloader_config_manager.py"

BL_FILES = "${BASE_URI}/${BL};name=bl ${BASE_URI}/${BL_UNSIGNED};name=bl_unsigned ${BASE_URI}/${LICENSE_FILE};name=lic"
CONFIG_JSONS = "scu_bl_cfg_a.json"
SRC_URI = "file://scu_bootloader_config_manager.py \
           ${BL_FILES}"

SRC_URI[bl.sha256sum] = "ea74936430cff833f3dbf003366cc448dbdbc9978b9d29b604ef09c463e40ca9"
SRC_URI[bl_unsigned.sha256sum] = "167ee4d9da3a183227c700c605bf669b0ade0fd5635ee82e0fd626eab7fd02fe"
SRC_URI[lic.sha256sum] = "ca96445e6e33ae0a82170ea847b0925c864492f0cbb6342d42c54fd647133608"

python() {
    import os

    config_jsons = d.getVar('CONFIG_JSONS')

    for config_json in config_jsons.split():
        d.appendVar('SRC_URI', ' file://' + config_json)
        d.appendVar('FILES:' + d.getVar('PN'), ' ${scu_bl_cfg_targetdir}/' + os.path.basename(config_json))
}

do_sign() {
  if [ -n "${HAS_CUSTOMER_ROT_KEY}" ]; then
    hailo15_scu_firmware_sign ${WORKDIR}/${BL_UNSIGNED} ${WORKDIR}/${BL_CUSTOMER_SIGNED}
  fi
}

addtask sign after do_compile before do_install

do_install() {
  install -m 0755 -d ${D}${scu_bl_cfg_targetdir}

  # Loop through each json file
  for json_file_name in ${CONFIG_JSONS}; do
    # Run the python script to create the binary file
    ${WORKDIR}/${CONFIG_MANAGER_PY} --scu-bl-cfg-json ${WORKDIR}/${json_file_name} --scu-bl-cfg-bin ${WORKDIR}/"${json_file_name%.json}.bin"

    # Install the binary files to the appropriate location
    install -m 0500 ${WORKDIR}/"${json_file_name%.json}.bin" ${D}/${scu_bl_cfg_targetdir}
  done
}


do_deploy() {
  install -m 644 -D ${WORKDIR}/${BL} ${DEPLOYDIR}/${BL}

  # Install all the scu bl cfg binary files to the deploy directory
  for json in ${CONFIG_JSONS}; do
    install -m 644 -D ${WORKDIR}/"${json%.json}.bin" ${DEPLOYDIR}
  done
}

addtask deploy after do_install
