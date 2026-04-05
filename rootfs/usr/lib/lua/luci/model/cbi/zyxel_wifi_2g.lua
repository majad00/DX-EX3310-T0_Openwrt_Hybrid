m = Map("wireless", "2.4 GHz Wi-Fi (ra0)", "Main 2.4 GHz configuration.")
s = m:section(NamedSection, "radio0", "wifi-device", "")

local iface = nil
m.uci:foreach("wireless", "wifi-iface", function(sec)
    local ifn = sec.ifname or ""
    if sec.device == "radio0" and (ifn == "ra0" or ifn == "") then
        iface = sec[".name"]
        return false
    end
end)
if not iface then iface = "@wifi-iface[0]" end

en = s:option(ListValue, "_en", "Wi-Fi Status")
en:value("0", "Enabled")
en:value("1", "Disabled")
en.cfgvalue = function(self, section) return m.uci:get("wireless", iface, "disabled") or "0" end
en.write = function(self, section, value) m.uci:set("wireless", iface, "disabled", value) end

ssid = s:option(Value, "_ssid", "Network Name (SSID)")
ssid.cfgvalue = function(self, section) return m.uci:get("wireless", iface, "ssid") end
ssid.write = function(self, section, value) m.uci:set("wireless", iface, "ssid", value) end

hid = s:option(ListValue, "_hid", "Broadcast SSID")
hid:value("0", "Visible")
hid:value("1", "Hidden")
hid.cfgvalue = function(self, section) return m.uci:get("wireless", iface, "hidden") or "0" end
hid.write = function(self, section, value) m.uci:set("wireless", iface, "hidden", value) end

enc = s:option(ListValue, "_enc", "Security")
enc:value("none", "Open (No Password)")
enc:value("psk-mixed", "WPA/WPA2-PSK (Mixed)")
enc:value("psk2", "WPA2-PSK (Recommended)")
enc.cfgvalue = function(self, section) return m.uci:get("wireless", iface, "encryption") or "none" end
enc.write = function(self, section, value) m.uci:set("wireless", iface, "encryption", value) end

key = s:option(Value, "_key", "Password")
key.password = true
key:depends("_enc", "psk2")
key:depends("_enc", "psk-mixed")
key.cfgvalue = function(self, section) return m.uci:get("wireless", iface, "key") end
key.write = function(self, section, value) m.uci:set("wireless", iface, "key", value) end

ch = s:option(ListValue, "_ch", "Operating Channel")
ch:value("auto", "Auto")
ch:value("1", "Channel 1 (2.412 GHz)")
ch:value("2", "Channel 2 (2.417 GHz)")
ch:value("3", "Channel 3 (2.422 GHz)")
ch:value("4", "Channel 4 (2.427 GHz)")
ch:value("5", "Channel 5 (2.432 GHz)")
ch:value("6", "Channel 6 (2.437 GHz)")
ch:value("7", "Channel 7 (2.442 GHz)")
ch:value("8", "Channel 8 (2.447 GHz)")
ch:value("9", "Channel 9 (2.452 GHz)")
ch:value("10", "Channel 10 (2.457 GHz)")
ch:value("11", "Channel 11 (2.462 GHz)")
ch.cfgvalue = function(self, section) return m.uci:get("wireless", "radio0", "channel") or "auto" end
ch.write = function(self, section, value) m.uci:set("wireless", "radio0", "channel", value) end

bw = s:option(ListValue, "_bw", "Channel Bandwidth")
bw:value("0", "20 MHz (Stable)")
bw:value("1", "40 MHz (Fast)")
bw.cfgvalue = function(self, section) return m.uci:get("wireless", "radio0", "htmode") or "0" end
bw.write = function(self, section, value) m.uci:set("wireless", "radio0", "htmode", value) end

txp = s:option(ListValue, "_txp", "Transmit Power")
txp:value("100", "100% (Max Range)")
txp:value("75", "75%")
txp:value("50", "50%")
txp:value("25", "25%")
txp.cfgvalue = function(self, section) return m.uci:get("wireless", "radio0", "txpower") or "100" end
txp.write = function(self, section, value) m.uci:set("wireless", "radio0", "txpower", value) end

mac = s:option(Value, "_mac", "MAC Address Spoof")
mac.placeholder = "00:11:22:33:44:55"
mac.cfgvalue = function(self, section) return m.uci:get("wireless", iface, "macaddr") end
mac.write = function(self, section, value) m.uci:set("wireless", iface, "macaddr", value) end

max = s:option(Value, "_max", "Max Clients Limit")
max.placeholder = "32"
max.cfgvalue = function(self, section) return m.uci:get("wireless", iface, "maxassoc") or "32" end
max.write = function(self, section, value) m.uci:set("wireless", iface, "maxassoc", value) end

m.on_after_commit = function(self)
    os.execute("/usr/bin/zyxel_wifi_sync >/dev/null 2>&1 &")
end

return m
