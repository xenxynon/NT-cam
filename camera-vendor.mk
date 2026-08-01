#
# Automatically generated file. DO NOT MODIFY
#

PRODUCT_SOONG_NAMESPACES += \
    vendor/nothing/camera

PRODUCT_COPY_FILES += \
    vendor/nothing/camera/proprietary/system_ext/etc/permissions/privapp-permissions-NothingExperience.xml:$(TARGET_COPY_OUT_SYSTEM_EXT)/etc/permissions/privapp-permissions-NothingExperience.xml \
    vendor/nothing/camera/proprietary/vendor/etc/camera/NdotFont/Ndot-55.otf:$(TARGET_COPY_OUT_VENDOR)/etc/camera/NdotFont/Ndot-55.otf \
    vendor/nothing/camera/proprietary/vendor/etc/camera/Robotofont/Roboto-55.ttf:$(TARGET_COPY_OUT_VENDOR)/etc/camera/Robotofont/Roboto-55.ttf \
    vendor/nothing/camera/proprietary/vendor/etc/camera/SansCJKFont/NotoSansCJK.ttc:$(TARGET_COPY_OUT_VENDOR)/etc/camera/SansCJKFont/NotoSansCJK.ttc \
    vendor/nothing/camera/proprietary/vendor/etc/camera/ntcamoverridesettings.txt:$(TARGET_COPY_OUT_VENDOR)/etc/camera/ntcamoverridesettings.txt \
    vendor/nothing/camera/proprietary/vendor/etc/camera/ntcamperflocksettings.json:$(TARGET_COPY_OUT_VENDOR)/etc/camera/ntcamperflocksettings.json \
    vendor/nothing/camera/proprietary/vendor/etc/init/vendor.noth.hardware.camera-service.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/vendor.noth.hardware.camera-service.rc

PRODUCT_PACKAGES += \
    libarcsoft_hdr_detection \
    libarcsoft_mf_superresolution \
    libcpion \
    libnelib \
    libntofflinepostproc \
    liboemcrypto \
    libprotobuf-cpp-full-21.7 \
    libprotobuf-cpp-lite-21.7 \
    libtrustedapploader \
    vendor.noth.hardware.camera-V1-ndk \
    vendor.noth.hardware.camera-service-impl \
    vendor.qti.hardware.camera.offlinecamera-V1-ndk \
    vendor.qti.hardware.camera.postproc@1.0 \
    libnelib \
    libofflineproc_jni \
    NothingProxy \
    NTCamera \
    NothingExperience \
    vendor.noth.hardware.camera-service.xml \
    vendor.noth.hardware.camera-service
