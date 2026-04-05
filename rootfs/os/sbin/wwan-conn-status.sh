#!/bin/sh

# Copyright (C) ZyXEL Communications, Corp. All Rights Reserved.

# $1: device number
# $2: VID
# $3: PID

#set -x

# Environment Variables
#WWANPATH=/sbin  # set the WWAN directory path #~!@#$%^&*()_+

. $WWANPATH/wwan-lib.sh

#wwan_log "[$0] enter"

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

CMD_RESPONSE_NAME=cmd_tmp

DEVICE_DRIVER_FILE=$DEVICE_DIR/$DEVICE_DRIVER_NAME
DEVICE_CMD_FILE=$DEVICE_DIR/$DEVICE_CMD_IF_NAME
CMD_RESPONSE_FILE=$DEVICE_DIR/$CMD_RESPONSE_NAME
DEVICE_CONN_STATUS_FILE=$DEVICE_DIR/$DEVICE_CONN_STATUS_NAME

DEVICE_DRIVER=`cat $DEVICE_DRIVER_FILE`

# check cmd device
CMD_DEV_IF=`cat $DEVICE_CMD_FILE`
if [ "$CMD_DEV_IF" = "" ]; then
	echo "WITHOUT_CMD_DEV_IF" > $DEVICE_INIT_FILE
	wwan_log "[$0] can't find CMD_DEV_IF $CMD_DEV_IF, exit"
	exit
fi
CMD_IF_DEV=$DEVICEPATH/$CMD_DEV_IF

if  [ "$DEVICE_DRIVER" = "qmi-wwan usbserial" ]; then
	chat -V -s TIMEOUT 1 "" "AT+QNETDEVSTATUS?" "OK" "" < $CMD_IF_DEV > $CMD_IF_DEV 2> $CMD_RESPONSE_FILE

	if [ "`grep "QNETDEVSTATUS:" $CMD_RESPONSE_FILE |cut -d ',' -f 2`" = "2" ]; then
		echo "CONNECT" > $DEVICE_CONN_STATUS_FILE
		#wwan_log "qmi-wwan usbserial >> CONNECT"
		exit
	else
		echo "DISCONN" > $DEVICE_CONN_STATUS_FILE
		#wwan_log "qmi-wwan usbserial >> DISCONN"
		exit
	fi
elif [ "$DEVICE_DRIVER" = "qmi-wwan" ]; then
	zqmictl /dev/cdc-wdm0 --wds-get-packet-service-status > $CMD_RESPONSE_FILE

	if [ "`grep "disconnected" $CMD_RESPONSE_FILE | wc -l`" = "1" ]; then
		echo "DISCONN" > $DEVICE_CONN_STATUS_FILE
		exit
	elif [ "`grep "connected" $CMD_RESPONSE_FILE | wc -l`" = "1" ]; then
		echo "CONNECT" > $DEVICE_CONN_STATUS_FILE
		exit
	else
		echo "DISCONN" > $DEVICE_CONN_STATUS_FILE
		exit
	fi

elif [ "$DEVICE_DRIVER" = "cdc-ncm usbserial" ]; then
	chat -V -s TIMEOUT 1 "" "AT\^NDISSTATQRY?" "OK" "" < $CMD_IF_DEV > $CMD_IF_DEV 2> $CMD_RESPONSE_FILE

	if [ "`grep "NDISSTATQRY: 1" $CMD_RESPONSE_FILE | wc -l`" = "1" ]; then
		echo "CONNECT" > $DEVICE_CONN_STATUS_FILE
		exit
	elif [ "`grep "NDISSTATQRY: 0" $CMD_RESPONSE_FILE | wc -l`" = "1" ]; then
		echo "DISCONN" > $DEVICE_CONN_STATUS_FILE
		exit
	else
		echo "DISCONN" > $DEVICE_CONN_STATUS_FILE
		exit
	fi

elif [ "$DEVICE_DRIVER" = "gobinet usbserial" ]; then
	zqmictl /dev/qcqmi5 --gobinet_get_link_status > $CMD_RESPONSE_FILE

	if [ "`grep "disconnect" $CMD_RESPONSE_FILE | wc -l`" = "1" ]; then
		echo "DISCONN" > $DEVICE_CONN_STATUS_FILE
		exit
	elif [ "`grep "connect" $CMD_RESPONSE_FILE | wc -l`" = "1" ] ; then
		echo "CONNECT" > $DEVICE_CONN_STATUS_FILE
		exit
	else
		echo "DISCONN" > $DEVICE_CONN_STATUS_FILE
		exit
	fi

elif [ "$DEVICE_DRIVER" = "rmnet" ]; then
	wwan_log "[$0] rmnet device connect status"

	echo "UNKNOW" > $DEVICE_CONN_STATUS_FILE
elif [ "$DEVICE_DRIVER" = "cdc-ecm usbserial" ]; then
	wwan_log "[$0] cdc-ecm usbserial device connect status"

	echo "UNKNOW" > $DEVICE_CONN_STATUS_FILE
fi

if grep "CONNECT" $DEVICE_CONN_STATUS_FILE; then
	exit 111
elif grep "DISCONN" $DEVICE_CONN_STATUS_FILE; then
	exit 222
else
	exit 333
fi
