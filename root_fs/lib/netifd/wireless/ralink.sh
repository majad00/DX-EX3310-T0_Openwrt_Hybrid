#!/bin/sh
. /lib/netifd/netifd-wireless.sh

init_wireless_driver "$@"

drv_ralink_setup() {
    local radio="$1"
    
    # 1. Fire your custom translator script to program the hardware
    /usr/sbin/zyxel_wifi_sync
    
    # 2. Tell OpenWrt's brain that the interfaces successfully came online
    for vif in $(wireless_vif_devices "$radio"); do
        local ifname
        config_get ifname "$vif" ifname
        
        # This formally attaches ra0/rai0 to the LAN bridge in OpenWrt
        wireless_add_vif "$vif" "$ifname"
    done
    
    # 3. Report "GREEN / ACTIVE" status to LuCI
    wireless_set_up
}

drv_ralink_cleanup() {
    return
}

drv_ralink_teardown() {
    local radio="$1"
    # When you click "Disable" in LuCI, it runs this block
    if [ "$radio" = "radio0" ]; then
        ifconfig ra0 down
    elif [ "$radio" = "radio1" ]; then
        ifconfig rai0 down
    fi
}

add_driver ralink
