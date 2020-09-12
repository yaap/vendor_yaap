YAAP_TARGET_PACKAGE := $(PRODUCT_OUT)/YAAP-$(YAAP_VERSION).zip

.PHONY: otapackage yaap bacon
otapackage: $(INTERNAL_OTA_PACKAGE_TARGET)
yaap: otapackage
	$(hide) mv $(INTERNAL_OTA_PACKAGE_TARGET) $(YAAP_TARGET_PACKAGE)
	@echo -e ""
	@echo -e "${cya}Building ${bldcya}YAAP OS ${txtrst}";
	@echo -e "zip: "$(YAAP_TARGET_PACKAGE)
	@echo -e "size:`ls -lah $(YAAP_TARGET_PACKAGE) | cut -d ' ' -f 5`"
	@echo -e ""

bacon: yaap
