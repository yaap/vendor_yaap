ORIG_PATH := $(shell cat $(OUT_DIR)/.path_interposer_origpath)
# Add variables that we wish to make available to soong here.
EXPORT_TO_SOONG := \
    ORIG_PATH \
    KERNEL_ARCH \
    KERNEL_BUILD_OUT_PREFIX \
    KERNEL_CROSS_COMPILE \
    KERNEL_MAKE_CMD \
    KERNEL_MAKE_FLAGS \
    PATH_OVERRIDE_SOONG \
    TARGET_KERNEL_CONFIG \
    TARGET_KERNEL_SOURCE \
    KERNEL_CLANG_TRIPLE \
    KERNEL_CC \
    MAKE_PREBUILT

# Setup SOONG_CONFIG_* vars to export the vars listed above.
# Documentation here:
# https://github.com/LineageOS/android_build_soong/commit/8328367c44085b948c003116c0ed74a047237a69

SOONG_CONFIG_NAMESPACES += yaapVarsPlugin
SOONG_CONFIG_yaapVarsPlugin :=

SOONG_CONFIG_NAMESPACES += lineageGlobalVars
SOONG_CONFIG_lineageGlobalVars += \
    bootloader_message_offset \
    target_surfaceflinger_fod_lib

SOONG_CONFIG_NAMESPACES += lineageQcomVars

# Only create display_headers_namespace var if dealing with UM platforms to avoid breaking build for all other platforms
ifneq ($(filter $(UM_PLATFORMS),$(TARGET_BOARD_PLATFORM)),)
SOONG_CONFIG_lineageQcomVars += \
    qcom_display_headers_namespace
endif

define addVar
    SOONG_CONFIG_yaapVarsPlugin += $(1)
    SOONG_CONFIG_yaapVarsPlugin_$(1) := $$(subst ",\",$$($1))
endef

# Set default values
BOOTLOADER_MESSAGE_OFFSET ?= 0
TARGET_SURFACEFLINGER_FOD_LIB ?= surfaceflinger_fod_lib

# Soong value variables
SOONG_CONFIG_lineageGlobalVars_bootloader_message_offset := $(BOOTLOADER_MESSAGE_OFFSET)
SOONG_CONFIG_lineageGlobalVars_target_surfaceflinger_fod_lib := $(TARGET_SURFACEFLINGER_FOD_LIB)

ifneq ($(filter $(QSSI_SUPPORTED_PLATFORMS),$(TARGET_BOARD_PLATFORM)),)
SOONG_CONFIG_lineageQcomVars_qcom_display_headers_namespace := vendor/qcom/opensource/commonsys-intf/display
else
SOONG_CONFIG_lineageQcomVars_qcom_display_headers_namespace := $(QCOM_SOONG_NAMESPACE)/display
endif

ifneq ($(TARGET_USE_QTI_BT_STACK),true)
PRODUCT_SOONG_NAMESPACES += packages/apps/Bluetooth
endif #TARGET_USE_QTI_BT_STACK

$(foreach v,$(EXPORT_TO_SOONG),$(eval $(call addVar,$(v))))
