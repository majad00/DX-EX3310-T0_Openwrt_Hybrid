#!/bin/sh

# Copyright (C) ZyXEL Communications, Corp. All Rights Reserved.

# $1: device number
# $2: VID
# $3: PID

#set -x

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
DEVICE_DRIVER_FILE=$DEVICE_DIR/$DEVICE_DRIVER_NAME

DEVICE_DRIVER=`cat $DEVICE_DRIVER_FILE`

if [ "$DEVICE_DRIVER" = "rmnet" ]; then
	wwan_log "[$0] kill malmanager modem_restart mald"
	killall -9 malmanager modem_restart mald
fi

if [ "$DRIVER_BUILD_IN" != "y" ]; then
	if [ "$VID" = "19d2" -a "$PID" = "1405" ]; then
		wwan_log "[$0] special case; do nothing!"
	else
		# rmmod driver
		wwan_log "[$0] remove driver"
		rmmod option
		rmmod sierra
		rmmod usb_wwan
		rmmod usbserial
		rmmod qmi_wwan
		rmmod huawei_cdc_ncm
		rmmod cdc_ncm
		rmmod cdc_wdm
		rmmod lg-vl600
		rmmod cdc-acm
		rmmod rndis_host
		rmmod cdc_ether
		rmmod usbnet
		rmmod hso
		rmmod GobiNet
	fi
	#sleep $DELAY_DRIVER
fi

#rmmod device data
wwan_log "[$0] remove data directory, $DEVICE_DIR"
rm -rf $DEVICE_DIR

#rm PIN_verification result file
wwan_log "[$0] rm $DATAPATH/$PIN_VERIFICATION_NAME"
rm $DATAPATH/$PIN_VERIFICATION_NAME

wwan_log "[$0] remove device done, exit"
