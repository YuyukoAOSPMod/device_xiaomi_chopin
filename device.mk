#
# Copyright (C) 2020 Android Open Source Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

DEVICE_PATH := device/xiaomi/chopin
CHOPIN_PREBUILT := device/xiaomi/chopin-prebuilts

# Installs gsi keys into ramdisk, to boot a GSI with verified boot.
$(call inherit-product, $(SRC_TARGET_DIR)/product/gsi_keys.mk)

# Enable updating of APEXes
$(call inherit-product, $(SRC_TARGET_DIR)/product/updatable_apex.mk)

# Setup dalvik vm configs
$(call inherit-product, frameworks/native/build/phone-xhdpi-6144-dalvik-heap.mk)

# Virtual A/B
$(call inherit-product, $(SRC_TARGET_DIR)/product/virtual_ab_ota.mk)

# Call proprietary blob setup
$(call inherit-product-if-exists, vendor/xiaomi/chopin/chopin-vendor.mk)

# Dynamic Partition
PRODUCT_USE_DYNAMIC_PARTITIONS := true
PRODUCT_BUILD_SUPER_PARTITION := false

#Suppot to compile recovery without msm headers
TARGET_HAS_GENERIC_KERNEL_HEADERS := true

# VNDK
PRODUCT_SHIPPING_API_LEVEL := 30
PRODUCT_TARGET_VNDK_VERSION := 31
PRODUCT_EXTRA_VNDK_VERSIONS := 31

# Boot animation
TARGET_SCREEN_HEIGHT := 2400
TARGET_SCREEN_WIDTH := 1080

# Audio
PRODUCT_COPY_FILES += \
    frameworks/av/services/audiopolicy/config/a2dp_audio_policy_configuration.xml:$(TARGET_COPY_OUT_PRODUCT)/vendor_overlay/$(PRODUCT_TARGET_VNDK_VERSION)/etc/a2dp_audio_policy_configuration.xml \
    frameworks/av/services/audiopolicy/config/a2dp_in_audio_policy_configuration.xml:$(TARGET_COPY_OUT_PRODUCT)/vendor_overlay/$(PRODUCT_TARGET_VNDK_VERSION)/etc/a2dp_in_audio_policy_configuration.xml \
    frameworks/av/services/audiopolicy/config/bluetooth_audio_policy_configuration.xml:$(TARGET_COPY_OUT_PRODUCT)/vendor_overlay/$(PRODUCT_TARGET_VNDK_VERSION)/etc/bluetooth_audio_policy_configuration.xml \
    $(LOCAL_PATH)/config/audio/audio_policy_configuration.xml::$(TARGET_COPY_OUT_PRODUCT)/vendor_overlay/$(PRODUCT_TARGET_VNDK_VERSION)/etc/audio_policy_configuration.xml

# A/B
AB_OTA_POSTINSTALL_CONFIG += \
    RUN_POSTINSTALL_system=true \
    POSTINSTALL_PATH_system=system/bin/otapreopt_script \
    FILESYSTEM_TYPE_system=ext4 \
    POSTINSTALL_OPTIONAL_system=true

AB_OTA_POSTINSTALL_CONFIG += \
    RUN_POSTINSTALL_vendor=true \
    POSTINSTALL_PATH_vendor=bin/checkpoint_gc \
    FILESYSTEM_TYPE_vendor=ext4 \
    POSTINSTALL_OPTIONAL_vendor=true

# Boot control HAL
PRODUCT_PACKAGES += \
    android.hardware.boot@1.1-mtkimpl.recovery \
    android.hardware.boot@1.1-mtkimpl

PRODUCT_PACKAGES_DEBUG += \
    bootctrl

# Build MT-PL-Utils
PRODUCT_PACKAGES += \
    mtk_plpath_utils \
    mtk_plpath_utils.recovery

# GCamGo Prebuilts
PRODUCT_PACKAGES += \
    GCamGoPrebuilts

# DT2W
PRODUCT_PACKAGES += \
    DT2W-Service-MT6891

# fastbootd
PRODUCT_PACKAGES += \
    fastbootd \
    android.hardware.fastboot@1.0-impl-mock

# Fstab in ramdisk
PRODUCT_PACKAGES += \
    fstab.mt6893 \
    fstab.emmc \
    fstab.ramdisk

