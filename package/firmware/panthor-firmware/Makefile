include $(TOPDIR)/rules.mk

PKG_NAME:=panthor-firmware
PKG_VERSION:=1.0
PKG_RELEASE:=1

include $(INCLUDE_DIR)/package.mk

define Package/panthor-firmware
  SECTION:=firmware
  CATEGORY:=Firmware
  TITLE:=Firmware for Arm Mali Panthor GPU
endef

define Package/panthor-firmware/description
  Provides the mali_csffw.bin firmware for Panthor GPU driver.
endef

define Build/Compile
endef

define Package/panthor-firmware/install
	$(INSTALL_DIR) $(1)/lib/firmware/arm/mali/arch10.8
	$(INSTALL_DATA) ./files/mali_csffw.bin $(1)/lib/firmware/arm/mali/arch10.8/
endef

$(eval $(call BuildPackage,panthor-firmware))