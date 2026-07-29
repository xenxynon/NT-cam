#
# Copyright (C) 2025 The LineageOS Project
# SPDX-License-Identifier: Apache-2.0
#
# Auto-generated file by setup-makefiles.sh. Do not edit directly.
#

NTCAM_PATH ?= hardware/nothing/camera

PRODUCT_SOONG_NAMESPACES += $(NTCAM_PATH)

PRODUCT_PACKAGES += \
    libcamera_client_shim \
    libui_shim \
    libarcsoft_hdr_detection \
    libarcsoft_mf_superresolution \
    libcpion \
    libtrustedapploader \
    libofflineproc_jni \
    vendor.noth.hardware.camera-V1-ndk \
    vendor.noth.hardware.camera-service-impl \
    vendor.noth.hardware.camera-service \
    vendor.noth.hardware.camera-service.xml \
    android.hardware.offline_proc@1.0-service.nothing \
    NothingProxy \
    NothingExperience \
    NTCamera

PRODUCT_COPY_FILES += \
    $(NTCAM_PATH)/proprietary/system_ext/etc/permissions/privapp-permissions-NothingExperience.xml:$(TARGET_COPY_OUT_SYSTEM_EXT)/etc/permissions/privapp-permissions-NothingExperience.xml \
    $(NTCAM_PATH)/proprietary/system_ext/lib64/libnelib.so:$(TARGET_COPY_OUT_SYSTEM_EXT)/lib64/libnelib.so \
    $(NTCAM_PATH)/proprietary/vendor/etc/camera/NdotFont/Ndot-55.otf:$(TARGET_COPY_OUT_VENDOR)/etc/camera/NdotFont/Ndot-55.otf \
    $(NTCAM_PATH)/proprietary/vendor/etc/camera/Robotofont/Roboto-55.ttf:$(TARGET_COPY_OUT_VENDOR)/etc/camera/Robotofont/Roboto-55.ttf \
    $(NTCAM_PATH)/proprietary/vendor/etc/camera/SansCJKFont/NotoSansCJK.ttc:$(TARGET_COPY_OUT_VENDOR)/etc/camera/SansCJKFont/NotoSansCJK.ttc \
    $(NTCAM_PATH)/proprietary/vendor/etc/camera/ntcamoverridesettings.txt:$(TARGET_COPY_OUT_VENDOR)/etc/camera/ntcamoverridesettings.txt \
    $(NTCAM_PATH)/proprietary/vendor/etc/camera/ntcamperflocksettings.json:$(TARGET_COPY_OUT_VENDOR)/etc/camera/ntcamperflocksettings.json
