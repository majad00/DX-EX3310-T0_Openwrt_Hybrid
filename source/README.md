# Zyxel-Matrix Hybrid OS for EX3301-T0 / DX3310-T0

## 📦 Large Files Download

Due to GitHub size limitations, large files are hosted externally. The following source files are required for building:

### Required Source Files

| File | Description |
|------|-------------|
| `OpenWrt-ImageBuilder-15.05.1-ar71xx-generic.Linux-x86_64.tar.bz2` | OpenWrt Image Builder (137 MB) |
| `OpenWrt-SDK-15.05.1-ar71xx-generic_gcc-4.8-linaro_uClibc-0.9.33.2.Linux-x86_64.tar.bz2` | OpenWrt SDK (75 MB) |
| `busybox-1.36.1.tar.bz2` | BusyBox utilities |
| `squashfs4.2.tar.gz` | SquashFS tools |

### Download Links

> **Note:** Download links will be provided after beta testing. Please check back later.

- [OpenWrt ImageBuilder](https://downloads.openwrt.org/releases/15.05.1/) (or use your own copy)
- [OpenWrt SDK](https://downloads.openwrt.org/releases/15.05.1/)
- [BusyBox](https://busybox.net/downloads/)
- [SquashFS](https://github.com/plougher/squashfs-tools)

## 🏗️ Building from Source

### Important Notice

> **Rootfs is the only part of the firmware that can be built with open-source code.** The remaining components are proprietary and not shared.

### Build Process

1. Download the required source files listed above
2. Place them in the `source/` directory
3. Use the provided tools (coming soon) to create custom firmware by modifying the rootfs part

### Coming Soon

- Build tools and scripts
- SDK configuration files
- Cross-compilation environment setup
- Custom rootfs creation guide

## 📁 Directory Structure
DX-EX3310-T0_Openwrt_Hybrid/
├── source/ # Required source files (download here)
├── xx3301/ # Build configuration
├── rootfs/ # Root filesystem (modify this)
├── docs/ # Documentation
├── final.bin # Generated firmware output
├── firmware.bin # Generated firmware output
├── README.md # This file
├── LICENSE # GPL v2 License
├── CHANGELOG.txt # Version history
└── QUICK-START.txt # Quick start guide


## ⚠️ License

This project is licensed under the GNU General Public License v2.0.

Proprietary components remain property of their respective owners.

---

**Status:** Beta Testing  
**Last Updated:** April 2026