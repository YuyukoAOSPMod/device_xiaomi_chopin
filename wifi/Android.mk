LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)
LOCAL_MODULE := android.hardware.wifi@1.0-service-lazy.chopin.rc
LOCAL_MODULE_TAGS  := optional
LOCAL_MODULE_CLASS := ETC
LOCAL_MODULE_PATH := $(TARGET_OUT_VENDOR_ETC)/init
LOCAL_SRC_FILES := $(LOCAL_MODULE)
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE := android.hardware.wifi@1.0-service.chopin.xml
LOCAL_MODULE_TAGS  := optional
LOCAL_MODULE_CLASS := ETC
LOCAL_MODULE_PATH := $(TARGET_OUT_VENDOR_ETC)/vintf/manifest
LOCAL_SRC_FILES := $(LOCAL_MODULE)
include $(BUILD_PREBUILT)

LOCAL_PATH := hardware/interfaces/wifi/1.6/default

include $(CLEAR_VARS)
LOCAL_MODULE := android.hardware.wifi@1.0-service-lazy.chopin
LOCAL_MODULE_RELATIVE_PATH := hw
LOCAL_PROPRIETARY_MODULE := true
LOCAL_CPPFLAGS := -Wall -Werror -Wextra
LOCAL_CFLAGS := -DLAZY_SERVICE
LOCAL_C_INCLUDES := frameworks/opt/net/wifi/libwifi_hal/include
LOCAL_HEADER_LIBRARIES := libhardware_legacy_headers

LOCAL_REQUIRED_MODULES := \
    android.hardware.wifi@1.0-service-lazy.chopin.rc \
    android.hardware.wifi@1.0-service.chopin.xml

LOCAL_SRC_FILES := \
    service.cpp

LOCAL_SHARED_LIBRARIES := \
    libbase \
    libcutils \
    libhidlbase \
    liblog \
    libnl \
    libutils \
    libwifi-hal-mtk \
    libwifi-system-iface \
    libxml2 \
    android.hardware.wifi@1.0 \
    android.hardware.wifi@1.1 \
    android.hardware.wifi@1.2 \
    android.hardware.wifi@1.3 \
    android.hardware.wifi@1.4 \
    android.hardware.wifi@1.5 \
    android.hardware.wifi@1.6

LOCAL_STATIC_LIBRARIES := android.hardware.wifi@1.0-service-lib

include $(BUILD_EXECUTABLE)