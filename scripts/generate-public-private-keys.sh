#!/bin/bash

command -v nrfutil >/dev/null 2>&1 || { echo >&2 "I require nrfutil but it's not installed.  Aborting."; exit 1; }

PROJECT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && dirname $(pwd))"
OUTPUT_DIR="${PROJECT_DIR}/output/keys/"

#Create output directory for keys
mkdir -p ${OUTPUT_DIR}

#Generate private key - ref http://infocenter.nordicsemi.com/topic/com.nordic.infocenter.tools/dita/tools/nrfutil/nrfutil_keys_generate_display.html?cp=5_5_5
#and http://infocenter.nordicsemi.com/topic/com.nordic.infocenter.sdk5.v15.0.0/lib_bootloader_dfu_keys.html?cp=4_0_0_3_5_1_3
echo "Generate a private key in private.pem"
nrfutil keys generate ${OUTPUT_DIR}/private.pem

echo "Display the generated private key (in little-endian format)"
nrfutil keys display --key sk --format hex ${OUTPUT_DIR}private.pem

echo "Display the public key that corresponds to the generated private key"
echo "(in little-endian format)"
nrfutil keys display --key pk --format hex ${OUTPUT_DIR}private.pem

echo "Display the public key that corresponds to the generated private key"
echo "(in code format to be used with DFU)"
nrfutil keys display --key pk --format code ${OUTPUT_DIR}private.pem

echo "Write the public key that corresponds to the generated private key"
echo "to the file dfu_public_key.c (in code format)"
nrfutil keys display --key pk --format code ${OUTPUT_DIR}private.pem --out_file ${OUTPUT_DIR}dfu_public_key.c
