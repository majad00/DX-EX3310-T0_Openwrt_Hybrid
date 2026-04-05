m = Map("wireless", "Smart Connect (Unified Wi-Fi)", "Apply the exact same Network Name and Password to both 2.4 GHz and 5 GHz bands simultaneously.")

local iface2g = nil
local iface5g = nil

m.uci:foreach("wireless", "wifi-iface", function(sec)
    local ifn = sec.ifname or ""
    if sec.device == "radio0" and (ifn == "ra0" or ifn == "") then
        iface2g = sec[".name"]
    elseif sec.device == "radio1" and (ifn == "rai5" or ifn == "") then
        iface5g = sec[".name"]
    end
end)
if not iface2g then iface2g = "@wifi-iface[0]" end
if not iface5g then iface5g = "@wifi-iface[1]" end

s = m:section(TypedSection, "wifi-device", "")
s.anonymous = true
s.addremove = false
s.filter = function(self, section) return section == "radio0" end

en = s:option(ListValue, "_en", "Wi-Fi Status")
en:value("0", "Enabled")
en:value("1", "Disabled")
en.cfgvalue = function(self, section) return m.uci:get("wireless", iface2g, "disabled") or "0" end
en.write = function(self, section, value)
    m.uci:set("wireless", iface2g, "disabled", value)
    m.uci:set("wireless", iface5g, "disabled", value)
end

ssid = s:option(Value, "_ssid", "Unified Network Name (SSID)")
ssid.cfgvalue = function(self, section) return m.uci:get("wireless", iface2g, "ssid") end
ssid.write = function(self, section, value)
    m.uci:set("wireless", iface2g, "ssid", value)
    m.uci:set("wireless", iface5g, "ssid", value)
end

hid = s:option(ListValue, "_hid", "Broadcast SSID")
hid:value("0", "Visible")
hid:value("1", "Hidden")
hid.cfgvalue = function(self, section) return m.uci:get("wireless", iface2g, "hidden") or "0" end
hid.write = function(self, section, value)
    m.uci:set("wireless", iface2g, "hidden", value)
    m.uci:set("wireless", iface5g, "hidden", value)
end

enc = s:option(ListValue, "_enc", "Security")
enc:value("none", "Open (No Password)")
enc:value("psk-mixed", "WPA/WPA2-PSK (Mixed)")
enc:value("psk2", "WPA2-PSK (Recommended)")
enc.cfgvalue = function(self, section) return m.uci:get("wireless", iface2g, "encryption") or "none" end
enc.write = function(self, section, value)
    m.uci:set("wireless", iface2g, "encryption", value)
    m.uci:set("wireless", iface5g, "encryption", value)
end

key = s:option(Value, "_key", "Password")
key.password = true
key:depends("_enc", "psk2")
key:depends("_enc", "psk-mixed")
key.cfgvalue = function(self, section) return m.uci:get("wireless", iface2g, "key") end
key.write = function(self, section, value)
    m.uci:set("wireless", iface2g, "key", value)
    m.uci:set("wireless", iface5g, "key", value)
end

m.on_after_commit = function(self)
    os.execute("/usr/bin/zyxel_wifi_sync >/dev/null 2>&1 &")
end

return m
