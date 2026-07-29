/*
 * Copyright (C) 2024 The LineageOS Project
 * SPDX-License-Identifier: Apache-2.0
 *
 * OfflineProcService — pass-through server that registers as "media.offline"
 *
 * libofflineproc_jni.so calls:
 *   defaultServiceManager()->getService("media.offline")
 *   → IOfflineProcService::asInterface(binder)
 *
 * This service immediately returns OK to all capture submissions so that
 * NTCamera gets a success callback and proceeds to save the raw HAL output.
 */

#define LOG_TAG "OfflineProcService"

#include "IOfflineProcService.h"

#include <binder/IPCThreadState.h>
#include <binder/IServiceManager.h>
#include <binder/ProcessState.h>
#include <utils/Log.h>
#include <utils/String16.h>

namespace android {
namespace hardware {

class OfflineProcService : public BnOfflineProcService {
public:
    OfflineProcService() { ALOGI("OfflineProcService created"); }

    status_t submitRequest(int32_t requestId) override {
        // Pass-through: immediately return success.
        // NTCamera will use the unprocessed HAL capture output.
        ALOGD("submitRequest(id=%d) → returning OK (pass-through)", requestId);
        return NO_ERROR;
    }

    status_t cancelRequest(int32_t requestId) override {
        ALOGD("cancelRequest(id=%d) → returning OK", requestId);
        return NO_ERROR;
    }
};

}  // namespace hardware
}  // namespace android

int main(int /*argc*/, char* /*argv*/[]) {
    using namespace android;
    using namespace android::hardware;

    ALOGI("OfflineProcService starting (media.offline pass-through)");

    // Join a thread pool so we can accept binder calls
    ProcessState::self()->setThreadPoolMaxThreadCount(4);
    ProcessState::self()->startThreadPool();

    sp<OfflineProcService> service = new OfflineProcService();

    // Register under the name libofflineproc_jni.so looks up:
    //   kOfflineProcServiceName = "media.offline"
    status_t err = defaultServiceManager()->addService(
        String16("media.offline"), service);

    if (err != NO_ERROR) {
        ALOGE("Failed to register media.offline: %d", err);
        return 1;
    }

    ALOGI("media.offline registered successfully");
    IPCThreadState::self()->joinThreadPool();

    return 0;
}
