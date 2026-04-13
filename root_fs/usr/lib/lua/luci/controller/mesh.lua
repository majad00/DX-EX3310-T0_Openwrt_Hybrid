module("luci.controller.mesh", package.seeall)

function index()
    entry({"admin", "network", "mesh_backhaul"}, cbi("mesh_backhaul"), _("Mesh Backhaul"), 90)
end
