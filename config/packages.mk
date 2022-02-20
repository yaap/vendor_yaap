PRODUCT_PACKAGES += \
    ThemePicker \

# Extra tools in YAAP
PRODUCT_PACKAGES += \
    curl \
    getcap \
    htop \
    libsepol \
    nano \
    setcap \
    vim

# YAAP packages
PRODUCT_PACKAGES += \
    MatLog \
    OpenDelta \

ifneq ($(TARGET_BUILD_GAPPS),true)
PRODUCT_PACKAGES += \
    Etar \
    Jelly \
    LatinIME \
    messaging
endif

# Include explicitly to work around GMS issues
PRODUCT_PACKAGES += \
    libprotobuf-cpp-full \
    librsjni

# Config
PRODUCT_PACKAGES += \
    SimpleDeviceConfig

# Repainter integration
PRODUCT_PACKAGES += \
    RepainterServicePriv
