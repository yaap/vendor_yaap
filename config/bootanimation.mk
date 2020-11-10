ifneq ($(wildcard vendor/yaap/prebuilt/common/bootanimation/$(scr_resolution).zip),)
PRODUCT_COPY_FILES += \
    vendor/yaap/prebuilt/common/bootanimation/$(scr_resolution).zip:$(TARGET_COPY_OUT_PRODUCT)/media/bootanimation.zip
endif
