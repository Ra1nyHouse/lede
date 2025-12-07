include $(TOPDIR)/rules.mk

PKG_NAME:=rknpu
PKG_RELEASE:=1

PKG_BUILD_DIR:=$(KERNEL_BUILD_DIR)/$(PKG_NAME)

include $(INCLUDE_DIR)/kernel.mk
include $(INCLUDE_DIR)/package.mk

define KernelPackage/rknpu
  SUBMENU:=Rockchip
  TITLE:=Rockchip NPU driver
  DEPENDS:=@TARGET_rockchip +kmod-drm +kmod-drm-rockchip
  FILES:=$(PKG_BUILD_DIR)/rknpu.ko
  AUTOLOAD:=$(call AutoLoad,90,rknpu)
endef

define KernelPackage/rknpu/Description
 Kernel-mode driver for Rockchip NPU (e.g. RK3588). Uses DRM GEM path by
 default; dma-heap path stays disabled for now.
endef

define Build/Prepare
	$(call Build/Prepare/Default)
	$(CP) ./src/* $(PKG_BUILD_DIR)/
endef

define Build/Compile
	$(KERNEL_MAKE) M=$(PKG_BUILD_DIR) \
		CONFIG_ROCKCHIP_RKNPU=m \
		CONFIG_ROCKCHIP_RKNPU_DRM_GEM=y \
		CONFIG_ROCKCHIP_RKNPU_DMA_HEAP=n \
		CONFIG_ROCKCHIP_RKNPU_FENCE=y \
		CONFIG_ROCKCHIP_RKNPU_PROC_FS=y \
		CONFIG_ROCKCHIP_RKNPU_DEBUG_FS=y \
		CONFIG_ROCKCHIP_RKNPU_SRAM=n \
		modules
endef

$(eval $(call KernelPackage,rknpu))

