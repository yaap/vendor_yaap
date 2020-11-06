YAAP_TARGET_PACKAGE := $(PRODUCT_OUT)/YAAP-$(YAAP_VERSION).zip
MD5 := prebuilts/build-tools/path/$(HOST_OS)-x86/md5sum

.PHONY: otapackage yaap bacon
otapackage: $(INTERNAL_OTA_PACKAGE_TARGET)
yaap: otapackage
	$(hide) mv $(INTERNAL_OTA_PACKAGE_TARGET) $(YAAP_TARGET_PACKAGE)
	$(hide) $(MD5) $(YAAP_TARGET_PACKAGE) | cut -d ' ' -f1 > $(YAAP_TARGET_PACKAGE).md5sum
	@echo -e ""
	@echo -e "${cya}Building ${bldcya}YAAP OS ${txtrst}";
	@echo -e "zip: "$(YAAP_TARGET_PACKAGE)
	@echo -e "md5: "${cya}" `cat $(YAAP_TARGET_PACKAGE).md5sum | cut -d ' ' -f 1`"
	@echo -e "size:`ls -lah $(YAAP_TARGET_PACKAGE) | cut -d ' ' -f 5`"
	@echo -e ""

bacon: yaap
