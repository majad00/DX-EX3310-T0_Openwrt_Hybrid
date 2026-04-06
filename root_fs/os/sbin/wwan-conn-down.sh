#!/bin/sh

# Copyright (C) ZyXEL Communications, Corp. All Rights Reserved.

# $1: device number
# $2: VID
# $3: PID

#set -x

# Environment Variables
#WWANPATH=/sbin  # set the WWAN directory path #~!@#$%^&*()_+

. $WWANPATH/wwan-lib.sh

wwan_log "[$0] enter"

DEVICE_NUMBER=$1
VID=$2
PID=$3
if [ "$DEVICE_NUMBER" = "" -o "$VID" = "" -o "$PID" = "" ]; then
	wwan_log "[$0] DEVICE_NUMBER=$DEVICE_NUMBER, VID=$VID, PID=$PID; can't find DEVICE_NUMBER or VID or PID"
	exit
fi

DEVICE_ID=$DEVICE_NUMBER:$VID:$PID
DEVICE_DIR=$DATAPATH/$DEVICE_DATA_PRENAME:$DEVICE_ID
if ! [ -e "$DEVICE_DIR" ]; then
	wwan_log "[$0] can't find DEVICE_DIR $DEVICE_DIR, exit"
	exit
fi

DEVICE_PPP_PID_FILE=$DEVICE_DIR/$DEVICE_PPP_PID_NAME
PPP_PID=`cat $DEVICE_PPP_PID_FILE`
if [ "$PPP_PID" = "" ]; then
	wwan_log "[$0] PPP_PID is empty, connection down case interrupt, exit"
	exit
fi

wwan_log "[$0] kill -9 $PPP_PID"
kill -9 $PPP_PID

DEVICE_CONN_FILE=$DEVICE_DIR/$DEVICE_CONN_NAME
echo "DOWN" > $DEVICE_CONN_FILE
echo "" > $DEVICE_PPP_PID_FILE
wwan_log "[$0] connection down done, exit"
#exit
