# Zyxel-Matrix Hybrid OS for EX3301-T0 / DX3310-T0

[![License: GPL v2](https://img.shields.io/badge/License-GPL%20v2-blue.svg)](https://www.gnu.org/licenses/old-licenses/gpl-2.0.en.html)
[![OpenWrt](https://img.shields.io/badge/OpenWrt-23.05-green.svg)](https://openwrt.org)
[![Build Status](https://img.shields.io/badge/build-beta-yellow.svg)]()

A hybrid firmware solution that combines OpenWrt flexibility with Zyxel proprietary utilities for the EX3301-T0 and DX3310-T0 routers.

## ⚠️ Important Notice

> **Building from working source is possible. SDK version and complete build details will be released after beta testing.**

This project is currently in **beta stage**. While functional, some features may require additional testing before production deployment.

## 📋 Table of Contents

- [Overview](#overview)
- [Hardware Specifications](#hardware-specifications)
- [Architecture](#architecture)
- [Cross-Compilation Guide](#cross-compilation-guide)
- [Building Applications](#building-applications)
- [Installation](#installation)
- [License](#license)

## 🎯 Overview

Zyxel-Matrix is a hybrid firmware solution that targets hardware relying on proprietary utilities for full operation. While Zyxel routers utilize open-source code (licensed under GPL v2), they also use proprietary utilities during the build process that are not opensource and hard to port.

**Our Solution:** We keep the proprietary software on the router while providing a fully functional OpenWrt-based operating system, build around it. This gives users:

- ✅ Complete OpenWrt flexibility and package ecosystem
- ✅ Full hardware access including proprietary features
- ✅ Access to both open and closed-source utilities
- ✅ Standard OpenWrt apps

## 💻 Hardware Specifications

### Zyxel EX3301-T0 / DX3310-T0

| Feature | Specification |
|---------|---------------|
| **Model** | Zyxel EX3301-T0 / DX3310-T0 |
| **Device Mode** | Router |
| **SoC / CPU** | MediaTek/Airoha EN751627 |
| **RAM** | 256 MB DDR3 (1333 MHz) |
| **Flash Memory** | 128 MB SPI NAND (Winbond W25N01G) |
| **2.4GHz WLAN** | MediaTek MT7915D |
| **5GHz WLAN** | MediaTek MT7915E |
| **Ethernet** | 4x LAN ports + WAN support |
| **USB Ports** | 2x USB (usb1, usb2 instances) |
| **VoIP / Telephony** | Silicon Labs Si32280 SLIC (2 FXS channels) |
| **Stock Firmware** | V5.50(ABVY.6.2)C0 |
| **Stock Kernel** | Linux 3.18.21 |

### Additional Hardware Details (from bootlog)

#### Flash Memory
Flash Size: 0x8000000 bytes = 128 MB (confirmed)
SPI NAND Chip: Winbond W25N01G


#### Wi-Fi Interface Mapping
The bootlog uses standard Ralink/MediaTek interface naming:

| Band | Interfaces |
|------|------------|
| **2.4 GHz** | ra0, ra1, ra2, ra3 |
| **5 GHz** | rai0, rai1, rai2, rai3, rai4, rai5 |

#### Telephony Configuration
- DSP Driver: Silicon Labs Si32280
- Default VoIP Country/Region: ID 27 (Norway)

## 🏗️ Architecture

The Zyxel-Matrix OS is structured as a dual-bank hybrid system:

**Partition Layout:**

| Partition | Size | Description |
|-----------|------|-------------|
| mtd0 | 256 KB | Bootloader |
| mtd1 | 256 KB | ROM file storage |
| mtd2 | 3.9 MB | Kernel (Bank 1) |
| mtd3 | 22.8 MB | RootFS (Bank 1) |
| mtd4 | 40 MB | Combined tclinux (Bank 1) |
| mtd5 | 3.9 MB | Kernel (Bank 2) |
| mtd6 | 22.8 MB | RootFS (Bank 2) |
| mtd7 | 38.1 MB | Combined tclinux (Bank 2) |
| mtd8 | 1 MB | WWAN data |
| mtd9 | 4 MB | User data |
| mtd10 | 1 MB | ROM-D |
| mtd11 | 32 MB | Misc / Overlay |
| mtd12 | 512 KB | Factory (WiFi cal, MACs) |
| mtd13 | 768 KB | Reserved area |

## 🔧 Cross-Compilation Guide

### Setting Up the Build Environment

```bash
cd ./xx3301

# Set SDK path
export SDK_PATH=./xx3301

# Add toolchain to PATH
export PATH=$PATH:$SDK_PATH/staging_dir/toolchain-mips_34kc_gcc-4.8-linaro_uClibc-0.9.33.2/bin

# Set cross-compilation variables
export CROSS_COMPILE=mips-openwrt-linux-uclibc-
export STAGING_DIR=$SDK_PATH/staging_dir

# Set library paths
export LDFLAGS="-L$STAGING_DIR/target-mips_34kc_uClibc-0.9.33.2/usr/lib"
export CPPFLAGS="-I$STAGING_DIR/target-mips_34kc_uClibc-0.9.33.2/usr/include"

# Set compiler
export CC="mips-openwrt-linux-uclibc-gcc"
export CFLAGS="-march=mips32r2 -msoft-float"
export LDFLAGS="-static"