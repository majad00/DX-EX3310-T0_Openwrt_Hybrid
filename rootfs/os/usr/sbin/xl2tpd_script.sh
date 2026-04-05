#!/bin/sh
RUN=1
PROCESS="/usr/sbin/xl2tpd"
PROCESS_ARG=$*
PROCESS_PID=
PROCCESS_EXIST=
kill_process() {
	trap '' INT TERM QUIT
	echo "stop ${PROCESS}......."
	if [ -e "/proc/$PROCESS_PID/status" ]; then
		kill -TERM $PROCESS_PID
	else
		killall ${PROCESS##*/}
	fi
	if [ -e "/proc/$PROCESS_PID/status" ]; then
		kill -KILL $PROCESS_PID
	fi
	wait
	RUN=0
	exit
}
trap 'kill_process' INT TERM QUIT
while [ $RUN == 1 ]
do
	if [ ! -d "/sys/class/net/l2tp1/" ]; then	#no l2tp1 interface
		if [ -e "/proc/$PROCESS_PID/status" ]; then	#xl2tpd process exist
			PROCCESS_EXIST=1
		else	#xl2tpd not exist
			PROCCESS_EXIST=0
		fi
	else	#l2tp1 interface exist, but no IP
		IP_ADDR=$(ifconfig l2tp1 | grep 'inet addr:' | cut -d: -f2 | awk '{print $1}')
		if [ -z $IP_ADDR ] && [ -e "/proc/$PROCESS_PID/status" ]; then
			PROCCESS_EXIST=1
			echo "Process exist, no l2tp ip!"
		elif [ -z $IP_ADDR ] && [ ! -e "/proc/$PROCESS_PID/status" ]; then
			PROCCESS_EXIST=0
			echo "Process no exist, no l2tp ip!"
		fi
	fi

	if [ $PROCCESS_EXIST -eq 1 ]; then	#kill proccess, then restart it.
		#echo "Loss l2tp1, but have xl2tpd ${PROCESS_PID}"
		kill -TERM $PROCESS_PID
		wait
		sleep 2
		(exec ${PROCESS} ${PROCESS_ARG}) &
		PROCESS_PID=$!
		echo "${PROCESS} restart!!"
		PROCCESS_EXIST=3
	elif [ $PROCCESS_EXIST -eq 0 ]; then	#no process, just restart it
		#echo "No ${PROCESS}, will start it!"
		(exec ${PROCESS} ${PROCESS_ARG}) &
		PROCESS_PID=$!
		PROCCESS_EXIST=3
	fi
	#wait
	sleep 60
done
