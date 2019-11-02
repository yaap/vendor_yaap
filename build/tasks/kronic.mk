AOSIP_TARGET_PACKAGE := $(PRODUCT_OUT)/Nitrogen-OS-$(AOSIP_VERSION).zip

.PHONY: otapackage kronic bacon
otapackage: $(INTERNAL_OTA_PACKAGE_TARGET)
kronic: otapackage
	$(hide) mv $(INTERNAL_OTA_PACKAGE_TARGET) $(AOSIP_TARGET_PACKAGE)
	$(hide) $(MD5SUM) $(AOSIP_TARGET_PACKAGE) | cut -d ' ' -f1 > $(AOSIP_TARGET_PACKAGE).md5sum
	@echo -e ""
	@echo -e "${cya}Building ${bldcya}Nitrogen OS ${txtrst}";
	@echo -e "zip: "$(AOSIP_TARGET_PACKAGE)
	@echo -e "md5: `cat $(AOSIP_TARGET_PACKAGE).md5sum | cut -d ' ' -f 1`"
	@echo -e "size:`ls -lah $(AOSIP_TARGET_PACKAGE) | cut -d ' ' -f 5`"
	@echo -e ""

bacon: kronic
