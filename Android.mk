#
# Copyright (C) 2020 The LineageOS Project
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

LOCAL_PATH := $(call my-dir)

ifneq ($(filter chopin choping,$(TARGET_DEVICE)),)

include $(call all-subdir-makefiles,$(LOCAL_PATH))

include $(CLEAR_VARS)

LIGHT_REPLACEMENT += $(TARGET_OUT_PRODUCT)/vendor_overlay/${PRODUCT_TARGET_VNDK_VERSION}/bin/hw/android.hardware.lights-service.mediatek
$(LIGHT_REPLACEMENT): $(LOCAL_INSTALLED_MODULE)
	@mkdir -p $(dir $@)
	$(hide) ln -s /system/bin/hw/$(notdir $@) $@

ALL_DEFAULT_INSTALLED_MODULES += $(LIGHT_REPLACEMENT)


CHOPIN_SYMLINK := $(addprefix $(TARGET_OUT_VENDOR)/, $(strip $(shell cat $(LOCAL_PATH)/symlink/mt6891_chopin.txt)))
$(CHOPIN_SYMLINK): $(LOCAL_INSTALLED_MODULE)
	@mkdir -p $(dir $@)
	$(hide) ln -sf mt6893/$(notdir $@) $@

ALL_DEFAULT_INSTALLED_MODULES += $(CHOPIN_SYMLINK)

endif
