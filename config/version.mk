# Copyright (C) 2016-2019 AOSiP
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Versioning System
BUILD_DATE := $(shell date +%Y%m%d)
TARGET_PRODUCT_SHORT := $(subst aosip_,,$(AOSIP_BUILDTYPE))

AOSIP_BUILDTYPE ?= DerpFest-Beta
AOSIP_BUILD_VERSION := 10
AOSIP_VERSION := $(AOSIP_BUILD_VERSION)-$(AOSIP_BUILDTYPE)-$(AOSIP_BUILD)-$(BUILD_DATE)
ROM_FINGERPRINT := AOSiP/$(PLATFORM_VERSION)/$(TARGET_PRODUCT_SHORT)/$(shell date -u +%H%M)

PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
  ro.aosip.build.version=$(AOSIP_BUILD_VERSION) \
  ro.aosip.build.date=$(BUILD_DATE) \
  ro.aosip.buildtype=$(AOSIP_BUILDTYPE) \
  ro.aosip.fingerprint=$(ROM_FINGERPRINT) \
  ro.aosip.version=$(AOSIP_VERSION) \
  ro.aosip.device=$(AOSIP_BUILD) \
  ro.modversion=$(AOSIP_VERSION)

ifneq ($(OVERRIDE_OTA_CHANNEL),)
    PRODUCT_PROPERTY_OVERRIDES += \
        aosip.updater.uri=$(OVERRIDE_OTA_CHANNEL)
endif
