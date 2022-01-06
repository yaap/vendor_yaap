PRODUCT_PACKAGES += \
    ThemePicker \

# Extra tools in YAAP
PRODUCT_PACKAGES += \
    curl \
    getcap \
    htop \
    libsepol \
    setcap

# YAAP packages
PRODUCT_PACKAGES += \
    MatLog \
    OpenDelta \

ifneq ($(TARGET_BUILD_GAPPS),true)
PRODUCT_PACKAGES += \
    Etar \
    Jelly \
    LatinIME \
    messaging \
    SimpleDeviceConfig
endif

# Include explicitly to work around GMS issues
PRODUCT_PACKAGES += \
    libprotobuf-cpp-full \
    librsjni
