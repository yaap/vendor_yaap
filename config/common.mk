PRODUCT_BUILD_PROP_OVERRIDES += BUILD_UTC_DATE=0

PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    dalvik.vm.debug.alloc=0 \
    keyguard.no_require_sim=true \
    media.recorder.show_manufacturer_and_model=true \
    net.tethering.noprovisioning=true \
    persist.sys.disable_rescue=true \
    ro.carrier=unknown \
    ro.com.android.dataroaming=false \
    ro.opa.eligible_device=true \
    ro.setupwizard.enterprise_mode=1 \
    ro.storage_manager.enabled=true \
    ro.url.legal=http://www.google.com/intl/%s/mobile/android/basic/phone-legal.html \
    ro.url.legal.android_privacy=http://www.google.com/intl/%s/mobile/android/basic/privacy.html \
    ro.boot.vendor.overlay.theme=com.android.internal.systemui.navbar.gestural

#Set Network Hostname
PRODUCT_PROPERTY_OVERRIDES += \
    net.hostname=$(TARGET_VENDOR_DEVICE_NAME)

ifneq ($(TARGET_BUILD_VARIANT),user)
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.ota.allow_downgrade=true
endif

# Charger
PRODUCT_PACKAGES += \
    charger_res_images

# Copy all YAAP-specific init rc files
$(foreach f,$(wildcard vendor/yaap/prebuilt/common/etc/init/*.rc),\
    $(eval PRODUCT_COPY_FILES += $(f):$(TARGET_COPY_OUT_SYSTEM)/etc/init/$(notdir $f)))

# Don't compile SystemUITests
EXCLUDE_SYSTEMUI_TESTS := true

# Flags
ifeq ($(TARGET_BUILD_VARIANT), user)
    # Strip the local variable table and the local variable type table to reduce
    # the size of the system image. This has no bearing on stack traces, but will
    # leave less information available via JDWP.
    PRODUCT_MINIMIZE_JAVA_DEBUG_INFO := true
    # Disable dexpreopt debug info
    WITH_DEXPREOPT_DEBUG_INFO := false
    # Reduce system server verbosity
    PRODUCT_SYSTEM_SERVER_DEBUG_INFO := false
    # Don't include art debug targets
    PRODUCT_ART_TARGET_INCLUDE_DEBUG_BUILD := false
endif

# Dedupe VNDK libraries with identical core variants
TARGET_VNDK_USE_CORE_VARIANT := true

# Inherit device/qcom/common, QCOM core-utils and exclude QCOM SEPolicy
TARGET_EXCLUDE_QCOM_SEPOLICY := true
$(call inherit-product, device/qcom/common/common.mk)
include vendor/qcom/opensource/core-utils/build/utils.mk

# Use a generic profile based boot image by default
PRODUCT_USE_PROFILE_FOR_BOOT_IMAGE := true
PRODUCT_DEX_PREOPT_BOOT_IMAGE_PROFILE_LOCATION := frameworks/base/boot/boot-image-profile.txt

# Permissions
PRODUCT_COPY_FILES += \
    vendor/yaap/prebuilt/common/etc/permissions/yaap-privapp-permissions.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/permissions/yaap-privapp-permissions.xml \
    vendor/yaap/prebuilt/common/etc/permissions/yaap-power-whitelist.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/sysconfig/yaap-power-whitelist.xml

# Cloned app exemption
PRODUCT_COPY_FILES += \
    vendor/yaap/prebuilt/common/etc/sysconfig/preinstalled-packages-platform-yaap-product.xml:$(TARGET_COPY_OUT_PRODUCT)/etc/sysconfig/preinstalled-packages-platform-yaap-product.xml

# Charger
PRODUCT_PACKAGES += \
    product_charger_res_images \
    product_charger_res_images_vendor

# Enable Android Beam on all targets
PRODUCT_COPY_FILES += \
    vendor/yaap/prebuilt/common/etc/permissions/android.software.nfc.beam.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/permissions/android.software.nfc.beam.xml

# Enable whole-program R8 Java optimizations for SystemUI and system_server,
# but also allow explicit overriding for testing and development.
SYSTEM_OPTIMIZE_JAVA ?= true
SYSTEMUI_OPTIMIZE_JAVA ?= true

# Product overlay
PRODUCT_PACKAGE_OVERLAYS += vendor/yaap/overlay/frameworks
PRODUCT_PACKAGE_OVERLAYS += vendor/yaap/overlay/packages
PRODUCT_ENFORCE_RRO_EXCLUDED_OVERLAYS += vendor/yaap/overlay/frameworks
PRODUCT_ENFORCE_RRO_EXCLUDED_OVERLAYS += vendor/yaap/overlay/packages
PRODUCT_PACKAGES += \
    CertifiedPropsOverlay \
    FrameworksOverlay \
    SettingsOverlay \
    SettingsProviderOverlay \
    SystemUIOverlay
ifneq ($(TARGET_BUILD_GAPPS),true)
PRODUCT_PACKAGES += \
    DialerOverlayVanilla \
    FrameworksOverlayVanilla \
    LatinIMEOverlayVanilla \
    OpenDeltaOverlayVanilla \
    SettingsProviderOverlayVanilla \
    ThemePickerOverlayVanilla
# Include LatinIME dictionaries
PRODUCT_PACKAGE_OVERLAYS += vendor/yaap/overlay-vanilla/dictionaries
PRODUCT_PACKAGE_OVERLAYS += vendor/yaap/overlay-vanilla/packages
PRODUCT_ENFORCE_RRO_EXCLUDED_OVERLAYS += vendor/yaap/overlay-vanilla/dictionaries
PRODUCT_ENFORCE_RRO_EXCLUDED_OVERLAYS += vendor/yaap/overlay-vanilla/packages
endif
PRODUCT_COPY_FILES += \
    vendor/yaap/overlay/partition_order.xml:$(TARGET_COPY_OUT_PRODUCT)/overlay/partition_order.xml \
    vendor/yaap/overlay/config-system_ext.xml:$(TARGET_COPY_OUT_SYSTEM_EXT)/overlay/config/config.xml

# Disable vendor restrictions
PRODUCT_RESTRICT_VENDOR_FILES := false

# IORap app launch prefetching using Perfetto traces and madvise
PRODUCT_PRODUCT_PROPERTIES += \
    ro.iorapd.enable=true

# Disable touch video heatmap to reduce latency, motion jitter, and CPU usage
# on supported devices with Deep Press input classifier HALs and models
PRODUCT_PRODUCT_PROPERTIES += \
    ro.input.video_enabled=false

# Packages
include vendor/yaap/config/packages.mk

# Versioning
include vendor/yaap/config/version.mk

# ART

# SystemUI
PRODUCT_DEXPREOPT_SPEED_APPS += \
    SystemUI \
    Launcher3QuickStep \
    Settings

PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    dalvik.vm.systemuicompilerfilter=speed

ifeq ($(TARGET_SUPPORTS_64_BIT_APPS), true)
# Use 64-bit dex2oat for better dexopt time.
PRODUCT_PROPERTY_OVERRIDES += \
    dalvik.vm.dex2oat64.enabled=true
endif

# Disable async MTE on system_server
PRODUCT_SYSTEM_EXT_PROPERTIES += \
    arm64.memtag.process.system_server=off

# Blur
ifeq ($(TARGET_ENABLE_BLUR), true)
PRODUCT_SYSTEM_EXT_PROPERTIES += \
    ro.sf.blurs_are_expensive=1 \
    ro.surface_flinger.supports_background_blur=1
else
PRODUCT_PRODUCT_PROPERTIES += \
    ro.launcher.blur.appLaunch=0
endif

# FCM
DEVICE_FRAMEWORK_COMPATIBILITY_MATRIX_FILE += vendor/yaap/config/device_framework_matrix.xml

# EGL - Blobcache configuration
PRODUCT_VENDOR_PROPERTIES += \
    ro.egl.blobcache.multifile=true \
    ro.egl.blobcache.multifile_limit=33554432

ifeq ($(TARGET_BUILD_GAPPS),true)
    $(call inherit-product-if-exists, vendor/google/gms/config.mk)
else
    $(call inherit-product, external/svox/svox_tts.mk)
    $(call inherit-product, vendor/microg/products/gms.mk)
endif
$(call inherit-product-if-exists, vendor/google/pixel/config.mk)

#OTA tools
PRODUCT_HOST_PACKAGES += \
    signapk \
    brotli

# Themes
$(call inherit-product, vendor/themes/common.mk)

# Sepolicy
$(call inherit-product, vendor/yaap/config/sepolicy.mk)

# Virtualization
$(call inherit-product, packages/modules/Virtualization/apex/product_packages.mk)
PRODUCT_PRODUCT_PROPERTIES += \
    ro.boot.hypervisor.vm.supported=1 \
    ro.boot.hypervisor.protected_vm.supported=1
