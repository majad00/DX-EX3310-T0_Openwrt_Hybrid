local nw = require "luci.model.network"
local sys = require "luci.sys"
local http = require "luci.http"

local apply_msg = ""

if http.formvalue("cbi.apply") then
    apply_msg = [[
    <div id="mesh-loading" style="padding: 15px; background-color: #fff3cd; color: #856404; border: 1px solid #ffeeba; margin-bottom: 20px; font-weight: bold; border-radius: 4px;">
        <span id="mesh-timer">Applying Mesh Settings... Please wait 20 seconds. (20)</span>
    </div>
    <script type="text/javascript">

        var btns = document.querySelectorAll('.cbi-button-apply, .cbi-button-save');
        btns.forEach(function(b){ b.disabled = true; b.style.opacity = '0.5'; });
        var timeLeft = 25;
        var timer = setInterval(function() {
            timeLeft--;
            var timerEl = document.getElementById('mesh-timer');
            if (timerEl) {
                timerEl.innerText = 'Applying Mesh Settings in the background... Please wait ' + timeLeft + ' seconds.';
            }
            if (timeLeft <= 0) {
                clearInterval(timer);
   
                window.location.replace(window.location.pathname + window.location.search);
            }
        }, 1000);
    </script>
    ]]
end

m = Map("wireless", translate("Transparent Mesh Backhaul"), 
    translate("Mesh backhaul acts as the backbone of your Wi-Fi without a need for a physical WAN port, simply connect to the main router's Wi-Fi.") .. "<br/><br/>" .. apply_msg)


s_status = m:section(TypedSection, "wifi-mesh", translate("Live Connection Status"))
s_status.anonymous = true
s_status.addremove = false

ip = s_status:option(DummyValue, "_ip", translate("Interface IP"))
ip.value = "Not Connected"
local device = luci.sys.exec("ifconfig br-mesh 2>/dev/null | grep 'inet addr' | awk '{print $2}' | cut -d: -f2")
if device and #device > 0 then ip.value = device end

rssi = s_status:option(DummyValue, "_rssi", translate("Signal Strength"))
rssi.value = "No Signal"
local signal = luci.sys.exec("chroot /tmp/zyxel_root /usr/sbin/iwpriv apcli0 stat | grep Rssi | awk '{print $2}'")
if signal and #signal > 0 and signal ~= "0" then rssi.value = signal .. " dBm" end
s = m:section(NamedSection, "mesh", "wifi-mesh", translate("Main Wi-Fi Device"))
s.anonymous = true

e = s:option(ListValue, "enabled", translate("Mesh Backhaul Status"))
e:value("1", translate("Enabled"))
e:value("0", translate("Disabled"))

ssid = s:option(Value, "ssid", translate("Parent SSID"))
ssid.rmempty = false  -- REQUIRES a value
ssid:depends("enabled", "1")

bssid = s:option(Value, "bssid", translate("Parent BSSID"))
bssid.rmempty = false  -- REQUIRES a value
bssid.datatype = "macaddr"  -- REQUIRES a valid XX:XX:XX:XX:XX:XX format
bssid:depends("enabled", "1")

p = s:option(Value, "password", translate("Password"))
p.password = true
p.rmempty = false  -- REQUIRES a value
p:depends("enabled", "1")

c = s:option(Value, "channel", translate("Target Channel"))
c.rmempty = false  -- REQUIRES a value
c.datatype = "uinteger"  -- REQUIRES a positive integer (number)
c:depends("enabled", "1")

m.on_after_commit = function(self)
    luci.sys.call("( sleep 2 && /usr/bin/wifi-backhaul.sh >/dev/null 2>&1 & )")
end

return m
