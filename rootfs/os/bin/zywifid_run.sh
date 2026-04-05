#!/bin/sh
PROFILE_CFG=/userfs/profile.cfg
if [ -f $PROFILE_CFG ] ; then
    . $PROFILE_CFG
fi

if [ -e /proc/zyxel/wifi_support ]
then
    WIFI_CHECK=`cat /proc/zyxel/wifi_support`
    if [ "$WIFI_CHECK" == "1" ]
    then
        echo "The device support wifi!"
        RUN=1
    else
        echo "The device does not support wifi!"
        RUN=0
    fi
else
    echo "The device support wifi!"
    RUN=1
fi

PROCESS="/bin/zywifid"
PROCESS_ARG=""
PROCESS_PID=
kill_process() {
        trap '' INT TERM QUIT
        echo "stop ${PROCESS}......."
        if [ -e "/proc/$PROCESS_PID/status" ]; then
                kill -TERM $PROCESS_PID
        else
                killall ${PROCESS##*/}
        fi
        wait
        RUN=0
if [ "$TCSUPPORT_WLAN_MT7915D" != "" ]; then
	    killall -15 wifi_config_save_receive 2>/dev/NULL
	    killall -15 map_start 2>/dev/NULL
	    killall -15 mapd 2>/dev/NULL
	    killall -15 p1905_managerd 2>/dev/NULL
	    killall -15 wapp 2>/dev/NULL
	    killall zyMAPSteer

        /sbin/ifconfig ra0 down
        /sbin/ifconfig ra1 down
        /sbin/ifconfig ra2 down
        /sbin/ifconfig ra3 down
        /sbin/ifconfig apcli0 down
        /sbin/ifconfig rai0 down
        /sbin/ifconfig rai1 down
        /sbin/ifconfig rai2 down
        /sbin/ifconfig rai3 down
        /sbin/ifconfig rai4 down
        /sbin/ifconfig rai5 down
        /sbin/ifconfig apclii0 down
        echo "All wifi interfaces down"
fi
        exit
}
trap 'kill_process' INT TERM QUIT
while [ $RUN == 1 ]
do
		killall -9 ${PROCESS##*/}
        (trap - INT TERM QUIT; exec ${PROCESS} ${PROCESS_ARG}) &
        PROCESS_PID=$!
        wait
        sleep 2
        echo "${PROCESS} restart....."
		PROCESS_ARG="auto"
done