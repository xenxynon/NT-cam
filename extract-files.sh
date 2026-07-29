#!/bin/bash
#
# Copyright (C) 2025 The LineageOS Project
# SPDX-License-Identifier: Apache-2.0
#
# Extraction script for Nothing Camera (NTCAM)
#

set -e

NTCAM_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROPRIETARY_FILES="${NTCAM_DIR}/proprietary-files.txt"

SRC_DIR="$1"

if [ -z "${SRC_DIR}" ]; then
    echo "Usage: $0 </path/to/stock/dump>"
    exit 1
fi

if [ ! -d "${SRC_DIR}" ]; then
    echo "Error: Source directory '${SRC_DIR}' does not exist!"
    exit 1
fi

echo "[NTCAM] Extracting proprietary blobs from ${SRC_DIR}..."

while IFS= read -r line || [ -n "$line" ]; do
    # Skip comments and blank lines
    [[ "${line}" =~ ^#.*$ ]] && continue
    [[ -z "${line}" ]] && continue

    FILE="${line}"
    SRC_FILE="${SRC_DIR}/${FILE}"
    DEST_FILE="${NTCAM_DIR}/proprietary/${FILE}"

    if [ -f "${SRC_FILE}" ]; then
        mkdir -p "$(dirname "${DEST_FILE}")"
        cp "${SRC_FILE}" "${DEST_FILE}"
        echo "  Extracted: ${FILE}"
    else
        echo "  [WARNING] File missing from stock dump: ${FILE}"
    fi
done < "${PROPRIETARY_FILES}"

echo "[NTCAM] Applying patches..."

# Fix VINTF manifest XML if needed
MANIFEST_XML="${NTCAM_DIR}/proprietary/vendor/etc/vintf/manifest/vendor.noth.hardware.camera-service.xml"
if [ -f "${MANIFEST_XML}" ]; then
    cat << 'EOF' > "${MANIFEST_XML}"
<manifest version="1.0" type="device">
    <hal format="aidl">
        <name>vendor.noth.hardware.camera</name>
        <version>1</version>
        <interface>
            <name>INtCamService</name>
            <instance>default</instance>
        </interface>
        <fqname>INtCamService/default</fqname>
    </hal>
</manifest>
EOF
    echo "  Applied patch: vendor.noth.hardware.camera-service.xml"
fi

# Run setup-makefiles to auto-generate Android.bp & ntcam-vendor.mk
"${NTCAM_DIR}/setup-makefiles.sh"

echo "[NTCAM] Blob extraction and patching complete!"
