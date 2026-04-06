#!/bin/sh
RUN=1
PROCESS="/bin/zupnp"
PROCESS_ARG=$1
PROCESS_PID=

kill_process() {
	trap '' INT TERM QUIT
	# echo "stop ${PROCESS}......." # Silenced
	if [ -n "$PROCESS_PID" ] && [ -e "/proc/$PROCESS_PID/status" ]; then
		kill -TERM $PROCESS_PID
	fi
	wait
	RUN=0
	exit
}

trap 'kill_process' INT TERM QUIT

while [ $RUN == 1 ]
do
	# INSTEAD of running the broken zupnp binary, we run a 24-hour sleep
	(trap - INT TERM QUIT; exec sleep 86400) &
	PROCESS_PID=$!
	
	# The script will now wait here peacefully for 24 hours at a time
	wait
	
	# echo "${PROCESS} restart....." # Silenced
done