# Nothing Camera (NTCAM) Port for Nothing Phone (Asteroids)

This repository contains the standalone, path-independent camera stack required to port and integrate the Nothing Camera (NTCAM) stack into Android 16 (AOSP/PixelOS) ROM trees for the Nothing Phone (Asteroids).

## Repo Structure

Modelled after `NullDebris/hardware_dolby` and standard LineageOS extract tools, this repository has a clean, root-level layout:
- `ntcam.mk`: Main entry makefile that handles all properties, SEPolicy directories, copy files, and inherits `ntcam-vendor.mk`.
- `extract-files.sh`: LineageOS-style extraction script (`./extract-files.sh </path/to/stock/dump>`) that extracts blobs from stock dump, applies patches, and runs `setup-makefiles.sh`.
- `setup-makefiles.sh`: Script that parses `proprietary-files.txt` and auto-generates `Android.bp` and `ntcam-vendor.mk`.
- `proprietary-files.txt`: Master list of proprietary blobs, APKs, shared libraries, VINTF fragments, and camera assets.
- `Android.bp`: Declarations for Soong prebuilts (libraries/APKs) and `libcamera_client_shim`.
- `ntcam-vendor.mk`: Auto-generated makefile declaring `PRODUCT_PACKAGES` and `PRODUCT_COPY_FILES`.
- `configs/`: Standalone configurations, permissions allowlists (`privapp-permissions-NTCamera.xml`), task profiles, and `init.ntcam.rc`.
- `sepolicy/`: Private, public, and vendor SELinux rules.
- `shim/`: Source code for `libcamera_client_shim` (exports `IOfflineProcService::asInterface`).
- `offlineproc/`: Native pass-through daemon (`android.hardware.offline_proc@1.0-service.nothing`) registered as `"media.offline"` to handle NTCAM post-processing binder calls.
- `nothing-fwk/`: Helper classes for Nothing-specific features.
- `proprietary/`: Proprietary binaries, libraries, resources, VINTF manifests, perflock configs, and APKs (`NTCamera.apk`, `NothingProxy.apk`, `libofflineproc_jni.so`).

## Integration

### 1. Placement
Clone this repository into your ROM source tree (e.g., under `vendor/nothing/camera`):

```bash
git clone git@github.com:fuzailmansuri/NT-cam.git vendor/nothing/camera
```

### 2. Makefile Inheritance
Inherit the configuration in your device's main product makefile (e.g., `device/nothing/asteroids/aosp_asteroids.mk` or equivalent):

```makefile
$(call inherit-product, vendor/nothing/camera/ntcam.mk)
```

> **Note**: If you clone this repository to a path other than `vendor/nothing/camera`, define the `NTCAM_PATH` variable before inheriting:
> ```makefile
> NTCAM_PATH := vendor/nothing/camera
> $(call inherit-product, $(NTCAM_PATH)/ntcam.mk)
> ```

## Included Fixes & Compliances

1. **VINTF Manifest & Framework Matrix (`INtCamService/default`)**: 
   - Bundled `/vendor/etc/vintf/manifest/vendor.noth.hardware.camera-service.xml` into `PRODUCT_PACKAGES`.
   - Registered `vendor.noth.hardware.camera` (AIDL `INtCamService/default`) and `vendor.qti.hardware.camera.postproc` (HIDL `IPostProcService/default`) in `framework_matrix_nothing.xml` to pass `checkvintf` and prevent `servicemanager` binder rejection crashes.
2. **RescueParty Boot Loop Prevention (`NothingProxy.apk`)**:
   - Removed crash-looping `NothingProxy.apk` via `PRODUCT_PACKAGES_REMOVE += NothingProxy` in device makefiles, resolving `ClassNotFoundException: FirebaseInitProvider` boot loops.
3. **Dual `libnelib.so` Soong Prebuilt Modules**:
   - Declared `libnelib` (`system_ext/lib64/libnelib.so`) and `libnelib_vendor` (`vendor/lib64/libnelib.so`) as `cc_prebuilt_library_shared` modules with `check_elf_files: false`.
   - Resolves Android 16 Soong `check-non-elf-file-timestamps` build errors and fixes UFS Client `canDoCapture session = null` IPC errors.
4. **Post-Processing Queue Bottleneck**:
   - `MaxRequestQueueDepth=6` configured in `vendor/etc/camera/ntcamoverridesettings.txt` to prevent `SIGSEGV` in `libntofflinepostproc.so`.
5. **MediaProvider Pending Item Save**:
   - Added privileged storage permissions (`WRITE_MEDIA_STORAGE`, `MANAGE_EXTERNAL_STORAGE`, `ACCESS_MEDIA_LOCATION`, `MANAGE_MEDIA`) to `privapp-permissions-NTCamera.xml`.
6. **Camera Perflock Frequencies**:
   - Added `ntcamperflocksettings.json` to boost CPU/GPU frequencies during multi-frame captures.
7. **Clean LineageOS Extraction Tooling**:
   - `./extract-files.sh` and `./setup-makefiles.sh` automatically manage `proprietary-files.txt` and generate `Android.bp` and `ntcam-vendor.mk`.
