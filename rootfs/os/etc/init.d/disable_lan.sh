#!/bin/sh
LAN_STAT_CMD="cat /proc/tc3162/eth_port_status > /tmp/.boot_eth_stat"
case "$1" in
	start)
		eval $LAN_STAT_CMD
		echo "START disable Lan and Wan..."
		#Lan & Eth WAN
		/userfs/bin/ethphxcmd eth0 lanchip disable
		#xDSL
		/usr/bin/wan adsl close
		exit 0
		;;

	reload)
		echo "START enable Lan and Wan..."
		exit 0
		;;	

	stop)
		echo "START enable Lan and Wan..."
        #LAN & Eth WAN
		/userfs/bin/ethphxcmd p4txrxmacctl enable
		/userfs/bin/ethphxcmd eth0 lanchip enable
		#xDSL
		/usr/bin/wan adsl open
		exit 0
		;;

	*)
		echo "$0: unrecognized option $1"
		exit 1
		;;

esac

