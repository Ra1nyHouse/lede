include $(TOPDIR)/rules.mk

PKG_NAME:=rockchip-mpp
PKG_RELEASE:=1

include $(INCLUDE_DIR)/kernel.mk

PKG_BUILD_DIR:=$(KERNEL_BUILD_DIR)/$(PKG_NAME)
include $(INCLUDE_DIR)/package.mk

define KernelPackage/rockchip-mpp
  SUBMENU:=Rockchip
  TITLE:=Rockchip MPP service framework
  DEPENDS:=@TARGET_rockchip
  FILES:=$(PKG_BUILD_DIR)/mpp/rk_vcodec.ko
  AUTOLOAD:=$(call AutoLoad,89,rk_vcodec)
endef

define KernelPackage/rockchip-mpp/Description
 Rockchip Media Process Platform service framework.
endef

define KernelPackage/rockchip-rga3
  SUBMENU:=Rockchip
  TITLE:=Rockchip RGA3 2D accelerator
  DEPENDS:=@TARGET_rockchip_armv8 +kmod-drm-rockchip
  FILES:=$(PKG_BUILD_DIR)/rga3/rga3.ko
  AUTOLOAD:=$(call AutoLoad,90,rga3)
endef

define KernelPackage/rockchip-rga3/Description
 Driver for Rockchip RGA3 2D graphics accelerator (RK3588).
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
		CONFIG_ROCKCHIP_MPP_SERVICE=m \
		CONFIG_ROCKCHIP_MPP_PROC_FS=y \
		CONFIG_ROCKCHIP_MPP_RKVDEC=m \
		CONFIG_ROCKCHIP_MPP_RKVDEC2=m \
		CONFIG_ROCKCHIP_MPP_RKVENC=m \
		CONFIG_ROCKCHIP_MPP_RKVENC2=m \
		CONFIG_ROCKCHIP_MPP_VDPU1=m \
		CONFIG_ROCKCHIP_MPP_VEPU1=m \
		CONFIG_ROCKCHIP_MPP_VDPU2=m \
		CONFIG_ROCKCHIP_MPP_VEPU2=m \
		CONFIG_ROCKCHIP_MPP_IEP2=m \
		CONFIG_ROCKCHIP_MPP_JPGDEC=m \
		CONFIG_ROCKCHIP_MPP_JPGENC=m \
		CONFIG_ROCKCHIP_MPP_AV1DEC=m \
		CONFIG_ROCKCHIP_MPP_VDPP=m \
		CONFIG_ROCKCHIP_MULTI_RGA=m \
		CONFIG_VIDEO_ROCKCHIP_FEC=m \
		CONFIG_VIDEO_ROCKCHIP_AVSP=m \
		modules
endef

$(eval $(call KernelPackage,rockchip-mpp))
$(eval $(call KernelPackage,rockchip-rga3))
$(eval $(call KernelPackage,rockchip-fec))
$(eval $(call KernelPackage,rockchip-avsp))

