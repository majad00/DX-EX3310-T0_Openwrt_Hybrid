#!/bin/sh
# written by majad qureshi - OPTIMIZED FOR LOW CPU

insmod /lib/modules/3.18.21/pwm.ko 2>/dev/null
insmod /lib/modules/3.18.21/tcledctrl.ko 2>/dev/null
insmod /lib/modules/3.18.21/zyinetled.ko 2>/dev/null
echo 1 > /proc/tc3162/pwm_start


killall -9 fwwatcher zcmd zcfg_be 2>/dev/null


while true; do
    read -r RAW_COUNT < /proc/tc3162/reset_button 2>/dev/null
    COUNT=${RAW_COUNT%% *}  
    COUNT=${COUNT:-0}       

    if [ "$COUNT" -ge 10 ] 2>/dev/null; then
        echo "RESET " > /dev/console
        rm -f /overlay/.reset /.reset
        

        echo "80 8 1 0 0" > /proc/tc3162/led_def
        echo "33 4 1 0 0" > /proc/tc3162/led_def
        echo "13 21 1 0 0" > /proc/tc3162/led_def
        

        echo "82 6 1 0 1" > /proc/tc3162/led_def
        echo "84 3 1 0 1" > /proc/tc3162/led_def
        

        echo 0 > /proc/tc3162/led_pwr_red 2>/dev/null
        echo 0 > /proc/tc3162/led_internet_red 2>/dev/null
        

        echo 1 > /proc/tc3162/led_pwr_green 2>/dev/null
        echo 1 > /proc/tc3162/led_internet 2>/dev/null
        echo 1 > /proc/tc3162/led_wlan 2>/dev/null


        sync
        reboot
        exit 0
    fi

    sleep 3
done