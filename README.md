# LEDE 源码仓库

LEDE 项目是一个嵌入式 Linux 发行版，专注于为各种路由器和嵌入式设备提供现代化的固件解决方案。

为国产龙芯 LOONGSON SoC loongarch64 / 飞腾 Phytium 腾锐 D2000 系列架构添加支持。

I18N: [English](README_EN.md) | [简体中文](README.md) | [日本語](README_JA.md)

## 官方讨论群

如有技术问题需要讨论或者交流，欢迎加入以下群：

1. QQ 讨论群：Op 固件技术研究群，号码 891659613，加群链接：[点击加入](https://qm.qq.com/q/IMa6Yf2SgC "Op固件技术研究群")
2. TG 讨论群：OP 编译官方大群，加群链接：[点击加入](https://t.me/JhKgAA6Hx1 "OP 编译官方大群")

## 注意

1. **不要用 root 用户进行编译**
2. 国内用户编译前最好准备好梯子
3. 默认登陆IP 192.168.1.1 密码 password

## 编译命令

1. 首先装好 Linux 系统，推荐 Debian 或 Ubuntu LTS 22/24

2. 安装编译依赖

   ```bash
   sudo apt update -y
   sudo apt full-upgrade -y
   sudo apt install -y ack antlr3 asciidoc autoconf automake autopoint binutils bison build-essential \
   bzip2 ccache clang cmake cpio curl device-tree-compiler flex gawk gcc-multilib g++-multilib gettext \
   genisoimage git gperf haveged help2man intltool libc6-dev-i386 libelf-dev libfuse-dev libglib2.0-dev \
   libgmp3-dev libltdl-dev libmpc-dev libmpfr-dev libncurses5-dev libncursesw5-dev libpython3-dev \
   libreadline-dev libssl-dev libtool llvm lrzsz libnsl-dev ninja-build p7zip p7zip-full patch pkgconf \
   python3 python3-pyelftools python3-setuptools qemu-utils rsync scons squashfs-tools subversion \
   swig texinfo uglifyjs upx-ucl unzip vim wget xmlto xxd zlib1g-dev
   ```

3. 下载源代码，更新 feeds 并选择配置

   ```bash
   git clone https://github.com/coolsnowwolf/lede
   cd lede
   ./scripts/feeds update -a
   ./scripts/feeds install -a
   make menuconfig
   ```

4. 下载 dl 库，编译固件
（-j 后面是线程数，第一次编译推荐用单线程）

   ```bash
   make download -j8
   make V=s -j1
   ```

本套代码保证肯定可以编译成功。里面包括了 R24 所有源代码，包括 IPK 的。

你可以自由使用，但源码编译二次发布请注明我的 GitHub 仓库链接。谢谢合作！

二次编译：

```bash
cd lede
git pull
./scripts/feeds update -a
./scripts/feeds install -a
make defconfig
make download -j8
make V=s -j$(nproc)
```

如果需要重新配置：

```bash
rm -rf .config
make menuconfig
make V=s -j$(nproc)
```

编译完成后输出路径：bin/targets

### 使用 WSL/WSL2 进行编译

由于 WSL 的 PATH 中包含带有空格的 Windows 路径，有可能会导致编译失败，请在 `make` 前面加上：

```bash
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
```

由于默认情况下，装载到 WSL 发行版的 NTFS 格式的驱动器将不区分大小写，因此大概率在 WSL/WSL2 的编译检查中会返回以下错误：

```txt
Build dependency: OpenWrt can only be built on a case-sensitive filesystem
```

一个比较简洁的解决方法是，在 `git clone` 前先创建 Repository 目录，并为其启用大小写敏感：

```powershell
# 以管理员身份打开终端
PS > fsutil.exe file setCaseSensitiveInfo <your_local_lede_path> enable
# 将本项目 git clone 到开启了大小写敏感的目录 <your_local_lede_path> 中
PS > git clone https://github.com/coolsnowwolf/lede <your_local_lede_path>
```

> 对已经 `git clone` 完成的项目目录执行 `fsutil.exe` 命令无法生效，大小写敏感只对新增的文件变更有效。

### 使用 Docker 容器进行编译

对于 macOS 用户，推荐使用 Docker 容器进行编译，这样可以避免复杂的环境配置问题。

1. 拉取 OpenWrt SDK 镜像：

   ```bash
   docker pull openwrt/sdk:latest
   ```

2. 运行编译容器：

   ```bash
   docker run -it --rm \
     -v $(pwd):/home/build/openwrt \
     -v ~/.ccache:/home/build/.ccache \
     openwrt/sdk:latest \
     /bin/bash
   ```

3. 在容器内进行编译：

   ```bash
   cd /home/build/openwrt
   ./scripts/feeds update -a
   ./scripts/feeds install -a
   make menuconfig
   make download -j8
   make V=s -j$(nproc)
   ```

## 特别提示

1. 源代码中绝不含任何后门和可以监控或者劫持你的 HTTPS 的闭源软件，SSL 安全是互联网最后的壁垒，安全干净才是固件应该做到的。

2. 本项目基于 LEDE 源码，请在使用时注明来源：[https://github.com/coolsnowwolf/lede](https://github.com/coolsnowwolf/lede)

3. QCA IPQ60xx 开源仓库地址：<https://github.com/coolsnowwolf/openwrt-gl-ax1800>

4. 存档版本仓库地址：<https://github.com/coolsnowwolf/openwrt>
