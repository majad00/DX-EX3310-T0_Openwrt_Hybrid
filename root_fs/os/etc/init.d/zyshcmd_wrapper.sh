#!/bin/sh

export PATH=/home/bin:/home/scripts:/opt/bin:/bin:/sbin:/usr/bin:/usr/sbin
export LD_LIBRARY_PATH=/lib/public:/lib/private:/usr/lib:/lib:/usr/lib/ebtables:/usr/lib/iptables


EXEC_NAME=zyshcmd_wrapper
EXEC_PATH=/bin
USER=root


enable()
{
	PID=$(pgrep zyshcmd_wrapper)
	if [ "$PID" == "" ] ; then
          echo 'zyshcmd_wrapper Start.'
	  $EXEC_PATH/$EXEC_NAME
	fi
}

disable()
{
	killall -9 $EXEC_NAME
}


case "$1" in
	enable)
		PID=$(pgrep zyshcmd_wrapper)
		if [ "$PID" == "" ] ; then
		  enable
		else
		  echo 'zyshcmd_wrapper is already running !!!'
		fi
		exit 0
		;;
		
	disable)
		disable
		exit 0
		;;
	
	restart)
		disable
		enable
		exit 0
		;;
	*)
		enable
		exit 0
		;;

esac
