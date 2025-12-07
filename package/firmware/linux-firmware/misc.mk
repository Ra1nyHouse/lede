Package/eip197-firmware = $(call Package/firmware-default,Inside Secure EIP197 firmware)
define Package/eip197-firmware/install
	$(INSTALL_DIR) $(1)/lib/firmware
	$(INSTALL_DATA) \
		$(PKG_BUILD_DIR)/inside-secure/eip197_minifw/ifpp.bin \
		$(PKG_BUILD_DIR)/inside-secure/eip197_minifw/ipue.bin \
		$(1)/lib/firmware
endef
$(eval $(call BuildPackage,eip197-firmware))

Package/eip197-mini-firmware = $(call Package/firmware-default,Inside Secure EIP197 mini firmware)
define Package/eip197-mini-firmware/install
	$(INSTALL_DIR) $(1)/lib/firmware/inside-secure/eip197_minifw
	$(INSTALL_DATA) \
		$(PKG_BUILD_DIR)/inside-secure/eip197_minifw/ifpp.bin \
		$(PKG_BUILD_DIR)/inside-secure/eip197_minifw/ipue.bin \
		$(1)/lib/firmware/inside-secure/eip197_minifw
endef
$(eval $(call BuildPackage,eip197-mini-firmware))

Package/mali-panthor-firmware = $(call Package/firmware-default,ARM Mali Valhall (panthor) firmware)
define Package/mali-panthor-firmware/install
	$(INSTALL_DIR) $(1)/lib/firmware/arm/mali/arch10.8
	$(INSTALL_DATA) \
		$(PKG_BUILD_DIR)/arm/mali/arch10.8/mali_csffw.bin \
		$(1)/lib/firmware/arm/mali/arch10.8
endef
$(eval $(call BuildPackage,mali-panthor-firmware))
