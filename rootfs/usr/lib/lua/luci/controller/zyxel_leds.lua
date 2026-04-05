module("luci.controller.zyxel_leds", package.seeall)

function index()
    entry({"admin", "system", "zyxel_leds"}, cbi("zyxel_leds"), "Zyxel LED Manager", 60)
end
