#!/bin/bash

# This script is used to update the Hailo15 board firmware and image at the Flash and eMMC (or SD) via the UART.

# For flash programming we use the same well-known method.
# For the eMMC programming the script compress the image and send it at high UART speed.
# The U-Boot will decompress the image and write it to the eMMC.

# Performs multiple critical steps: 
# Validates file paths
# Updates U-Boot environment
# Compresses system image
# Loads recovery firmware
# Programs flash memory
# Loads U-Boot and Linux image
# Decompresses and writes system image
# Updates boot environment

# Usage: u-boot-load-logs.sh [OPTIONS]
#        -h|--help: show help.
#        -i|--image-path: default: ../hailo-yocto-validation/build/tmp/deploy/images/hailo15-sbc.
#        -l|--log-path: default: /local/users/git-nadav/mercury_validation/logs/.
#        -m|--machine: Yocto machine-name. default: hailo15-sbc.
#        -t|--image-type: Image type. default: minimal.
#        -c|--mmc: mmc to program (0 or 1). default: 1.
#        -d|--serial-device: serial device. default: /dev/ttyUSB0.

declare -r SCRIPT=$(basename $0)
declare -i PID=$$
declare -r LOCK_FILE="/tmp/$SCRIPT.lock"

# Configuration
declare -i SLOW_BAUD=115200
declare -i FAST_BAUD=921600
declare -i MEMORY_ADDR_COMPRESS_IMAGE=0x145000000

# Paths
declare F_MACHINE="hailo15-sbc"
declare F_IMAGE_TYPE="minimal"
declare F_PATH_OF_IMAGE="../hailo-yocto-validation/build/tmp/deploy/images/hailo15-sbc"
declare F_PATH_OF_LOGS="$(pwd)/logs"
declare F_MMC_TO_PROGRAM=1
declare F_SERIAL_DEVICE="/dev/ttyUSB0"
trap 'trap_func' TERM INT
trap_func()
{
    local p
    echo "$SCRIPT interrupted. Exiting."
    rm -rf $LOCK_FILE
}

# @brief script usage.
#
# @return 0(ok)
#
function usage()
{
    echo "Usage: $SCRIPT [OPTIONS]"
    echo "       -h|--help: show help."
    echo "       -i|--image-path: default: $F_PATH_OF_IMAGE."
    echo "       -l|--log-path: default: $F_PATH_OF_LOGS."
    echo "       -m|--machine: Yocto machine-name. default: $F_MACHINE."
    echo "       -t|--image-type: Image type. default: $F_IMAGE_TYPE."
    echo "       -c|--mmc: mmc to program (0 or 1). default: $F_MMC_TO_PROGRAM."
    echo "       -d|--serial-device: serial device. default: $F_SERIAL_DEVICE."
    return 0
}

# Set strict mode for better error handling
set -euo pipefail

# Color Codes
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# Logging Functions
log_info() {
    echo -e "${GREEN}[INFO]$(date "+%Y-%m-%d %H:%M:%S")${NC} $*"
}

log_warn() {
    echo -e "${YELLOW}[WARN]$(date "+%Y-%m-%d %H:%M:%S")${NC} $*"
}

log_error() {
    echo -e "${RED}[ERROR]$(date "+%Y-%m-%d %H:%M:%S")${NC} $*"
}


# Path Validation
validate_paths() 
{
    if [[ ! -d "$F_PATH_OF_IMAGE" ]]; then
        log_error "Image path does not exist: $F_PATH_OF_IMAGE"
        return 1
    fi

    return 0
}

# Execute Command with Logging
execute_command() {
    log_info "Executing: $*"
    if ! "$@"; then
        log_error "Command failed: $*"
        return 1
    fi
    return 0
}


function update_uboot_env_locally()
{
    log_info "Updating U-Boot initial environment"
    sed -i 's/^spl_boot_source=.*/spl_boot_source=uart/g' "$F_PATH_OF_IMAGE/u-boot-initial-env"
    sed -i 's/^bootdelay=.*/bootdelay=0/g' "$F_PATH_OF_IMAGE/u-boot-initial-env"
    sed -i 's/^auto_uboot_update_enable=.*/auto_uboot_update_enable=yes/g' "$F_PATH_OF_IMAGE/u-boot-initial-env"

    return 0
}

function compress_wic_image()
{
    log_info "Compressing WIC image"
    cp "$F_PATH_OF_IMAGE/core-image-${F_IMAGE_TYPE}-${F_MACHINE}.wic" "$F_PATH_OF_IMAGE/image.wic"
    gzip -f -9 "$F_PATH_OF_IMAGE/image.wic"

    return $?
}

function load_uart_recovery_fw()
{
    log_info "Loading UART recovery firmware"
    execute_command "uart_boot_fw_loader" \
        --firmware "$F_PATH_OF_IMAGE/hailo15_uart_recovery_fw.bin" \
        --serial-device-name "$F_SERIAL_DEVICE"

    return $?
}

function program_flash()
{
    log_info "Flashing SCU and U-Boot SPL"
    execute_command "hailo15_spi_flash_program" \
        --scu-bootloader "$F_PATH_OF_IMAGE/hailo15_scu_bl.bin" \
        --scu-bootloader-config "$F_PATH_OF_IMAGE/scu_bl_cfg_a.bin" \
        --scu-firmware "$F_PATH_OF_IMAGE/hailo15_scu_fw.bin" \
        --bootloader "$F_PATH_OF_IMAGE/u-boot-spl.bin" \
        --bootloader-env "$F_PATH_OF_IMAGE/u-boot-initial-env" \
        --customer-certificate "$F_PATH_OF_IMAGE/customer_certificate.bin" \
        --uboot-device-tree "$F_PATH_OF_IMAGE/u-boot.dtb.signed" \
        --uart-load \
        --serial-device-name "$F_SERIAL_DEVICE"

    sleep 3

    return $?
}

