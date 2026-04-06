#!/bin/sh

export PATH=/home/bin:/home/scripts:/opt/bin:/bin:/sbin:/usr/bin:/usr/sbin
#export LD_LIBRARY_PATH=/lib/public:/lib/private:/usr/lib:/lib:/usr/lib/ebtables:/usr/lib/iptables

SUPPORT_LIB64=`ls / | grep lib64`
if [ "$SUPPORT_LIB64" == "lib64" ] ;then
export LD_LIBRARY_PATH=/lib/public:/lib/private:/lib/gpl:/usr/lib:/lib:/usr/lib:/lib64/gpl:/lib64:/usr/lib/ebtables:/usr/lib/iptables
else
export LD_LIBRARY_PATH=/lib/public:/lib/private:/usr/lib:/lib:/usr/lib/ebtables:/usr/lib/iptables
fi

COLOR_REST='\e[0m';
COLOR_BLUE='\e[0;34m';

case "$1" in
	start)
		# Wait for loading datamodel
		sleep 10

		is_mfg=`cat /proc/nvram/wl_nand_manufacturer`
		check_lan_ip=`grep 192.192.192.4 /data/zcfg_config.json 2>/dev/null`
		if [ "$is_mfg" = "2" ] || [ "$is_mfg" = "3" ] || [ "$is_mfg" = "6" ] || [ "$is_mfg" = "7" ] \
		|| [ -n "$check_lan_ip" ];then
			echo -e "${COLOR_BLUE}zybtnchk is not running!${COLOR_REST}"
			exit 0
		else
			/bin/zybtnchk &
			exit 0
		fi
		;;

	*)
		echo "$0: unrecognized option $1"
		exit 1
		;;

esac
