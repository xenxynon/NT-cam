/*
 * Copyright (C) 2025 The LineageOS Project
 * SPDX-License-Identifier: Apache-2.0
 *
 * vendor.qti.hardware.camera.postproc@1.0-service.nothing
 *
 * Standalone HIDL daemon that loads service-impl and registers the
 * IPostProcService under the instance name "postprocservice".
 *
 * WHY THIS EXISTS:
 *   libntofflinepostproc.so hardcodes the lookup:
 *     IPostProcService::getService("postprocservice")
 *   The vendor.camera-provider RC only registers instance
 *   "camerapostprocservice" (a different name). Without this daemon,
 *   getService returns nullptr, PostProcCapabilities::operator= dereferences
 *   offset 0x4 of null, and vendor.noth.hardware.camera-service dies with
 *   SIGSEGV on every picture capture attempt.
 *
 *   service-impl.so exports: RegisterIPostProcService()
 *   which internally calls registerAsService("postprocservice").
 */

#define LOG_TAG "vendor.qti.hardware.camera.postproc@1.0-service"

#include <android/log.h>
#include <hidl/HidlTransportSupport.h>
#include <utils/Log.h>

using android::hardware::configureRpcThreadpool;
using android::hardware::joinRpcThreadpool;

// Exported by vendor.qti.hardware.camera.postproc@1.0-service-impl.so
// Mangled: _Z24RegisterIPostProcServicev
android::status_t RegisterIPostProcService();

int main(int /* argc */, char* /* argv */[]) {
    // Set FastRPC DSP library paths so FastRPC/CamX finds libhme_dsp_skel.so & other skels
    setenv("ADSP_LIBRARY_PATH", "/vendor/lib/rfsa/adsp;/vendor/dsp/cdsp;/vendor/dsp/adsp;/vendor/lib64/rfs/dsp", 1);
    setenv("CDSP_LIBRARY_PATH", "/vendor/lib/rfsa/adsp;/vendor/dsp/cdsp;/vendor/dsp/adsp;/vendor/lib64/rfs/dsp", 1);
    setenv("DSP_LIBRARY_PATH", "/vendor/lib/rfsa/adsp;/vendor/dsp/cdsp;/vendor/dsp/adsp;/vendor/lib64/rfs/dsp", 1);
    
    // Disable primary hardware V4L2 node opening (/dev/video0) during offline post-processor initialization
    setenv("overrideEnablePostProcHwInit", "0", 1);
    setenv("offlinePostProcDeviceOpen", "0", 1);

    // Change working directory to /vendor/lib/rfsa/adsp so relative ./libhme_dsp_skel.so lookups succeed
    if (chdir("/vendor/lib/rfsa/adsp") != 0) {
        ALOGW("Failed to chdir to /vendor/lib/rfsa/adsp: %s", strerror(errno));
    }

    ALOGI("vendor.qti.hardware.camera.postproc@1.0-service starting");

    // Allow up to 4 hwbinder threads (matches camera provider thread count)
    configureRpcThreadpool(4, true /* callerWillJoin */);

    android::status_t status = RegisterIPostProcService();
    if (status != android::OK) {
        ALOGE("RegisterIPostProcService() failed: %d — postprocservice will be unavailable", status);
        // Don't abort; the camera provider's camerapostprocservice instance
        // is still alive. Log and exit cleanly so init doesn't respawn in a loop.
        return 1;
    }

    ALOGI("IPostProcService/postprocservice registered successfully");
    joinRpcThreadpool();

    // Should never reach here
    return 0;
}
