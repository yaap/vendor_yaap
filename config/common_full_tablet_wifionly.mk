# Inherit common YAAP stuff
$(call inherit-product, vendor/yaap/config/common.mk)

# Required packages
PRODUCT_PACKAGES += \
    LatinIME
