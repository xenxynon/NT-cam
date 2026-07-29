#include <vector>
#include <utils/StrongPointer.h>
#include <utils/RefBase.h>
#include <binder/IBinder.h>
#include "../offlineproc/IOfflineProcService.h"

struct native_handle;

namespace android {

class OfflineProcClientListener : public virtual RefBase {};

class OfflineProcClient {
public:
    OfflineProcClient();
    void setListener(const sp<OfflineProcClientListener>& listener);
};

OfflineProcClient::OfflineProcClient() {}
void OfflineProcClient::setListener(const sp<OfflineProcClientListener>& listener) {}

namespace hardware {

class OfflineParameters {
public:
    virtual ~OfflineParameters();
    OfflineParameters(
        std::vector<native_handle*> a,
        std::vector<native_handle*> b,
        std::vector<int> c,
        std::vector<int> d
    );
};

OfflineParameters::~OfflineParameters() {}

OfflineParameters::OfflineParameters(
    std::vector<native_handle*> a,
    std::vector<native_handle*> b,
    std::vector<int> c,
    std::vector<int> d
) {}

// IOfflineProcService::asInterface is implemented by IMPLEMENT_META_INTERFACE in IOfflineProcService.cpp

} // namespace hardware
} // namespace android
