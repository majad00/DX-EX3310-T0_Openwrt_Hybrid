#!/bin/sh

EXEC_NAME=smbd
EXEC_PATH=/usr/sbin
CONF_FILE=/var/samba/smb.conf
PID_DIR=/var/run
USER=root

start()
{
	nice -n 19 $EXEC_PATH/$EXEC_NAME -D -s $CONF_FILE --piddir=$PID_DIR &
}

stop()
{
	killall $EXEC_NAME
}

reload()
{
	killall -HUP $EXEC_NAME
}

case "$1" in
	start)
		PID=$(pgrep $EXEC_NAME)
		if [ "$PID" == "" ]; then
			if [ "$2" == "" ]; then
				echo "use default config file [$CONF_FILE]."
			else
				CONF_FILE=$2
			fi
			
			if [ "$3" == "" ]; then
				echo "use default PID dir [$PID_DIR]."
			else
				PID_DIR=$3
			fi
			
			echo "starting $EXEC_NAME."
			start
		else
			echo "$EXEC_NAME is already running !!!"
		fi
		exit 0
		;;

	stop)
		echo "stoping $EXEC_NAME."
		stop
		exit 0
		;;

	restart)
		echo "restarting $EXEC_NAME."
		stop
		start
		exit 0
		;;

	reload)
		echo "reload $EXEC_NAME."
		PID=$(pgrep $EXEC_NAME)
		if [ "$PID" == "" ]; then
			start
		else
			reload
		fi
		exit 0
		;;

	*)
		echo "$0: unrecognized option $1"
		exit 1
		;;

esac
#