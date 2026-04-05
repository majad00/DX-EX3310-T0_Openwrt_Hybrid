# Building from working source will come soon after test phase is over
Hardware Specifications: Zyxel EX3301-T0
Feature	Specification
Model	Zyxel EX3301-T0 
Device Mode	Router 
SoC / CPU	MediaTek/Airoha EN751627 
RAM	256 MB DDR3 (1333 MHz) 
Flash Memory	128 MB SPI NAND (Winbond W25N01G) 
WLAN Hardware (5GHz)	MediaTek MT7915D / MT7915E 
Ethernet Switch	4 LAN ports + WAN support 
USB Ports	Yes (Identified usb1 and usb2 instances) 
VoIP / Telephony	Silicon Labs Si32280 SLIC (2 FXS channels) 
Stock Firmware / Kernel	V5.50(ABVY.6.2)C0 running Linux Kernel 3.18.21 
Additional Hardware Notes from Bootlog:
•	Flash Calculation: The bootlog reports a flash size of 0x8000000 bytes, which precisely converts to 128 MB.
•	Wi-Fi Interface Mapping: The bootlog uses the typical Ralink/MediaTek interface naming conventions, registering ra0 through ra3 (as 2.4GHz) and rai0 through rai5 (as 5GHz).
•	Telephony Configuration: The system initializes a DSP driver set to VoIP Country/Region Id = 27 (Norway) by default.
