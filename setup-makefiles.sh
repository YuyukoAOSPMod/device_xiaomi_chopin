#!/bin/bash
#
# Copyright (C) 2016 The CyanogenMod Project
# Copyright (C) 2017-2021 The LineageOS Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

set -e

export DEVICE=chopin
export VENDOR=xiaomi

INITIAL_COPYRIGHT_YEAR=2021

# Load extract_utils and do some sanity checks
MY_DIR="${BASH_SOURCE%/*}"
if [[ ! -d "${MY_DIR}" ]]; then MY_DIR="${PWD}"; fi

ANDROID_ROOT="${MY_DIR}/../../.."

HELPER="${ANDROID_ROOT}/tools/extract-utils/extract_utils.sh"
if [ ! -f "${HELPER}" ]; then
    echo "Unable to find helper script at ${HELPER}"
    exit 1
fi
source "${HELPER}"

# Initialize the helper for device
setup_vendor "${DEVICE}" "${VENDOR}" "${ANDROID_ROOT}" false

# Copyright headers and guards
write_headers "chopin"

# The standard blobs
write_makefiles "${MY_DIR}/proprietary-files.txt" true

VIBRATOR_XML="vendor_overlay/31/etc/vintf/manifest/vendor.xiaomi.hardware.vibratorfeature.service.xml"
printf '\n%s\n' "PRODUCT_COPY_FILES += \\" >> "$PRODUCTMK"
printf '    %s/proprietary/%s:$(TARGET_COPY_OUT_PRODUCT)/%s\n' \
                "$OUTDIR" "product/$VIBRATOR_XML" "$VIBRATOR_XML" >> "$PRODUCTMK"

# Finish
write_footers
