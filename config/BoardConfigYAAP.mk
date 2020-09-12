include vendor/yaap/config/BoardConfigKernel.mk

ifeq ($(BOARD_USES_QCOM_HARDWARE),true)
include vendor/yaap/config/BoardConfigQcom.mk
endif

include vendor/yaap/config/BoardConfigSoong.mk
