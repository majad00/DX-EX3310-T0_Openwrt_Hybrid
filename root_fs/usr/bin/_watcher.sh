#!/bin/sh

# written by majad qureshi
insmod /lib/modules/3.18.21/pwm.ko 2>/dev/null
insmod /lib/modules/3.18.21/tcledctrl.ko 2>/dev/null
insmod /lib/modules/3.18.21/zyinetled.ko 2>/dev/null
echo 1 > /proc/tc3162/pwm_start

killall -9 fwwatcher zcmd zcfg_be 2>/dev/null

echo "80 8 1 0 1" > /proc/tc3162/led_def
echo "82 6 1 0 1" > /proc/tc3162/led_def
echo "33 4 1 0 1" > /proc/tc3162/led_def
echo "84 3 1 0 1" > /proc/tc3162/led_def
echo "13 21 1 0 1" > /proc/tc3162/led_def

echo "56 0 5 0 0" > /proc/tc3162/led_def
echo 0 > /proc/tc3162/led_pwr_green
echo 1 > /proc/tc3162/led_pwr_red

while true; do

    COUNT=$(cat /proc/tc3162/reset_button 2>/dev/null | awk '{print $1 + 0}')
    if [ "$COUNT" -ge 13 ]; then
        echo "RESET " > /dev/console
        rm -f /overlay/.reset /.reset
        echo 1 > /proc/tc3162/led_pwr_red 
        sync; reboot; exit 0
    fi


    if ifconfig eth3 2>/dev/null | grep -q "inet addr"; then
        echo 0 > /proc/tc3162/led_internet       
        echo 1 > /proc/tc3162/led_internet_red   
    else
        echo 1 > /proc/tc3162/led_internet       
        echo 0 > /proc/tc3162/led_internet_red   
    fi
 
    if ifconfig ra0 2>/dev/null | grep -q "UP"; then
        echo 0 > /proc/tc3162/led_wlan
    else
        echo 1 > /proc/tc3162/led_wlan
    fi

    sleep 2
done

