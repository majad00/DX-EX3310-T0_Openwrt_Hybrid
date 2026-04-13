# Openwrt for MediaTek/Airoha EN751627 based chips ( EX3301-T0 / DX3301-T0) 

[![License: GPL v2](https://img.shields.io/badge/License-GPL%20v2-blue.svg)](LICENSE)
[![Release](https://img.shields.io/github/v/release/majad00/zyxel-matrix-wsr30)](https://github.com/majad00/Openwrt_Zyxel_EX3310-T0/releases)
[![Downloads](https://img.shields.io/github/downloads/majad00/zyxel-matrix-wsr30/total)](https://github.com/majad00/Openwrt_Zyxel_EX3310-T0/releases/tag/Openwrt)

A Functional Openwrt for DX3301-T0 and EX-3301-T0, Zyxel Matrix is community build firmware , developed using Imagebuilder, Openwrt 15.5 source code. 
👉 You can revert to OEM firmware status at any time by doing a Rollback, or update latest Zyxel firmware through LUCI interface.

### Version V-17 includes support for Wi-Fi backhaul. You can activate this feature from Network > Mesh Backhaul.
⚠️ **Important**: Please use either WAN or Wi-Fi backhaul. Using both together may slow performance.


## ✨ Features  Full functional Openwrt 
- **Easy Installation** - No UART or disassembly required! Install from Web interface
- **Full Luci Interface** - Manage your router through any browser
- **Advanced Radio Control** - Control over all available Radios
- **Root access** - Zyxel-Matrix OS with full previliges (No Password or 1234)
- **pre compiled** - cross-compiled binary ready to install
- **Roll Back** - Openwrt Sysupgrade can flash OEM firmware to router
- **Wi-Fi Backhaul** - You dont need WAN port for upstream router you can use fast Wi-Fi backhaul

## 📥 Quick Download

👉 **[Download Latest Release](https://github.com/majad00/Openwrt_Zyxel_EX3310-T0/releases/download/Openwrt/Openwrt_Zyxel_EX3310-T0-v-17.zip)**
	Current version : v-17 sha256:cd874d72fc88b604d6cd77956f6f888d8b2ddc6981a5762701b5b7824cc3739c
The download includes:
- `openwrt-15.5-zyxel-matrix-v-17-squashfs-sysupgrade.bin` - Zyxel-Matrix for DX3301-T0 and EX3301-T0
- `zyxel-3.3-squashfs-rollback.bin` - Roll Back to Zyxal factory firmware
- `README.txt` - Complete instructions
- `CHANGELOG.txt` - Version history
- `docs` - for detail documentations and installation
  
## 🚀 Flashing in 2 minutes 

1. **Connect** Ethernet cable from PC to router
2. **Login to router**: Login to OEM Zyxel router through web
3. **Flash**: From drop down menu Select Maintenance → click Firmware Upgrade
4. **Wait** 2-3 minutes for first boot
5. **Connect WiFi**: `Zyxel_Matrix` / `12345678` ( Enable through LUCI)
6. **Configure**: http://192.168.1.1 (root/no passwrod )

> ⚠️ **IMPORTANT**: Change password after first boot!, on successfull boot the network LED starts blinking


## 🚀 Flashing using UART (safe for testing )
1. **Connect** Using TX, RX and GND, rename the firmware to RAS.bin (optional)
2. **Get to Shell**: Intrupt boot process by pressing any button
3. **Prepare**: Type "ATUR RAS.bin" ( router will start a tftp server and wait for the file)
4. **Flash**: Send RAS.bin file using TFTP, tftp 192.168.1.1 
5. **Wait**: Bootloader will write RAS.bin to proper offsets, Power LED is red
6. **First Boot**: router will reboot, wait for 2-3 minutes for first boot

## 📋 Detailed Documentation

- [Building from Source](docs/build_guide.md)
- [Changelog](CHANGELOG.txt)

## 🔧 Default Settings

| Mode | IP Address | WiFi SSID | WiFi Password | Login |
|------|------------|-----------|---------------|-------|
| **AP Mode** | 192.168.1.1 | Zyxel_Matrix | 12345678 | root/1234 |

## 🛠️ Development

This project include busybox based on OpenWrt. To build from source:
See Source, for installing precompiled firmware see Release,
