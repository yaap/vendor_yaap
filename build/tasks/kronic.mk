YAAP_TARGET_PACKAGE := $(PRODUCT_OUT)/YAAP-$(YAAP_VERSION).zip

.PHONY: otapackage kronic bacon
otapackage: $(INTERNAL_OTA_PACKAGE_TARGET)
kronic: otapackage
	$(hide) mv $(INTERNAL_OTA_PACKAGE_TARGET) $(YAAP_TARGET_PACKAGE)
	$(hide) $(MD5SUM) $(YAAP_TARGET_PACKAGE) | cut -d ' ' -f1 > $(YAAP_TARGET_PACKAGE).md5sum
	@echo -e ""
	@echo -e "${cya}Building ${bldcya}YAAP OS ${txtrst}";
	@echo -e "zip: "$(YAAP_TARGET_PACKAGE)
	@echo -e "md5: `cat $(YAAP_TARGET_PACKAGE).md5sum | cut -d ' ' -f 1`"
	@echo -e "size:`ls -lah $(YAAP_TARGET_PACKAGE) | cut -d ' ' -f 5`"
	@echo -e ""

bacon: kronic
