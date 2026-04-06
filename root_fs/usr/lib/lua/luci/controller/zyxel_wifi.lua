module("luci.controller.zyxel_wifi", package.seeall)
function index()
    entry({"admin", "network", "zyxel_wifi"}, cbi("zyxel_wifi"), _("Zyxel Wifi"), 60)
end
