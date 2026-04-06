m = Map("wireless", "5 GHz Wi-Fi (rai5)", "Main 5 GHz configuration.")
s = m:section(NamedSection, "radio1", "wifi-device", "")

local iface = nil
m.uci:foreach("wireless", "wifi-iface", function(sec)
    local ifn = sec.ifname or ""
    if sec.device == "radio1" and (ifn == "rai5" or ifn == "") then
        iface = sec[".name"]
        return false
    end
end)
if not iface then iface = "@wifi-iface[1]" end

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
ch:value("36", "Channel 36 (5.180 GHz)")
ch:value("40", "Channel 40 (5.200 GHz)")
ch:value("44", "Channel 44 (5.220 GHz)")
ch:value("48", "Channel 48 (5.240 GHz)")
ch:value("149", "Channel 149 (5.745 GHz)")
ch:value("153", "Channel 153 (5.765 GHz)")
ch:value("157", "Channel 157 (5.785 GHz)")
ch:value("161", "Channel 161 (5.805 GHz)")
ch.cfgvalue = function(self, section) return m.uci:get("wireless", "radio1", "channel") or "auto" end
ch.write = function(self, section, value) m.uci:set("wireless", "radio1", "channel", value) end

bw = s:option(ListValue, "_bw", "Channel Bandwidth")
bw:value("0", "20 MHz")
bw:value("1", "40 MHz")
bw:value("2", "80 MHz (Fastest)")
bw.cfgvalue = function(self, section) return m.uci:get("wireless", "radio1", "htmode") or "2" end
bw.write = function(self, section, value) m.uci:set("wireless", "radio1", "htmode", value) end

txp = s:option(ListValue, "_txp", "Transmit Power")
txp:value("100", "100% (Max Range)")
txp:value("75", "75%")
txp:value("50", "50%")
txp:value("25", "25%")
txp.cfgvalue = function(self, section) return m.uci:get("wireless", "radio1", "txpower") or "100" end
txp.write = function(self, section, value) m.uci:set("wireless", "radio1", "txpower", value) end

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
