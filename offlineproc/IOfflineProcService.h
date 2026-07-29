/*
 * Copyright (C) 2024 The LineageOS Project
 * SPDX-License-Identifier: Apache-2.0
 *
 * Minimal native binder interface matching what libofflineproc_jni.so
 * expects at android::hardware::IOfflineProcService ("media.offline").
 *
 * The JNI lib:
 *   1. Calls defaultServiceManager()->getService("media.offline")
 *   2. Calls IOfflineProcService::asInterface(binder) → BpOfflineProcService
 *   3. Constructs OfflineProcClient (stubbed in libcamera_client_shim)
 *   4. Submits capture requests via the client→service binder path
 *
 * This pass-through service registers under "media.offline", accepts all
 * requests, and immediately returns success — no actual post-processing
 * is applied. The raw HAL capture output is used as-is.
 */

#pragma once

#include <binder/IBinder.h>
#include <binder/IInterface.h>
#include <utils/RefBase.h>
#include <utils/String16.h>

namespace android {
namespace hardware {

// -------------------------------------------------------------------------
// IOfflineProcService — abstract binder interface
// -------------------------------------------------------------------------
class IOfflineProcService : public IInterface {
public:
    // Confirmed descriptor from .rodata of libofflineproc_jni.so:
    // strings at 0x1c90 = "media.offline"
    DECLARE_META_INTERFACE(OfflineProcService);


    // Called by libofflineproc_jni.so to submit a capture frame for
    // offline post-processing. We return immediately with success.
    virtual status_t submitRequest(int32_t requestId) = 0;

    // Called to cancel a pending offline request.
    virtual status_t cancelRequest(int32_t requestId) = 0;

    // Binder transaction codes
    enum {
        SUBMIT_REQUEST = IBinder::FIRST_CALL_TRANSACTION,
        CANCEL_REQUEST,
    };
};

// -------------------------------------------------------------------------
// BpOfflineProcService — binder proxy (client side)
// -------------------------------------------------------------------------
class BpOfflineProcService : public BpInterface<IOfflineProcService> {
public:
    explicit BpOfflineProcService(const sp<IBinder>& binder);

    status_t submitRequest(int32_t requestId) override;
    status_t cancelRequest(int32_t requestId) override;
};

// -------------------------------------------------------------------------
// BnOfflineProcService — binder native (server side)
// -------------------------------------------------------------------------
class BnOfflineProcService : public BnInterface<IOfflineProcService> {
public:
    status_t onTransact(uint32_t code, const Parcel& data,
                        Parcel* reply, uint32_t flags = 0) override;
};

}  // namespace hardware
}  // namespace android
