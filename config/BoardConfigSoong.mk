ifneq (,$(wildcard $(OUT_DIR)/.path_interposer_origpath))
ORIG_PATH := $(shell cat $(OUT_DIR)/.path_interposer_origpath)
endif
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
    camera_skip_kind_check \
    target_surfaceflinger_udfps_lib \
    target_init_vendor_lib \
    camera_needs_client_info_defaults 

SOONG_CONFIG_NAMESPACES += lineageQcomVars
SOONG_CONFIG_lineageQcomVars += \
    no_camera_smooth_apis \
    uses_qti_camera_device \
    should_wait_for_qsee \
    supports_extended_compress_format

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
TARGET_SURFACEFLINGER_UDFPS_LIB ?= surfaceflinger_udfps_lib
TARGET_INIT_VENDOR_LIB ?= vendor_init
TARGET_CAMERA_NEEDS_CLIENT_INFO ?= false

# Soong value variables
SOONG_CONFIG_lineageGlobalVars_camera_skip_kind_check := $(CAMERA_SKIP_KIND_CHECK)
SOONG_CONFIG_lineageGlobalVars_target_surfaceflinger_udfps_lib := $(TARGET_SURFACEFLINGER_UDFPS_LIB)
SOONG_CONFIG_lineageQcomVars_no_camera_smooth_apis := $(TARGET_HAS_NO_CAMERA_SMOOTH_APIS)
SOONG_CONFIG_lineageQcomVars_uses_qti_camera_device := $(TARGET_USES_QTI_CAMERA_DEVICE)
SOONG_CONFIG_lineageGlobalVars_target_init_vendor_lib := $(TARGET_INIT_VENDOR_LIB)
SOONG_CONFIG_lineageGlobalVars_camera_needs_client_info_defaults := $(TARGET_CAMERA_NEEDS_CLIENT_INFO)
SOONG_CONFIG_lineageQcomVars_should_wait_for_qsee := $(TARGET_KEYMASTER_WAIT_FOR_QSEE)
SOONG_CONFIG_lineageQcomVars_supports_extended_compress_format := $(AUDIO_FEATURE_ENABLED_EXTENDED_COMPRESS_FORMAT)

ifneq ($(filter $(QSSI_SUPPORTED_PLATFORMS),$(TARGET_BOARD_PLATFORM)),)
SOONG_CONFIG_lineageQcomVars_qcom_display_headers_namespace := vendor/qcom/opensource/commonsys-intf/display
else
SOONG_CONFIG_lineageQcomVars_qcom_display_headers_namespace := $(QCOM_SOONG_NAMESPACE)/display
endif

$(foreach v,$(EXPORT_TO_SOONG),$(eval $(call addVar,$(v))))
