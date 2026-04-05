#!/bin/sh

export PATH=/home/bin:/home/scripts:/opt/bin:/bin:/sbin:/usr/bin:/usr/sbin:/userfs/bin
export LD_LIBRARY_PATH=/lib/public:/lib/private:/lib/gpl:/usr/lib:/lib:/lib64/gpl:/lib64:/usr/lib/ebtables:/usr/lib/iptables

PROCESS="/bin/zywifid_run.sh"
case "$1" in
	start)
		killall ${PROCESS##*/}
		exec ${PROCESS} &
		exit 0
		;;
		
	stop)
		killall ${PROCESS##*/}
		exit 0
		;;	

	*)
		echo "$0: unrecognized option $1"
		exit 1
		;;

esac

