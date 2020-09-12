# Inherit common YAAP stuff
$(call inherit-product, vendor/yaap/config/common.mk)

# Required packages
PRODUCT_PACKAGES += \
    LatinIME

# Include YAAP LatinIME dictionaries
PRODUCT_PACKAGE_OVERLAYS += vendor/yaap/overlay/dictionaries
