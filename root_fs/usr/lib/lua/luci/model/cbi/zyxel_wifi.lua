m = Map("wireless", translate("Zyxel Wireless"), translate("Master configuration for your Zyxel hardware. Use this page instead of the default broken Wi-Fi page."))


s0 = m:section(NamedSection, "radio0", "wifi-device", translate("2.4GHz Hardware (ra0)"))
ch0 = s0:option(ListValue, "channel", translate("Operating Channel"))
ch0:value("auto", "Auto")
ch0:value("1", "Channel 1 (2.412 GHz)")
ch0:value("2", "Channel 2 (2.417 GHz)")
ch0:value("3", "Channel 3 (2.422 GHz)")
ch0:value("4", "Channel 4 (2.427 GHz)")
ch0:value("5", "Channel 5 (2.432 GHz)")
ch0:value("6", "Channel 6 (2.437 GHz)")
ch0:value("7", "Channel 7 (2.442 GHz)")
ch0:value("8", "Channel 8 (2.447 GHz)")
ch0:value("9", "Channel 9 (2.452 GHz)")
ch0:value("10", "Channel 10 (2.457 GHz)")
ch0:value("11", "Channel 11 (2.462 GHz)")

i0 = m:section(TypedSection, "wifi-iface", translate("2.4GHz Network Settings"))
i0.anonymous = true
i0.addremove = false
i0.filter = function(self, section) return m.uci:get("wireless", section, "device") == "radio0" end

en0 = i0:option(ListValue, "disabled", translate("Wi-Fi Status"))
en0:value("0", "Enabled")
en0:value("1", "Disabled")

ssid0 = i0:option(Value, "ssid", translate("Network Name (SSID)"))

hid0 = i0:option(ListValue, "hidden", translate("Broadcast SSID"))
hid0:value("0", "Visible")
hid0:value("1", "Hidden")

enc0 = i0:option(ListValue, "encryption", translate("Security"))
enc0:value("none", "Open (No Password)")
enc0:value("psk2", "WPA2-PSK (Recommended)")

key0 = i0:option(Value, "key", translate("Password"))
key0.password = true
key0:depends("encryption", "psk2")


s1 = m:section(NamedSection, "radio1", "wifi-device", translate("5GHz Hardware (rai0)"))
ch1 = s1:option(ListValue, "channel", translate("Operating Channel"))
ch1:value("auto", "Auto")
ch1:value("36", "Channel 36 (5.180 GHz)")
ch1:value("40", "Channel 40 (5.200 GHz)")
ch1:value("44", "Channel 44 (5.220 GHz)")
ch1:value("48", "Channel 48 (5.240 GHz)")
ch1:value("149", "Channel 149 (5.745 GHz)")
ch1:value("153", "Channel 153 (5.765 GHz)")
ch1:value("157", "Channel 157 (5.785 GHz)")
ch1:value("161", "Channel 161 (5.805 GHz)")

i1 = m:section(TypedSection, "wifi-iface", translate("5GHz Network Settings"))
i1.anonymous = true
i1.addremove = false
i1.filter = function(self, section) return m.uci:get("wireless", section, "device") == "radio1" end

en1 = i1:option(ListValue, "disabled", translate("Wi-Fi Status"))
en1:value("0", "Enabled")
en1:value("1", "Disabled")

ssid1 = i1:option(Value, "ssid", translate("Network Name (SSID)"))

hid1 = i1:option(ListValue, "hidden", translate("Broadcast SSID"))
hid1:value("0", "Visible")
hid1:value("1", "Hidden")

enc1 = i1:option(ListValue, "encryption", translate("Security"))
enc1:value("none", "Open (No Password)")
enc1:value("psk2", "WPA2-PSK (Recommended)")

key1 = i1:option(Value, "key", translate("Password"))
key1.password = true
key1:depends("encryption", "psk2")

return m
