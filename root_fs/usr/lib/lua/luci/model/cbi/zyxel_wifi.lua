m = Map("wireless", translate("Zyxel Hardware Channels"), translate("Set your physical channels here."))
s = m:section(NamedSection, "radio0", "wifi-device", translate("2.4GHz Radio (ra0)"))
s.anonymous = true
s:option(Value, "channel", translate("2.4GHz Channel (1-11)"))
s2 = m:section(NamedSection, "radio1", "wifi-device", translate("5GHz Radio (rai5)"))
s2.anonymous = true
s2:option(Value, "channel", translate("5GHz Channel (36, 40, 44, 48, 149+)"))
return m
