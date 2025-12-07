# Rockchip NPU / MPP 驱动开启指引

本仓库已经移植了 Rockchip NPU (`package/kernel/rknpu`) 以及部分媒体处理内核驱动
（`kmod-rockchip-rga`, `kmod-rockchip-fec`, `kmod-rockchip-avsp`）。
下面说明如何在编译配置中开启并验证这些模块。

## 支持的驱动

当前支持以下媒体处理驱动：

## 前置条件
- 目标平台必须选择 `Rockchip`（`Target System -> Rockchip`）。
- 已完成 `./scripts/feeds update -a && ./scripts/feeds install -a`。
- 进入 `Kernel modules -> Video Support` 先启用公用依赖（名称可能因版本略有差异）：
  - `kmod-video-core`（包含 V4L2/videobuf2）
  - `kmod-multimedia-input`（可选，摄像头等输入）
- 进入 `Kernel modules -> DRM` 启用 `kmod-drm-rockchip`（RGA / 显示所需）。
  - GPU：Midgard/Bifrost 选 `kmod-drm-panfrost`；Valhall（如 RK3588 的 Mali-G610/G615）选 `kmod-drm-panthor`，并安装固件包 `mali-panthor-firmware`（提供 `arm/mali/arch10.8/mali_csffw.bin`）。

## menuconfig 开启步骤
1) 进入配置界面：
   ```bash
   make menuconfig
   ```
2) 在 `Kernel modules -> Rockchip` 中勾选需要的驱动（如未出现，先保存退出再进一次 menuconfig 或执行 `make package/kernel/rockchip-mpp/clean` 后重进）：
   - `kmod-rknpu`：Rockchip NPU（DRM GEM 路径）。
   - `kmod-rockchip-rga`：RGA 2D 加速。
   - `kmod-rockchip-fec`：Fisheye Correction。
   - `kmod-rockchip-avsp`：Stitching 处理。
3) 保存退出，按需选择对应 rootfs/镜像目标后编译：
   ```bash
   make V=s
   # 或仅编译单个包
   make package/kernel/rknpu/{clean,compile} V=s
   make package/kernel/rockchip-mpp/{clean,compile} V=s
   ```

## 运行时验证
- 确认模块已加载：
  ```bash
  lsmod | grep -E 'rknpu|rga|rockchip_(fec|avsp)'
  ```
- 查看驱动日志：
  ```bash
  dmesg | grep -i rknpu
  dmesg | grep -i rockchip
  ```

## 备注
- NPU 默认启用 DRM GEM 路径，DMA-HEAP 相关配置暂未开放。
- 这些模块依赖 Rockchip 设备树中对应节点已启用；如使用自定义板级 DTS，请确认相关
  NPU/多媒体节点未被禁用。

## 编译错误

ERROR: tools/elfutils failed to build.

使用docker 编译环境
docker run --rm -it -v "$PWD":/builder -w /builder ghcr.io/openwrt/sdk:latest /bin/bash


make distclean
./scripts/feeds update -a
./scripts/feeds install -a
make menuconfig

单独编译模块命令
make tools/findutils/{clean,compile} V=s
make tools/cmake/{clean,compile} V=s -j10


make tools/install V=s -j10
make toolchain/install V=s -j10
make tools/findutils/{clean,compile} V=s
make package/kernel/{rknpu,rockchip-mpp}/{clean,compile} V=s
make V=s -j10


其他容器
# 1. 拉取 OpenWrt 编译镜像
docker pull openwrt/sdk:latest

# 2. 运行编译容器
docker run -it --rm \
  -v $(pwd):/home/build/openwrt \
  -v /Volumes/CaseSensitive/.ccache:/home/build/.ccache \
  openwrt/sdk:latest \
  /bin/bash
