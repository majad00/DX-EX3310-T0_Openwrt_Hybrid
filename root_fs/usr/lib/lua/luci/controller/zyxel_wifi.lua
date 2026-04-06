module("luci.controller.zyxel_wifi", package.seeall)

function index()
    entry({"admin", "network", "zyxel_wifi"}, alias("admin", "network", "zyxel_wifi", "unified"), "Zyxel Wi-Fi", 60)
    entry({"admin", "network", "zyxel_wifi", "unified"}, cbi("zyxel_wifi_unified"), "Smart Connect (Unified)", 1)
    entry({"admin", "network", "zyxel_wifi", "ra0"}, cbi("zyxel_wifi_2g"), "2.4 GHz Main", 2)
    entry({"admin", "network", "zyxel_wifi", "ra1"}, cbi("zyxel_wifi_ra1"), "2.4 GHz Guest 1", 3)
    entry({"admin", "network", "zyxel_wifi", "ra2"}, cbi("zyxel_wifi_ra2"), "2.4 GHz Guest 2", 4)
    entry({"admin", "network", "zyxel_wifi", "rai5"}, cbi("zyxel_wifi_5g"), "5 GHz Main", 5)
    entry({"admin", "network", "zyxel_wifi", "rai1"}, cbi("zyxel_wifi_rai1"), "5 GHz Guest 1", 6)
    entry({"admin", "network", "zyxel_wifi", "rai2"}, cbi("zyxel_wifi_rai2"), "5 GHz Guest 2", 7)
end
