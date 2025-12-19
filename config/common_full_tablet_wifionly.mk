# Inherit mobile full common stuff
$(call inherit-product, vendor/yaap/config/common.mk)

# Inherit tablet common stuff
$(call inherit-product, vendor/yaap/config/tablet.mk)

$(call inherit-product, vendor/yaap/config/wifionly.mk)
