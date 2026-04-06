module("luci.controller.about_mod", package.seeall)

function index()
    -- Adds the page under the "System" tab
    entry({"admin", "system", "about"}, template("about_mod"), _("About This Mod"), 99).dependent = false
end
