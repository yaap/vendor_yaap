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

define addVar
  SOONG_CONFIG_yaapVarsPlugin += $(1)
  SOONG_CONFIG_yaapVarsPlugin_$(1) := $$(subst ",\",$$($1))
endef

$(foreach v,$(EXPORT_TO_SOONG),$(eval $(call addVar,$(v))))
