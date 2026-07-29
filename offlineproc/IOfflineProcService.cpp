/*
 * Copyright (C) 2024 The LineageOS Project
 * SPDX-License-Identifier: Apache-2.0
 */

#define LOG_TAG "IOfflineProcService"

#include "IOfflineProcService.h"

#include <binder/Parcel.h>
#include <utils/Log.h>

namespace android {
namespace hardware {

IMPLEMENT_META_INTERFACE(OfflineProcService, "media.offline");


// -------------------------------------------------------------------------
// BpOfflineProcService
// -------------------------------------------------------------------------
BpOfflineProcService::BpOfflineProcService(const sp<IBinder>& binder)
    : BpInterface<IOfflineProcService>(binder) {}

status_t BpOfflineProcService::submitRequest(int32_t requestId) {
    Parcel data, reply;
    data.writeInterfaceToken(IOfflineProcService::getInterfaceDescriptor());
    data.writeInt32(requestId);
    status_t err = remote()->transact(SUBMIT_REQUEST, data, &reply);
    if (err != NO_ERROR) return err;
    return reply.readInt32();
}

status_t BpOfflineProcService::cancelRequest(int32_t requestId) {
    Parcel data, reply;
    data.writeInterfaceToken(IOfflineProcService::getInterfaceDescriptor());
    data.writeInt32(requestId);
    status_t err = remote()->transact(CANCEL_REQUEST, data, &reply);
    if (err != NO_ERROR) return err;
    return reply.readInt32();
}

// -------------------------------------------------------------------------
// BnOfflineProcService
// -------------------------------------------------------------------------
status_t BnOfflineProcService::onTransact(uint32_t code, const Parcel& data,
                                           Parcel* reply, uint32_t flags) {
    switch (code) {
        case SUBMIT_REQUEST: {
            CHECK_INTERFACE(IOfflineProcService, data, reply);
            int32_t requestId = data.readInt32();
            status_t res = submitRequest(requestId);
            reply->writeInt32(res);
            return NO_ERROR;
        }
        case CANCEL_REQUEST: {
            CHECK_INTERFACE(IOfflineProcService, data, reply);
            int32_t requestId = data.readInt32();
            status_t res = cancelRequest(requestId);
            reply->writeInt32(res);
            return NO_ERROR;
        }
        default:
            return BBinder::onTransact(code, data, reply, flags);
    }
}

}  // namespace hardware
}  // namespace android
