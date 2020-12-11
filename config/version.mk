# Copyright (C) 2020 YAAP
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
TARGET_PRODUCT_SHORT := $(subst yaap_,,$(YAAP_BUILD))

YAAP_BUILDTYPE ?= HOMEMADE
YAAP_BUILD_VERSION := $(PLATFORM_VERSION)
YAAP_VERSION := $(YAAP_BUILD_VERSION)-$(YAAP_BUILDTYPE)-$(TARGET_PRODUCT_SHORT)-$(BUILD_DATE)
ROM_FINGERPRINT := YAAP/$(PLATFORM_VERSION)/$(TARGET_PRODUCT_SHORT)/$(shell date -u +%H%M)

PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
  ro.yaap.build.version=$(YAAP_BUILD_VERSION) \
  ro.yaap.build.date=$(BUILD_DATE) \
  ro.yaap.buildtype=$(YAAP_BUILDTYPE) \
  ro.yaap.fingerprint=$(ROM_FINGERPRINT) \
  ro.yaap.version=$(YAAP_VERSION) \
  ro.yaap.device=$(YAAP_BUILD) \
  ro.modversion=$(YAAP_VERSION)
