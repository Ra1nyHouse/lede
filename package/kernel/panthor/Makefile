include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/kernel.mk

PKG_NAME:=kmod-panthor
PKG_VERSION:=6.12.45-1
PKG_RELEASE:=$(AUTORELEASE)

PKG_MAINTAINER:=Your Name <your.email@example.com>
PKG_LICENSE:=GPL-2.0-only

include $(INCLUDE_DIR)/package.mk

define KernelPackage/panthor
  SUBMENU:=Video Support
  TITLE:=Panthor GPU DRM driver and dependencies
  DEPENDS:=@TARGET_rockchip_armv8 +kmod-drm
  FILES:= \
    $(LINUX_DIR)/drivers/gpu/drm/drm_exec.ko \
    $(LINUX_DIR)/drivers/gpu/drm/drm_gpuvm.ko \
    $(LINUX_DIR)/drivers/gpu/drm/drm_shmem_helper.ko \
    $(LINUX_DIR)/drivers/gpu/drm/scheduler/gpu-sched.ko \
    $(LINUX_DIR)/drivers/gpu/drm/panthor/panthor.ko
  AUTOLOAD:=$(call AutoLoad,99, drm_exec drm_gpuvm drm_shmem_helper gpu_sched panthor)
  KCONFIG:=
endef

define KernelPackage/panthor/description
 Kernel module for Panthor GPU DRM driver and its dependencies
endef

define Build/Compile
endef

$(eval $(call KernelPackage,panthor))