function load_uboot()
{
    log_info "Loading U-Boot via UART"
    stty -F "$F_SERIAL_DEVICE" "${SLOW_BAUD}"
    sz -b -vv "$F_PATH_OF_IMAGE/u-boot-tfa.itb" < "$F_SERIAL_DEVICE" > "$F_SERIAL_DEVICE"

    sleep 10

    return $?
}

function load_linux_image(){
    log_info "Preparing U-Boot for WIC image loading"
    echo "loady $(printf "0x%x" "$MEMORY_ADDR_COMPRESS_IMAGE") ${FAST_BAUD}" > "$F_SERIAL_DEVICE"
    sleep 2
    echo "" > "$F_SERIAL_DEVICE"
    sleep 2

    log_info "Loading compressed Linux WIC image via UART"
    stty -F "$F_SERIAL_DEVICE" "${FAST_BAUD}"
    sz -b -vv "$F_PATH_OF_IMAGE/image.wic.gz" < "$F_SERIAL_DEVICE" > "$F_SERIAL_DEVICE"
    sleep 10

    # Prepare for Final Steps
    stty -F "$F_SERIAL_DEVICE" "${SLOW_BAUD}"
    sleep 2

    log_info "Stopping loady"
    echo -e '\e' > "$F_SERIAL_DEVICE"
    sleep 2

    log_info "Cleaning up compressed image file"
    rm "$F_PATH_OF_IMAGE/image.wic.gz"
}

function decompress_wic_file_at_uboot() 
{
    log_info "Decompressing wic file image at U-Boot console"
    echo "unzip $(printf "0x%x" "$MEMORY_ADDR_COMPRESS_IMAGE") \${far_ram_addr}" > "$F_SERIAL_DEVICE"
    sleep 300
}

function update_uboot_env_at_flash()
{
    log_info "update uboot env at flash"
    echo "env set bootmenu_0 Autodetect=run boot_mmc${F_MMC_TO_PROGRAM}" > "$F_SERIAL_DEVICE"
    sleep 2
    echo "env save" > "$F_SERIAL_DEVICE"
    sleep 2
    echo "run set_mmc${F_MMC_TO_PROGRAM}_device_num && run write_wic_to_mmc && run boot_mmc${F_MMC_TO_PROGRAM}" > "$F_SERIAL_DEVICE"
    sleep 300
}

# Main Update Process
main() {

    # Logging Setup
    mkdir -p "$F_PATH_OF_LOGS"
    LOG_FILE="${F_PATH_OF_LOGS}/board_update_$(date +"%Y%m%d_%H%M%S").log"
    exec > >(tee -a "$LOG_FILE") 2>&1

    log_info "Starting Hailo15 Board Update Process"
    validate_paths || return $?

    update_uboot_env_locally

    compress_wic_image

    log_info "Set boot strap to UART and Rebooting board and press Enter to continue..."
    read # This adds a prompt and waits for Enter key

    load_uart_recovery_fw || return $?

    program_flash

    log_info "Set boot strap to FLASH and Rebooting board and press Enter to continue..."
    read # This adds a prompt and waits for Enter key

    load_uboot || return $?

    load_linux_image

    decompress_wic_file_at_uboot

    update_uboot_env_at_flash

    log_info "Board update process completed successfully!"
    log_info "Detailed log saved to: $LOG_FILE"
}

#------------------------------------------------------------------------------
#                               MAIN
#------------------------------------------------------------------------------
(
  flock -xn 200 || { echo "$SCRIPT double invocation. Aborting."; exit 1; }
 
  OPTS_SHORT="hi:l:m:t:c:d:"   # Legal short options
  OPTS_LONG="help,image-path:,log-path:,machine:,image-type:,mmc:,serial-device:" # Legal long options
  # $PARSED_OPTIONS will contain the legal arguments out of "$@".
  # If illegal/unrecognized arguments are given then this command fails.
  PARSED_OPTIONS=$(getopt -n "$0" -o $OPTS_SHORT -l $OPTS_LONG  -- "$@")
 
  # Bad arguments or something has gone wrong with the getopt command.
  [ $? -ne 0 ] && rm -rf $LOCK_FILE && exit 1
 
  eval set -- "$PARSED_OPTIONS"     # Set the positional parameters ($1, $2, etc)
 
  # Now go through all the options with a case and using shift to analyze 1 argument at a time.
  # $1 always identifies the argument to analyze due to the use of 'shift'.
  while true; do
    case "$1" in
    --help|-h) usage && exit 0;;
    --image-path|-i)  F_PATH_OF_IMAGE=$2; shift 2;;
    --log-path|-l)  F_PATH_OF_LOGS=$2; shift 2;;
    --machine|-m)  F_MACHINE=$2; shift 2;;
    --image-type|-t) F_IMAGE_TYPE=$2; shift 2;;
    --mmc|-c)  F_MMC_TO_PROGRAM=$2; shift 2;;
    --serial-device|-d)  F_SERIAL_DEVICE=$2; shift 2;;
    -- ) shift; break;;
    *  ) echo "Argument [$1] not handled."; shift; break;;
    esac
  done
 
  main "$@"
  rm -rf $LOCK_FILE
  exit $?
 
) 200>$LOCK_FILE