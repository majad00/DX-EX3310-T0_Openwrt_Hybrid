#!/bin/sh
RUN=1
PROCESS_PID=
kill_process() {
	trap '' INT TERM QUIT
	if [ -n "$PROCESS_PID" ] && [ -e "/proc/$PROCESS_PID/status" ]; then kill -TERM $PROCESS_PID; fi
	wait
	RUN=0
	exit
}
trap 'kill_process' INT TERM QUIT
while [ $RUN == 1 ]
do
	(trap - INT TERM QUIT; exec sleep 86400) &
	PROCESS_PID=$!
	wait
done