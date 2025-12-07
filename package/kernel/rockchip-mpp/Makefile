include $(TOPDIR)/rules.mk

PKG_NAME:=rockchip-mpp
PKG_RELEASE:=1

PKG_BUILD_DIR:=$(KERNEL_BUILD_DIR)/$(PKG_NAME)

include $(INCLUDE_DIR)/kernel.mk
include $(INCLUDE_DIR)/package.mk

# MPP framework not available in current kernel version

define KernelPackage/rockchip-rga
  SUBMENU:=Rockchip
  TITLE:=Rockchip RGA 2D accelerator
  DEPENDS:=@TARGET_rockchip +kmod-drm-rockchip
  FILES:=$(PKG_BUILD_DIR)/rga/rga.ko
  AUTOLOAD:=$(call AutoLoad,90,rga)
endef

define KernelPackage/rockchip-rga/Description
 Driver for Rockchip RGA 2D graphics accelerator.
endef

define KernelPackage/rockchip-fec
  SUBMENU:=Rockchip
  TITLE:=Rockchip FEC (fisheye correction)
  DEPENDS:=@TARGET_rockchip +kmod-video-videobuf2 +kmod-media-core
  FILES:=$(PKG_BUILD_DIR)/fec/video_rkfec.ko
  AUTOLOAD:=$(call AutoLoad,90,video_rkfec)
endef

define KernelPackage/rockchip-fec/Description
 V4L2 driver for Rockchip Fisheye Correction engine.
endef

define KernelPackage/rockchip-avsp
  SUBMENU:=Rockchip
  TITLE:=Rockchip AVSP (stitching)
  DEPENDS:=@TARGET_rockchip +kmod-media-core
  FILES:=$(PKG_BUILD_DIR)/avsp/video_rkavsp.ko
  AUTOLOAD:=$(call AutoLoad,90,video_rkavsp)
endef

define KernelPackage/rockchip-avsp/Description
 Rockchip Any View Stitching Processor driver.
endef

define Build/Prepare
	$(call Build/Prepare/Default)
	$(CP) ./src/* $(PKG_BUILD_DIR)/
endef

define Build/Compile
	$(KERNEL_MAKE) M=$(PKG_BUILD_DIR) \
		CONFIG_VIDEO_ROCKCHIP_RGA=m \
		CONFIG_VIDEO_ROCKCHIP_FEC=m \
		CONFIG_VIDEO_ROCKCHIP_AVSP=m \
		modules
endef

$(eval $(call KernelPackage,rockchip-rga))
$(eval $(call KernelPackage,rockchip-fec))
$(eval $(call KernelPackage,rockchip-avsp))

