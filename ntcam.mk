#
# Copyright (C) 2025 The LineageOS Project
# SPDX-License-Identifier: Apache-2.0
#
# Main integrated entry makefile for Nothing Camera (NTCAM) port
#

NTCAM_PATH ?= hardware/nothing/camera

# Soong Namespaces
PRODUCT_SOONG_NAMESPACES += $(NTCAM_PATH)

# Inherit auto-generated vendor makefile
$(call inherit-product-if-exists, $(NTCAM_PATH)/ntcam-vendor.mk)

# SEPolicy
BOARD_VENDOR_SEPOLICY_DIRS += $(NTCAM_PATH)/sepolicy/vendor
BOARD_VENDOR_SEPOLICY_DIRS += $(NTCAM_PATH)/offlineproc/sepolicy/vendor
SYSTEM_EXT_PUBLIC_SEPOLICY_DIRS += $(NTCAM_PATH)/sepolicy/public
SYSTEM_EXT_PUBLIC_SEPOLICY_DIRS += $(NTCAM_PATH)/offlineproc/sepolicy/public
SYSTEM_EXT_PRIVATE_SEPOLICY_DIRS += $(NTCAM_PATH)/sepolicy/private

# System & Vendor Properties
PRODUCT_VENDOR_PROPERTIES += \
    persist.vendor.camera.privapp.list=com.nothing.camera \
    vendor.camera.aux.packagelist=com.nothing.camera \
    ro.camera.req_fps_range=30,30 \
    persist.vendor.camera.physical.num=3

# Configuration Permissions, Allowlists, Task Profiles & Init Scripts
PRODUCT_COPY_FILES += \
    $(NTCAM_PATH)/configs/nothing-hiddenapi-package-allowlist.xml:$(TARGET_COPY_OUT_SYSTEM_EXT)/etc/sysconfig/nothing-hiddenapi-package-allowlist.xml \
    $(NTCAM_PATH)/configs/privapp-permissions-NTCamera.xml:$(TARGET_COPY_OUT_SYSTEM_EXT)/etc/permissions/privapp-permissions-NTCamera.xml \
    $(NTCAM_PATH)/configs/privapp-permissions-NothingProxy.xml:$(TARGET_COPY_OUT_SYSTEM_EXT)/etc/permissions/privapp-permissions-NothingProxy.xml \
    $(NTCAM_PATH)/configs/linker.config.json:$(TARGET_COPY_OUT_VENDOR)/etc/linker.config.json \
    $(NTCAM_PATH)/configs/task_profiles.json:$(TARGET_COPY_OUT_VENDOR)/etc/task_profiles.json \
    $(NTCAM_PATH)/configs/init/init.ntcam.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/init.ntcam.rc \
    $(NTCAM_PATH)/proprietary/vendor/etc/init/vendor.noth.hardware.camera-service.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/vendor.noth.hardware.camera-service.rc

