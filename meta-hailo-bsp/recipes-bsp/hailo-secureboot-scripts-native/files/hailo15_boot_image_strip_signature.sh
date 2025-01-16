#!/bin/sh

# stop on errors
set -e

if [ $# -ne 2 ]; then
    echo "Usage: ./hailo15_boot_image_strip_signature.sh [input_signed_binary_name] [output_binary_name]"
    exit 1
fi

# parse arguments
input_signed_binary_name=$(realpath $1)
output_binary_name=$(realpath $2)

# read the first 4 bytes from the input file
header=$(head -c 4 "${input_signed_binary_name}")

if [ "${header}" != "ccBS" ]; then
    echo "Error: The input file does not seem to be a hailo15 signed boot image"
    exit 1
fi

dd if="${input_signed_binary_name}" of="${output_binary_name}" bs=1 skip=868 status=none
