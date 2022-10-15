PRODUCT_PACKAGES += \
    ThemePicker \

# Extra tools in YAAP
PRODUCT_PACKAGES += \
    bash \
    curl \
    getcap \
    htop \
    libsepol \
    nano \
    setcap \
    vim

# Openssh
PRODUCT_PACKAGES += \
    scp \
    sftp \
    ssh \
    sshd \
    sshd_config \
    ssh-keygen \
    start-ssh

# Filesystems tools
PRODUCT_PACKAGES += \
    fsck.ntfs \
    mkfs.ntfs \
    mount.ntfs

# YAAP packages
PRODUCT_PACKAGES += \
    MatLog \
    OpenDelta \
    PhotonCamera

ifneq ($(TARGET_BUILD_GAPPS),true)
PRODUCT_PACKAGES += \
    Apps \
    Etar \
    ExactCalculator \
    GmsCompat \
    Jelly \
    LatinIME \
    messaging \
    Seedvault \
    SetupWizard
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
