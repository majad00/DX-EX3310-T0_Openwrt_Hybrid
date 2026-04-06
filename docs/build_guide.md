# Building Zyxel-Matrix Hybrid Firmware

## HOW WE BUILD
The approach to build Openwrt is quite different than main stream Openwrt workflow.
To build firmware for the Zyxel EX3301-T0 / DX3310-T0 routers, two main components need to work together:

| Component | Percentage | Description |
|-----------|------------|-------------|
| **Kernel** | ~10% | Handles low-level hardware communication |
| **RootFS** | ~90% | Contains the operating system, applications, and tools |

## The Hybrid Approach

Zyxel's approach leaves the **kernel untouched** on the router, allowing it to communicate effectively with the device hardware at a low level. This means:

- ✅ No need to rebuild the kernel from scratch
- ✅ Hardware compatibility is maintained
- ✅ Proprietary drivers remain functional

## Building a Compatible RootFS

The First step is to build a compatible rootfs that the kernel can accept. Approximately **90% of the router's operating system** consists of the rootfs.

### What This Means

We can **change, create, modify, or add new software** only within the root filesystem. Kernel modifications typically require building specific kernel modules, but in many cases, we can try loading pre-compiled and compatible kernel modules to do the things done.

## Tools Required

To compile the rootfs for installation, you need tools that can:

1. **Edit** the current filesystem
2. **Pack** it into a flashable format
3. **Merge** components together
4. **Sign** it with Zyxel-compatible signatures
5. **Verify** offsets match NAND layout, kernel, and bootloader expectations

### Tool Features

- Manages signing and packing process
- Ensures proper offsets for NAND layout
- Handles kernel and bootloader expectations
- Applies required proprietary signatures

## Target Chipset

The tools will work specifically with:

| Component | Specification |
|-----------|---------------|
| **Chipset** | MediaTek/Airoha EN751627 |
| **Target Routers** | Zyxel EX3301-T0, Zyxel DX3310-T0 |

## Hardware Specifications

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
| **Ethernet Switch** | 4 LAN ports + WAN support |
| **USB Ports** | Yes (usb1, usb2 instances) |
| **VoIP / Telephony** | Silicon Labs Si32280 SLIC (2 FXS channels) |
| **Stock Firmware** | V5.50(ABVY.6.2)C0 |
| **Stock Kernel** | Linux 3.18.21 |


#### Wi-Fi Interface Mapping
The bootlog uses standard Ralink/MediaTek interface naming:

| Band | Interfaces |
|------|------------|
| **2.4 GHz** | ra0, ra1, ra2, ra3 |
| **5 GHz** | rai0, rai1, rai2, rai3, rai4, rai5 |

#### Telephony Configuration
- DSP Driver: Silicon Labs Si32280
- Default VoIP Country/Region: ID 27 (Norway)

## Building Status

| Phase | Status |
|-------|--------|
| **Testing Phase** | 🔄 In Progress |
| **Building Tools** | 🟡 Coming Soon |
| **Source Release** | 📦 After test phase |

## Building from Working Source

> **Building from working source will come soon after the test phase is over.**

The tools will be made public after the full product release, as the product is currently in the testing phase.

## Quick Links

- [Main README](README.md)
- [Installation Guide](QUICK-START.txt)
- [Legal Information](LEGAL.md)
- [Changelog](CHANGELOG.txt)

## License

This project is licensed under the GNU General Public License v2.0.
Most of the code was taken from opensource , some part is written by students of embedded engineering and reviewed by project researcher Majad Qureshi, as lead programmer.
---

**Status:** Beta Testing  
**Last Updated:** April 2026

#
