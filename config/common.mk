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
    ro.com.google.ime.bs_theme=true \
    ro.com.google.ime.theme_id=5 \
    ro.url.legal=http://www.google.com/intl/%s/mobile/android/basic/phone-legal.html \
    ro.url.legal.android_privacy=http://www.google.com/intl/%s/mobile/android/basic/privacy.html \
    ro.boot.vendor.overlay.theme=com.android.internal.systemui.navbar.gestural

ifeq ($(PRODUCT_GMS_CLIENTID_BASE),)
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.com.google.clientidbase=android-google
else
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.com.google.clientidbase=$(PRODUCT_GMS_CLIENTID_BASE)
endif

#Set Network Hostname
PRODUCT_PROPERTY_OVERRIDES += \
    net.hostname=$(TARGET_VENDOR_DEVICE_NAME) \

#Blurr
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.sf.blurs_are_expensive=1 \
    ro.surface_flinger.supports_background_blur=1 \
    persist.sys.sf.disable_blurs=1

# Backup Tool
PRODUCT_COPY_FILES += \
    vendor/yaap/prebuilt/common/bin/backuptool.sh:install/bin/backuptool.sh \
    vendor/yaap/prebuilt/common/bin/backuptool.functions:install/bin/backuptool.functions \
    vendor/yaap/prebuilt/common/bin/50-base.sh:$(TARGET_COPY_OUT_SYSTEM)/addon.d/50-base.sh \
    vendor/yaap/prebuilt/common/bin/blacklist:$(TARGET_COPY_OUT_SYSTEM)/addon.d/blacklist

ifneq ($(AB_OTA_PARTITIONS),)
PRODUCT_COPY_FILES += \
    vendor/yaap/prebuilt/common/bin/backuptool_ab.sh:$(TARGET_COPY_OUT_SYSTEM)/bin/backuptool_ab.sh \
    vendor/yaap/prebuilt/common/bin/backuptool_ab.functions:$(TARGET_COPY_OUT_SYSTEM)/bin/backuptool_ab.functions \
    vendor/yaap/prebuilt/common/bin/backuptool_postinstall.sh:$(TARGET_COPY_OUT_SYSTEM)/bin/backuptool_postinstall.sh
endif

# Charger
PRODUCT_PACKAGES += \
    charger_res_images

# Copy all AOSiP-specific init rc files
$(foreach f,$(wildcard vendor/yaap/prebuilt/common/etc/init/*.rc),\
	$(eval PRODUCT_COPY_FILES += $(f):$(TARGET_COPY_OUT_SYSTEM)/etc/init/$(notdir $f)))

# Don't compile SystemUITests
EXCLUDE_SYSTEMUI_TESTS := true

# Don't include art debug targets
PRODUCT_ART_TARGET_INCLUDE_DEBUG_BUILD := false

# Include SDCLANG definitions if it is requested and available
ifeq ($(HOST_OS),linux)
    ifneq ($(wildcard vendor/qcom/sdclang-4.0/),)
        include vendor/yaap/sdclang/sdclang.mk
    endif
endif

# LatinIME gesture typing
ifeq ($(TARGET_ARCH),arm64)
PRODUCT_COPY_FILES += \
    vendor/yaap/prebuilt/common/lib64/libjni_latinime.so:$(TARGET_COPY_OUT_SYSTEM)/lib64/libjni_latinime.so \
    vendor/yaap/prebuilt/common/lib64/libjni_latinimegoogle.so:$(TARGET_COPY_OUT_SYSTEM)/lib64/libjni_latinimegoogle.so
else
PRODUCT_COPY_FILES += \
    vendor/yaap/prebuilt/common/lib/libjni_latinime.so:$(TARGET_COPY_OUT_SYSTEM)/lib/libjni_latinime.so \
    vendor/yaap/prebuilt/common/lib/libjni_latinimegoogle.so:$(TARGET_COPY_OUT_SYSTEM)/lib/libjni_latinimegoogle.so
endif

# Permissions
PRODUCT_COPY_FILES += \
    vendor/yaap/prebuilt/common/etc/permissions/yaap-privapp-permissions.xml:system/etc/permissions/yaap-privapp-permissions.xml \

# Enable Android Beam on all targets
PRODUCT_COPY_FILES += \
    vendor/yaap/prebuilt/common/etc/permissions/android.software.nfc.beam.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/permissions/android.software.nfc.beam.xml

# Strip the local variable table and the local variable type table to reduce
# the size of the system image. This has no bearing on stack traces, but will
# leave less information available via JDWP.
PRODUCT_MINIMIZE_JAVA_DEBUG_INFO := true

# Common overlay
PRODUCT_PACKAGE_OVERLAYS += vendor/yaap/overlay/common

# Disable vendor restrictions
PRODUCT_RESTRICT_VENDOR_FILES := false

# Bootanimation
include vendor/yaap/config/bootanimation.mk

# Packages
include vendor/yaap/config/packages.mk

# Versioning
include vendor/yaap/config/version.mk

PRODUCT_DEXPREOPT_SPEED_APPS += \
    Settings \
    SystemUI \
    Launcher3QuickStep

ifeq ($(TARGET_BUILD_GAPPS),true)
    $(call inherit-product-if-exists, vendor/google/gms/config.mk)
    $(call inherit-product-if-exists, vendor/google/pixel/config.mk)
    $(call inherit-product, vendor/prebuilts/config/apex.mk)
endif

ifneq ($(TARGET_BUILD_GAPPS),true)
    PRODUCT_PACKAGE_OVERLAYS += vendor/yaap/overlay/no_apex
endif

#OTA tools
PRODUCT_HOST_PACKAGES += \
    signapk \
    brotli

$(call inherit-product, vendor/themes/common.mk)
