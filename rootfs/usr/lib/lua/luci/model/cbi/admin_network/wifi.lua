local nw = require "luci.model.network"
local ut = require "luci.util"

arg[1] = arg[1] or ""

-- Friendly page title
m = Map("wireless", "Wi-Fi Settings", "Manage your wireless network settings.")
m.redirect = luci.dispatcher.build_url("admin/network/wireless")

nw.init(m.uci)
local wnet = nw:get_wifinet(arg[1])
local wdev = wnet and wnet:get_device()

-- If we don't know what radio we are editing, go back to overview
if not wnet or not wdev then
    luci.http.redirect(luci.dispatcher.build_url("admin/network/wireless"))
    return
end

local devname = wdev:name() -- Actual backend name stays unchanged

-- Friendly display name for UI only
local friendly_name = (devname == "radio0") and "2.4 GHz Wi-Fi" or "5 GHz Wi-Fi"

-- Find the correct interface for this specific radio
local iface = nil
m.uci:foreach("wireless", "wifi-iface", function(sec)
    if sec.device == devname then
        iface = sec[".name"]
        return false
    end
end)

if not iface then
    iface = (devname == "radio0") and "@wifi-iface[0]" or "@wifi-iface[1]"
end

-- Section title changed for readability only
s = m:section(NamedSection, devname, "wifi-device", friendly_name)

-- Cleaner tab names
s:tab("general", "Basic Settings")
s:tab("advanced", "Advanced Options")


en = s:taboption("general", ListValue, "_en", "Wi-Fi Status")
en:value("0", "Enabled")
en:value("1", "Disabled")
en.cfgvalue = function(self, section)
    return m.uci:get("wireless", iface, "disabled") or "0"
end
en.write = function(self, section, value)
    m.uci:set("wireless", iface, "disabled", value)
end

ssid = s:taboption("general", Value, "_ssid", "Network Name (SSID)")
ssid.cfgvalue = function(self, section)
    return m.uci:get("wireless", iface, "ssid")
end
ssid.write = function(self, section, value)
    m.uci:set("wireless", iface, "ssid", value)
end

enc = s:taboption("general", ListValue, "_enc", "Security Mode")
enc:value("none", "Open (No Password)")
enc:value("psk-mixed", "WPA/WPA2-PSK (Mixed)")
enc:value("psk2", "WPA2-PSK (Recommended)")
enc.cfgvalue = function(self, section)
    return m.uci:get("wireless", iface, "encryption") or "none"
end
enc.write = function(self, section, value)
    m.uci:set("wireless", iface, "encryption", value)
end

key = s:taboption("general", Value, "_key", "Wi-Fi Password")
key.password = true
key:depends("_enc", "psk2")
key:depends("_enc", "psk-mixed")
key.cfgvalue = function(self, section)
    return m.uci:get("wireless", iface, "key")
end
key.write = function(self, section, value)
    m.uci:set("wireless", iface, "key", value)
end

ch = s:taboption("advanced", ListValue, "_ch", "Operating Channel")
ch:value("auto", "Auto")

if devname == "radio0" then
    for i = 1, 11 do
        ch:value(tostring(i), "Channel " .. i)
    end
else
    local ch_5g = {36, 40, 44, 48, 149, 153, 157, 161}
    for _, c in ipairs(ch_5g) do
        ch:value(tostring(c), "Channel " .. c)
    end
end

ch.cfgvalue = function(self, section)
    return m.uci:get("wireless", devname, "channel") or "auto"
end
ch.write = function(self, section, value)
    m.uci:set("wireless", devname, "channel", value)
end

bw = s:taboption("advanced", ListValue, "_bw", "Channel Width")
if devname == "radio0" then
    bw:value("0", "20 MHz (Stable)")
    bw:value("1", "40 MHz (Fast)")
else
    bw:value("0", "20 MHz")
    bw:value("1", "40 MHz")
    bw:value("2", "80 MHz (Fastest)")
end

bw.cfgvalue = function(self, section)
    return m.uci:get("wireless", devname, "htmode") or
        (devname == "radio0" and "0" or "2")
end
bw.write = function(self, section, value)
    m.uci:set("wireless", devname, "htmode", value)
end

txp = s:taboption("advanced", ListValue, "_txp", "Signal Strength")
txp:value("100", "100% (Maximum Range)")
txp:value("75", "75%")
txp:value("50", "50%")
txp:value("25", "25%")
txp.cfgvalue = function(self, section)
    return m.uci:get("wireless", devname, "txpower") or "100"
end
txp.write = function(self, section, value)
    m.uci:set("wireless", devname, "txpower", value)
end

hid = s:taboption("advanced", ListValue, "_hid", "Network Visibility")
hid:value("0", "Visible")
hid:value("1", "Hidden")
hid.cfgvalue = function(self, section)
    return m.uci:get("wireless", iface, "hidden") or "0"
end
hid.write = function(self, section, value)
    m.uci:set("wireless", iface, "hidden", value)
end

mac = s:taboption("advanced", Value, "_mac", "MAC Address Override")
mac.placeholder = "00:11:22:33:44:55"
mac.cfgvalue = function(self, section)
    return m.uci:get("wireless", iface, "macaddr")
end
mac.write = function(self, section, value)
    m.uci:set("wireless", iface, "macaddr", value)
end

max = s:taboption("advanced", Value, "_max", "Maximum Connected Devices")
max.placeholder = "32"
max.cfgvalue = function(self, section)
    return m.uci:get("wireless", iface, "maxassoc") or "32"
end
max.write = function(self, section, value)
    m.uci:set("wireless", iface, "maxassoc", value)
end

m.on_after_commit = function(self)
    os.execute("/usr/bin/zyxel_wifi_sync >/dev/null 2>&1 &")
end

return m