# F2FS
PRODUCT_PACKAGES += \
    sg_write_buffer \
    f2fs_io \
    check_f2fs

# HIDL
PRODUCT_PACKAGES += \
    android.hidl.base@1.0 \
    android.hidl.manager@1.0 \
    libhidltransport

# IMS
PRODUCT_BOOT_JARS += \
    mediatek-common \
    mediatek-framework \
    mediatek-ims-base \
    mediatek-ims-common \
    mediatek-telecom-common \
    mediatek-telephony-base \
    mediatek-telephony-common

PRODUCT_PACKAGES += \
    ImsServiceBase \
    libshim_vtservice

PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/config/permissions/privapp-permissions-mediatek.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/permissions/privapp-permissions-mediatek.xml \
    $(LOCAL_PATH)/config/permissions/systemext-privapp-permissions-mediatek.xml:$(TARGET_COPY_OUT_SYSTEM_EXT)/etc/permissions/systemext-privapp-permissions-mediatek.xml

# Copy the kernel dtb from the prebuilts directory.
ifeq ($(IS_GLOBAL),true)
PRODUCT_COPY_FILES += \
    $(CHOPIN_PREBUILT)/base/Global/dtb.img:dtb.img
else
PRODUCT_COPY_FILES += \
    $(CHOPIN_PREBUILT)/base/China/dtb.img:dtb.img
endif

# Keylayout
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/config/keylayout/uinput-fpc.kl:$(TARGET_COPY_OUT_SYSTEM)/usr/keylayout/uinput-fpc.kl \
    $(LOCAL_PATH)/config/keylayout/uinput-goodix.kl:$(TARGET_COPY_OUT_SYSTEM)/usr/keylayout/uinput-goodix.kl \
    $(LOCAL_PATH)/config/keylayout/mtk-kpd.kl:$(TARGET_COPY_OUT_SYSTEM)/usr/keylayout/mtk-kpd.kl

PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/config/idc/uinput-fpc.idc:$(TARGET_COPY_OUT_SYSTEM)/usr/idc/uinput-fpc.idc \
    $(LOCAL_PATH)/config/idc/uinput-goodix.idc:$(TARGET_COPY_OUT_SYSTEM)/usr/idc/uinput-goodix.idc

# Lights
PRODUCT_PACKAGES += \
    android.hardware.lights-service.chopin

# Location Provider
ifeq ($(USE_CN_AGPS),true)
PRODUCT_PACKAGES += \
    AMapLocationProvider

PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/config/gps/gps_debug.conf:$(TARGET_COPY_OUT_PRODUCT)/vendor_overlay/$(PRODUCT_TARGET_VNDK_VERSION)/etc/gps_debug.conf
endif

# MtkInCallService
PRODUCT_PACKAGES += \
    MtkInCallService

# NFC
PRODUCT_PACKAGES += \
    NfcNci \
    com.android.nfc_extras \
    Tag \
    SecureElement

# Overlays
DEVICE_PACKAGE_OVERLAYS += \
    $(LOCAL_PATH)/overlay \
    $(LOCAL_PATH)/overlay-lineage

PRODUCT_PACKAGES += \
    FrameworkResOverlayChopin \
    WifiResOverlayChopin \
    SystemUIOverlayChopin \
    TelephonyOverlayChopin

# Power Perf
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/config/power/powerscntbl.xml:$(TARGET_COPY_OUT_PRODUCT)/vendor_overlay/$(PRODUCT_TARGET_VNDK_VERSION)/etc/powerscntbl.xml

# Rootdir
PRODUCT_PACKAGES += \
    init.recovery.mt6891.rc \
    init.recovery.mt6893.rc \
    init.recovery.usb.rc \
    init.mt6891.rc

# Screen density
PRODUCT_AAPT_CONFIG := xxxhdpi
PRODUCT_AAPT_PREF_CONFIG := xxxhdpi

# Xiaomi Parts
PRODUCT_PACKAGES += \
    XiaomiParts

# Soong namespaces
PRODUCT_SOONG_NAMESPACES += \
    $(LOCAL_PATH)

# Properties
include $(LOCAL_PATH)/config/prop/default.mk

# Update engine
PRODUCT_PACKAGES += \
    checkpoint_gc \
    otapreopt_script \
    update_engine \
    update_engine_sideload \
    update_verifier

PRODUCT_PACKAGES_DEBUG += \
    update_engine_client
