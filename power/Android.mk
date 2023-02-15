LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)

LOCAL_MODULE := android.hardware.power-service-mediatek
LOCAL_VENDOR_MODULE := true
LOCAL_MULTILIB := 64
LOCAL_VINTF_FRAGMENTS := power-mediatek.xml
LOCAL_SRC_FILES := Power.cpp

LOCAL_SHARED_LIBRARIES := \
    libbase \
    libbinder_ndk \
    libpowerhal \
    android.hardware.power-V2-ndk

LOCAL_HEADER_LIBRARIES := generated_kernel_headers

include $(BUILD_SHARED_LIBRARY)
