local pcall, dofile, _G = pcall, dofile, _G

module "luci.version"

if pcall(dofile, "/etc/openwrt_release") and _G.DISTRIB_DESCRIPTION then
	distname    = ""
	distversion = _G.DISTRIB_DESCRIPTION
else
	distname    = "OpenWrt"
	distversion = "Development Snapshot"
end

luciname    = "LuCI 15.05-149-g0d8bbd2 Release"
luciversion = "git-15.363.78009-956be55"
