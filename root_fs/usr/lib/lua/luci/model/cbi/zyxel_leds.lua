m = Map("zyxel_leds", "Zyxel Hardware LEDs", "Direct hardware LED control for the EX3301-T0.")

s = m:section(TypedSection, "led", "")
s.anonymous = false
s.addremove = false

name = s:option(DummyValue, "name", "Indicator")

trig = s:option(ListValue, "trigger", "Behavior")
trig:value("none", "Always OFF")
trig:value("default-on", "Always ON (Green)")
trig:value("default-red", "Always ON (Red)")
trig:value("netdev", "Network Activity (Ports/Wi-Fi)")
trig:value("usbdev", "USB Storage Attached")

return m