# Camera Calibration, Fonts, and Assets Copy Rules
PRODUCT_COPY_FILES += \
    $(NTCAM_PATH)/proprietary/system_ext/etc/permissions/privapp-permissions-NothingExperience.xml:$(TARGET_COPY_OUT_SYSTEM_EXT)/etc/permissions/privapp-permissions-NothingExperience.xml \
    $(NTCAM_PATH)/proprietary/system_ext/framework/androidx.camera.extensions.impl.advanced.jar:$(TARGET_COPY_OUT_SYSTEM_EXT)/framework/androidx.camera.extensions.impl.advanced.jar \
    $(NTCAM_PATH)/proprietary/vendor/etc/camera/NdotFont/Ndot-55.otf:$(TARGET_COPY_OUT_VENDOR)/etc/camera/NdotFont/Ndot-55.otf \
    $(NTCAM_PATH)/proprietary/vendor/etc/camera/Robotofont/Roboto-55.ttf:$(TARGET_COPY_OUT_VENDOR)/etc/camera/Robotofont/Roboto-55.ttf \
    $(NTCAM_PATH)/proprietary/vendor/etc/camera/SansCJKFont/NotoSansCJK.ttc:$(TARGET_COPY_OUT_VENDOR)/etc/camera/SansCJKFont/NotoSansCJK.ttc \
    $(NTCAM_PATH)/proprietary/vendor/etc/camera/ancsat/sat_mecp.bin:$(TARGET_COPY_OUT_VENDOR)/etc/camera/ancsat/sat_mecp.bin \
    $(NTCAM_PATH)/proprietary/vendor/etc/camera/ancsat/sat_mecp_plus.bin:$(TARGET_COPY_OUT_VENDOR)/etc/camera/ancsat/sat_mecp_plus.bin \
    $(NTCAM_PATH)/proprietary/vendor/etc/camera/basic_param.bin:$(TARGET_COPY_OUT_VENDOR)/etc/camera/basic_param.bin \
    $(NTCAM_PATH)/proprietary/vendor/etc/camera/bokeh_caldata_tele_golden.bin:$(TARGET_COPY_OUT_VENDOR)/etc/camera/bokeh_caldata_tele_golden.bin \
    $(NTCAM_PATH)/proprietary/vendor/etc/camera/bokeh_caldata_tele_golden_Pro.bin:$(TARGET_COPY_OUT_VENDOR)/etc/camera/bokeh_caldata_tele_golden_Pro.bin \
    $(NTCAM_PATH)/proprietary/vendor/etc/camera/bokeh_caldata_uw_golden.bin:$(TARGET_COPY_OUT_VENDOR)/etc/camera/bokeh_caldata_uw_golden.bin \
    $(NTCAM_PATH)/proprietary/vendor/etc/camera/bokeh_caldata_uw_golden_Pro.bin:$(TARGET_COPY_OUT_VENDOR)/etc/camera/bokeh_caldata_uw_golden_Pro.bin \
    $(NTCAM_PATH)/proprietary/vendor/etc/camera/decision.json:$(TARGET_COPY_OUT_VENDOR)/etc/camera/decision.json \
    $(NTCAM_PATH)/proprietary/vendor/etc/camera/decision_pro.json:$(TARGET_COPY_OUT_VENDOR)/etc/camera/decision_pro.json \
    $(NTCAM_PATH)/proprietary/vendor/etc/camera/facedetect/VegaDetect.model:$(TARGET_COPY_OUT_VENDOR)/etc/camera/facedetect/VegaDetect.model \
    $(NTCAM_PATH)/proprietary/vendor/etc/camera/facesr.model:$(TARGET_COPY_OUT_VENDOR)/etc/camera/facesr.model \
    $(NTCAM_PATH)/proprietary/vendor/etc/camera/lens_distortion_calibration.bin:$(TARGET_COPY_OUT_VENDOR)/etc/camera/lens_distortion_calibration.bin \
    $(NTCAM_PATH)/proprietary/vendor/etc/camera/nothing_node.bin:$(TARGET_COPY_OUT_VENDOR)/etc/camera/nothing_node.bin \
    $(NTCAM_PATH)/proprietary/vendor/etc/camera/nothing_pipeline.bin:$(TARGET_COPY_OUT_VENDOR)/etc/camera/nothing_pipeline.bin \
    $(NTCAM_PATH)/proprietary/vendor/etc/camera/ntcamoverridesettings.txt:$(TARGET_COPY_OUT_VENDOR)/etc/camera/ntcamoverridesettings.txt \
    $(NTCAM_PATH)/proprietary/vendor/etc/camera/plus_param.bin:$(TARGET_COPY_OUT_VENDOR)/etc/camera/plus_param.bin \
    $(NTCAM_PATH)/proprietary/vendor/etc/camera/sdk_params_back.json:$(TARGET_COPY_OUT_VENDOR)/etc/camera/sdk_params_back.json \
    $(NTCAM_PATH)/proprietary/vendor/etc/camera/sdk_params_front.json:$(TARGET_COPY_OUT_VENDOR)/etc/camera/sdk_params_front.json \
    $(NTCAM_PATH)/proprietary/vendor/etc/camera/vidhance.lic:$(TARGET_COPY_OUT_VENDOR)/etc/camera/vidhance.lic \
    $(NTCAM_PATH)/proprietary/vendor/etc/camera/vidhance_calibration:$(TARGET_COPY_OUT_VENDOR)/etc/camera/vidhance_calibration \
    $(NTCAM_PATH)/proprietary/vendor/etc/camera/vidhance_calibration_Plus:$(TARGET_COPY_OUT_VENDOR)/etc/camera/vidhance_calibration_Plus \
    $(NTCAM_PATH)/proprietary/odm/overlayfs_origin/base/etc/camera/camxoverridesettings.txt:$(TARGET_COPY_OUT_ODM)/overlayfs_origin/base/etc/camera/camxoverridesettings.txt \
    $(NTCAM_PATH)/proprietary/odm/overlayfs_origin/pro/etc/camera/camxoverridesettings.txt:$(TARGET_COPY_OUT_ODM)/overlayfs_origin/pro/etc/camera/camxoverridesettings.txt
