PRODUCT_BUILD_PROP_OVERRIDES += BUILD_UTC_DATE=0

PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    dalvik.vm.debug.alloc=0 \
    keyguard.no_require_sim=true \
    media.recorder.show_manufacturer_and_model=true \
    net.tethering.noprovisioning=true \
    persist.sys.disable_rescue=true \
    ro.atrace.core.services=com.google.android.gms,com.google.android.gms.ui,com.google.android.gms.persistent \
    ro.carrier=unknown \
    ro.com.android.dataroaming=false \
    ro.com.android.dateformat=MM-dd-yyyy \
    ro.config.bt_sco_vol_steps=30 \
    ro.config.media_vol_steps=30 \
    ro.error.receiver.system.apps=com.google.android.gms \
    ro.opa.eligible_device=true \
    ro.setupwizard.enterprise_mode=1 \
    ro.storage_manager.enabled=true \
    ro.url.legal=http://www.google.com/intl/%s/mobile/android/basic/phone-legal.html \
    ro.url.legal.android_privacy=http://www.google.com/intl/%s/mobile/android/basic/privacy.html

ifeq ($(PRODUCT_GMS_CLIENTID_BASE),)
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.com.google.clientidbase=android-google
else
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.com.google.clientidbase=$(PRODUCT_GMS_CLIENTID_BASE)
endif

# Backup Tool
PRODUCT_COPY_FILES += \
    vendor/aosip/prebuilt/common/bin/backuptool.sh:install/bin/backuptool.sh \
    vendor/aosip/prebuilt/common/bin/backuptool.functions:install/bin/backuptool.functions \
    vendor/aosip/prebuilt/common/bin/50-base.sh:$(TARGET_COPY_OUT_SYSTEM)/addon.d/50-base.sh \
    vendor/aosip/prebuilt/common/bin/blacklist:$(TARGET_COPY_OUT_SYSTEM)/addon.d/blacklist

ifeq ($(AB_OTA_UPDATER),true)
PRODUCT_COPY_FILES += \
    vendor/aosip/prebuilt/common/bin/backuptool_ab.sh:$(TARGET_COPY_OUT_SYSTEM)/bin/backuptool_ab.sh \
    vendor/aosip/prebuilt/common/bin/backuptool_ab.functions:$(TARGET_COPY_OUT_SYSTEM)/bin/backuptool_ab.functions \
    vendor/aosip/prebuilt/common/bin/backuptool_postinstall.sh:$(TARGET_COPY_OUT_SYSTEM)/bin/backuptool_postinstall.sh
endif

# Charger
PRODUCT_PACKAGES += \
    charger_res_images

# Configs
PRODUCT_COPY_FILES += \
    vendor/aosip/prebuilt/common/etc/sysconfig/aosip-power-whitelist.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/sysconfig/aosip-power-whitelist.xml \
    vendor/aosip/prebuilt/common/etc/sysconfig/dialer_experience.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/sysconfig/dialer_experience.xml \
    vendor/aosip/prebuilt/common/etc/sysconfig/turbo.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/sysconfig/turbo.xml \
    vendor/aosip/prebuilt/common/etc/sysconfig/org.pixelexperience.weather.client-default.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/default-permissions/org.pixelexperience.weather.client.xml

# Copy all AOSiP-specific init rc files
$(foreach f,$(wildcard vendor/aosip/prebuilt/common/etc/init/*.rc),\
	$(eval PRODUCT_COPY_FILES += $(f):$(TARGET_COPY_OUT_SYSTEM)/etc/init/$(notdir $f)))

# Don't compile SystemUITests
EXCLUDE_SYSTEMUI_TESTS := true

# Don't include art debug targets
PRODUCT_ART_TARGET_INCLUDE_DEBUG_BUILD := false

# Include SDCLANG definitions if it is requested and available
ifeq ($(HOST_OS),linux)
    ifneq ($(wildcard vendor/qcom/sdclang-4.0/),)
        include vendor/aosip/sdclang/sdclang.mk
    endif
endif

# LatinIME gesture typing
ifeq ($(TARGET_ARCH),arm64)
PRODUCT_COPY_FILES += \
    vendor/aosip/prebuilt/common/lib64/libjni_latinime.so:$(TARGET_COPY_OUT_SYSTEM)/lib64/libjni_latinime.so \
    vendor/aosip/prebuilt/common/lib64/libjni_latinimegoogle.so:$(TARGET_COPY_OUT_SYSTEM)/lib64/libjni_latinimegoogle.so
else
PRODUCT_COPY_FILES += \
    vendor/aosip/prebuilt/common/lib/libjni_latinime.so:$(TARGET_COPY_OUT_SYSTEM)/lib/libjni_latinime.so \
    vendor/aosip/prebuilt/common/lib/libjni_latinimegoogle.so:$(TARGET_COPY_OUT_SYSTEM)/lib/libjni_latinimegoogle.so
endif

# Permissions
PRODUCT_COPY_FILES += \
    vendor/aosip/prebuilt/common/etc/permissions/aosip-privapp-permissions.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/permissions/aosip-privapp-permissions.xml \
    vendor/aosip/prebuilt/common/etc/permissions/org.pixelexperience.weather.client.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/permissions/org.pixelexperience.weather.client.xml \
    vendor/aosip/prebuilt/common/etc/permissions/privapp-permissions-elgoog.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/permissions/privapp-permissions-elgoog.xml

# Strip the local variable table and the local variable type table to reduce
# the size of the system image. This has no bearing on stack traces, but will
# leave less information available via JDWP.
PRODUCT_MINIMIZE_JAVA_DEBUG_INFO := true

# Common overlay
PRODUCT_PACKAGE_OVERLAYS += vendor/aosip/overlay/common

# Disable vendor restrictions
PRODUCT_RESTRICT_VENDOR_FILES := false

# Bootanimation
include vendor/aosip/config/bootanimation.mk

# GSans font
include vendor/aosip/config/fonts.mk

# Packages
include vendor/aosip/config/packages.mk

# Themes
#include vendor/aosip/config/themes.mk

# Versioning
include vendor/aosip/config/version.mk
