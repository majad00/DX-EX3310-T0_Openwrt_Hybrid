#!/bin/sh
SERVICE=$1

case "$2" in
    start)
             shift
             shift
             tmsctl $SERVICE start $@ &
             echo $!
             ;;
    stop)
             tmsctl $1 stop
             kill $3
             ;;
esac

exit 0
