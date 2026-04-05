================================================
ZYXEL-MATRIX FIRMWARE FOR DX-EX 3301-T0 ROUTER
================================================


Version: 1 ( v-15)
Authors: 
Date: March 2026

--------------------------------------------------------------------

TABLE OF CONTENTS
-----------------
1. About
2. Requirements
3. Files Needed
4. Installation Steps
5. Router Modes
6. Default Settings
7. Security Recommendations
8. Support

--------------------------------------------------------------------

1. ABOUT
--------
This Zyxel-Matrix is a custom router OS designed specifically for the 
"ZyXEL EX3301-T0 AX1800 Dual-band -WiFi6". 
This user-friendly operating system provides a web-based configuration 
interface making router management simple and accessible.

The port is still under active development with more features being 
added in future releases.

--------------------------------------------------------------------

2. REQUIREMENTS
---------------
Before you begin, ensure you have:

Hardware:
• ZyXEL DX or EX3301-T0 Dual-band router
• Ethernet cable
• Windows / Unix PC with Ethernet port

Software:
• TFTP Client 
• Firmware file 

--------------------------------------------------------------------

3. INSTALLATION STEPS
---------------------
Follow these steps carefully to install Zyxel-Matrix on your router:

Option 1: Use Your PC
   • Connect your PC to the router using an Ethernet cable
   • Set your PC's Ethernet adapter to a static IP:
     - IP Address: 192.168.1.10
     - Subnet Mask: 255.255.255.0
     - Default Gateway: (leave blank)
   • Login to Zyxel EX3310-T0 select Maintaince and Firmware Update

Option 2 : Use UART
   • Disconnect power from the router
   • Connect UART
   • Power on router and press anyke to intrupt boot
   • Type ATUR RAS.bin
   • On PC, Rename the firmware to RAS.bin ( or any name you like)
   • Use TFTP to send RAS.bin file to router


STEP 4: First Boot
   • Router will automatically reboot (takes 2-3 minutes)
   • First boot takes longer than normal
   • Wait for the LED to indicate RED for a second then to still and GREEN

--------------------------------------------------------------------

4. DEFAULT SETTINGS
-------------------
Wifi Disable (Default):
   • Router IP: 192.168.1.1
   • WiFi SSID 2.4GHz: Zyxel_Matrix
   • WiFi SSID 5GHz: Zyxel_Matrix
   • WiFi Password: 12345678
   • SSH Access: root / no password
   • Luci Interface: root / no password

--------------------------------------------------------------------

5. SECURITY RECOMMENDATIONS
---------------------------
IMMEDIATELY AFTER FIRST BOOT:
   • Change default WiFi password
   • Change router admin password
   • Change SSH root password
   • Update router IP if needed
   • Review WiFi security settings

--------------------------------------------------------------------

8. SUPPORT
----------
For issues, questions, or feedback:
• Check the CHANGELOG.txt for known issues
• Visit the forums for EX3301-T0 discussions
• Report bugs with detailed description of the issue

--------------------------------------------------------------------

IMPORTANT WARNINGS:
-------------------
⚠️ Never power off the router during firmware flashing when power LED is RED
⚠️ Do not interrupt the TFTP transfer process
⚠️ First boot takes 2-3 minutes - be patient
⚠️ Keep default passwords secure and change them immediately
⚠️ To return back to official firmware just flash original firmware through LUCI flash upgrade


--------------------------------------------------------------------
© 2025 Majad Qureshi . All rights reserved.
This firmware is provided as-is without warranty of any kind.
