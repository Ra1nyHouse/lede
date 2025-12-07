# Rockchip NPU / MPP 驱动开启指引

本仓库已经移植了 Rockchip NPU (`package/kernel/rknpu`)、Mali GPU (`kmod-panthor`) 以及 MPP 相关内核驱动
（`kmod-rockchip-mpp`, `kmod-rockchip-rga`, `kmod-rockchip-rga2`, `kmod-rockchip-rga3`, `kmod-rockchip-fec`, `kmod-rockchip-avsp`）。
MPP 框架现在包含完整的编解码器支持，包括视频编解码器、图像处理器等。
下面说明如何在编译配置中开启并验证这些模块。

## 支持的编解码器

当前 MPP 框架支持以下编解码器：

### 视频编解码器
- **RKVDEC**: RKV 解码器 (H.264/H.265)
- **RKVDEC2**: RKV 解码器 v2 (增强版)
- **RKVENC**: RKV 编码器 (H.264)
- **RKVENC2**: RKV 编码器 v2 (增强版)
- **VDPU1/2**: VPU 解码器 v1/v2
- **VEPU1/2**: VPU 编码器 v1/v2
- **AV1DEC**: AV1 视频解码器

### 图像处理器
- **IEP2**: 图像增强处理器 v2
- **VDPP**: 视频数据后处理
- **RGA**: Rockchip 2D 图形加速器 (传统)
- **RGA2**: Rockchip 2D 图形加速器 v2 (RK356x/RK3588)
- **RGA3**: Rockchip 2D 图形加速器 v3 (RK3588，多核)

### 编解码器
- **JPGDEC**: JPEG 解码器
- **JPGENC**: JPEG 编码器

## 前置条件
- 目标平台必须选择 `Rockchip`（`Target System -> Rockchip`）。
- 已完成 `./scripts/feeds update -a && ./scripts/feeds install -a`。
- 进入 `Kernel modules -> Video Support` 先启用公用依赖（名称可能因版本略有差异）：
  - `kmod-video-core`（包含 V4L2/videobuf2）
  - `kmod-multimedia-input`（可选，摄像头等输入）
- 进入 `Kernel modules -> DRM` 启用 `kmod-drm-rockchip`（RGA / 显示所需）。
  - GPU：Midgard/Bifrost 选 `kmod-drm-panfrost`；Valhall（如 RK3588 的 Mali-G610/G615）选 `kmod-drm-panthor`，并安装固件包 `panthor-firmware`（提供 `arm/mali/arch10.8/mali_csffw.bin`）。

## menuconfig 开启步骤
1) 进入配置界面：
   ```bash
   make menuconfig
   ```
2) 在 `Firmware` 中勾选 Mali GPU 固件包：
   - `panthor-firmware`：Mali Panthor GPU 固件（提供 `mali_csffw.bin`）

3) 在 `Kernel modules -> Rockchip` 中勾选需要的驱动（如未出现，先保存退出再进一次 menuconfig 或执行 `make package/kernel/rockchip-mpp/clean` 后重进）：
   - `kmod-rknpu`：Rockchip NPU（DRM GEM 路径）。
   - `kmod-rockchip-mpp`：Rockchip MPP service 框架（包含所有编解码器）。
   - `kmod-rockchip-rga`：RGA 2D 加速（传统）。
   - `kmod-rockchip-rga2`：RGA2 2D 加速（RK356x/RK3588）。
   - `kmod-rockchip-rga3`：RGA3 2D 加速（RK3588，多核）。
   - `kmod-rockchip-fec`：Fisheye Correction。
   - `kmod-rockchip-avsp`：Stitching 处理。

4) 在 `Kernel modules -> Video Support` 中勾选 Mali GPU 驱动：
   - `kmod-panthor`：Arm Mali Panthor GPU DRM 驱动（RK3588 Mali-G610/G615）。

   注意：可以通过 `make menuconfig` 进入 `Kernel modules -> Rockchip -> kmod-rockchip-mpp` 单独配置各个编解码器。
5) 保存退出，按需选择对应 rootfs/镜像目标后编译：
   ```bash
   make V=s
   # 或仅编译单个包
   make package/firmware/panthor-firmware/{clean,compile} V=s
   make package/kernel/rknpu/{clean,compile} V=s
   make package/kernel/panthor/{clean,compile} V=s
   make package/kernel/rockchip-mpp/{clean,compile} V=s
   ```

## 运行时验证
- 确认模块已加载：
  ```bash
  lsmod | grep -E 'rknpu|rk_vcodec|rga|rockchip_(fec|avsp)|mpp_|panthor'
  ```
- 查看驱动日志：
  ```bash
  dmesg | grep -i rknpu
  dmesg | grep -i rockchip
  dmesg | grep -i panthor
  dmesg | grep -i mali
  ```
- 验证 Mali GPU：
  ```bash
  # 检查固件文件
  ls -la /lib/firmware/arm/mali/arch10.8/mali_csffw.bin
  # 检查 GPU 设备
  ls /dev/dri/
  ```

## 备注
- NPU 默认启用 DRM GEM 路径，DMA-HEAP 相关配置暂未开放。
- RK3588 平台（如 Orange Pi 5 Plus）推荐使用 RGA2/RGA3 驱动以获得最佳性能。
- Mali GPU (Panthor) 驱动需要对应的固件包，固件文件会自动安装到 `/lib/firmware/arm/mali/arch10.8/`。
- 这些模块依赖 Rockchip 设备树中对应节点已启用；如使用自定义板级 DTS，请确认相关
  NPU/多媒体/GPU 节点未被禁用。

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
make package/firmware/panthor-firmware/{clean,compile} V=s
make package/kernel/{rknpu,panthor,rockchip-mpp}/{clean,compile} V=s

## 编译错误排查

### 错误：需要创建 /rockchip-mpp 目录

如果遇到类似错误，请检查：
1. 确保在项目根目录（lede/）下运行 make 命令
2. 确认编译环境正确设置：
   ```bash
   # 检查当前目录
   pwd  # 应该显示 /path/to/lede

   # 如果在容器中编译，确保映射了正确的目录
   # 容器运行命令示例：
   docker run -it --rm \
     -v $(pwd):/builder \
     openwrt/sdk:latest \
     /bin/bash
   ```
3. 清理并重新编译：
   ```bash
   make package/kernel/rockchip-mpp/clean
   make package/kernel/rockchip-mpp/compile V=s
   ```
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
