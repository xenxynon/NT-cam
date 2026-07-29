# Nothing Camera (NTCAM) Port for Nothing Phone (Asteroids)

This repository contains the standalone, path-independent camera stack required to port and integrate the Nothing Camera (NTCAM) stack into Android 16 (AOSP/PixelOS) ROM trees for the Nothing Phone (Asteroids).

## Repo Structure

Modelled after `NullDebris/hardware_dolby`, this repository has a clean, root-level layout:
- `ntcam.mk`: The main entry makefile that handles all packages, copy files, sepolicy directories, and properties.
- `Android.bp`: Declarations for Soong prebuilts (libraries/APKs) and the camera client shim.
- `configs/`: Standalone configurations, permissions allowlists, vintf manifests, and the camera init script (`init.ntcam.rc`).
- `sepolicy/`: The private/public/vendor SELinux rules.
- `shim/`: Source code for `libcamera_client_shim` (exports `IOfflineProcService::asInterface`).
- `offlineproc/`: Native pass-through daemon (`android.hardware.offline_proc@1.0-service.nothing`) registered as `"media.offline"` to handle NTCAM post-processing binder calls.
- `nothing-fwk/`: Helper classes for Nothing-specific features.
- `proprietary/`: Proprietary binaries, libraries, resources, and APKs (`NTCamera.apk`, `NothingProxy.apk`, `libofflineproc_jni.so`).

## Integration

### 1. Placement
Clone this repository into your ROM source tree (e.g., under `hardware/nothing/camera`):

```bash
git clone git@github.com:fuzailmansuri/NT-cam.git hardware/nothing/camera
```

### 2. Makefile Inheritance
Inherit the configuration in your device's main product makefile (e.g., `device/nothing/asteroids/aosp_asteroids.mk` or equivalent):

```makefile
$(call inherit-product, hardware/nothing/camera/ntcam.mk)
```

> **Note**: If you clone this repository to a path other than `hardware/nothing/camera`, define the `NTCAM_PATH` variable before inheriting:
> ```makefile
> NTCAM_PATH := vendor/nothing/camera
> $(call inherit-product, $(NTCAM_PATH)/ntcam.mk)
> ```


## Features & Compliances

- **Clean Structure**: No bloated device or vendor directory duplication.
- **SELinux Neverallows**: Satisfies Google's Treble isolation. `/data/misc/cameraserver` is mapped to `camera_data_file` and accessed via the system-data violators bypass.
- **Standalone Init**: Dynamic cpuset (`ntcam-algo`) creation and camera calibration copies are moved to a separate `init.ntcam.rc` which is automatically loaded by init, leaving the main `init.asteroids.rc` untouched.
