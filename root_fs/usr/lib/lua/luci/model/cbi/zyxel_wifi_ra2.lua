m = Map("wireless", "2.4 GHz Guest 2 (ra2)", "Secondary virtual interface. Note: Channel and Transmit Power are inherited from the Main radio.")

local iface_sec = nil
m.uci:foreach("wireless", "wifi-iface", function(sec)
    if sec.ifname == "ra2" then
        iface_sec = sec[".name"]
    end
end)

if not iface_sec then
    iface_sec = m.uci:add("wireless", "wifi-iface")
    m.uci:set("wireless", iface_sec, "device", "radio0")
    m.uci:set("wireless", iface_sec, "ifname", "ra2")
    m.uci:set("wireless", iface_sec, "network", "lan")
    m.uci:set("wireless", iface_sec, "mode", "ap")
    m.uci:set("wireless", iface_sec, "ssid", "Zyxel_Guest_ra2")
    m.uci:set("wireless", iface_sec, "encryption", "none")
    m.uci:set("wireless", iface_sec, "disabled", "1")
    m.uci:save("wireless")
    m.uci:commit("wireless")
end

s = m:section(NamedSection, iface_sec, "wifi-iface", "")

en = s:option(ListValue, "disabled", "Wi-Fi Status")
en:value("0", "Enabled")
en:value("1", "Disabled")
en.rmempty = false

ssid = s:option(Value, "ssid", "Network Name (SSID)")
ssid.rmempty = false
ssid:depends("disabled", "0")

hid = s:option(ListValue, "hidden", "Broadcast SSID")
hid:value("0", "Visible")
hid:value("1", "Hidden")
hid.rmempty = false
hid:depends("disabled", "0")

enc = s:option(ListValue, "encryption", "Security")
enc:value("none", "Open (No Password)")
enc:value("psk-mixed", "WPA/WPA2-PSK (Mixed)")
enc:value("psk2", "WPA2-PSK (Recommended)")
enc.rmempty = false
enc:depends("disabled", "0")

key = s:option(Value, "key", "Password")
key.password = true
key:depends({disabled="0", encryption="psk2"})
key:depends({disabled="0", encryption="psk-mixed"})

mac = s:option(Value, "macaddr", "MAC Address Spoof")
mac.placeholder = "00:11:22:33:44:55"
mac:depends("disabled", "0")

max = s:option(Value, "maxassoc", "Max Clients Limit")
max.placeholder = "32"
max:depends("disabled", "0")

m.on_after_commit = function(self)
    os.execute("/usr/bin/zyxel_wifi_sync >/dev/null 2>&1 &")
end

return m