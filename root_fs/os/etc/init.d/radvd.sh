#!/bin/sh
EXEC_NAME=radvd
EXEC_PATH=/bin

CONF_FILE="/var/radvd_$2.conf"
PID_DIR="/var/run/radvd_$2.pid"
USER=root

start()
{
	$EXEC_NAME -C $CONF_FILE -p $PID_DIR &
}

stop()
{
	killall $EXEC_NAME
}

renew()
{
	if [ -f $PID_DIR ]; then
		echo "radvd renew prefix..."
		PID=`cat $PID_DIR`
		kill -SIGUSR1 $PID
	fi
}

case "$1" in
	start)
		PID=$(pgrep $EXEC_NAME)
		if [ "$PID" == "" ]; then
			start
		else
			echo "$EXEC_NAME is already running = $PID!!!"
		fi
		exit 0
		;;

	stop)
		echo "stoping $EXEC_NAME."
		stop
		sleep 1
		exit 0
		;;
	renew)
		renew
		exit 0
		;;
	*)
		echo "$0: unrecognized option $1"
		exit 1
		;;
esac
#
