#!/bin/sh

# Copyright (C) ZyXEL Communications, Corp. All Rights Reserved.

#set -x

# WWANDIR: WWAN scripts's directory path
# DATAPATH: WWAN output files's directory path
# RUN_WWAN_PACKAGE: run_wwanpackage file path

# test
#env_var=`export`
#echo "$env_var" > /dev/console
#echo "================================================" > /dev/console
#exit

# option
if [ "$SUBSYSTEM" != "usb" ]; then
	exit
fi

WWANDIR=/sbin  # set the WWAN scripts's directory path #~!@#$%^&*()_+
. $WWANDIR/wwan-lib.sh

WWAN_MAIN=$WWANDIR/wwan-main.sh
DISABLE_HOTPLUG=$DATAPATH/disable-wwan-hotplug
HOTPLUG_LOCK_FE=.lock

if [ -f "$DISABLE_HOTPLUG" ]; then
	wwan_log "wwan-hotplug: hotplug disabled, exit"
	exit
fi

# check it is a "USB device hotplug event", WWAN doesn't care "USB interface event", "USB endpoint event" or "other event"
if [ "$DEVNUM" = "" -o "$PRODUCT" = "" ]; then
#	wwan_log "[$0] DEVNUM=$DEVNUM, PRODUCT=$PRODUCT; can't find DEVNUM or PRODUCT"
	exit
fi

# get VID and PID
HOTPLUG_VID=`echo "$PRODUCT" | tr -d '\r' | cut -d '/' -f 1`
HOTPLUG_PID=`echo "$PRODUCT" | tr -d '\r' | cut -d '/' -f 2`
if [ "$HOTPLUG_VID" = "" -o "$HOTPLUG_PID" = "" ]; then
#	wwan_log "[$0] VID=$HOTPLUG_VID, PID=$HOTPLUG_PID; can't find VID or PID"
	exit
fi
HOTPLUG_VID=`echo "0000""$HOTPLUG_VID" | cut -c $((${#HOTPLUG_VID} + 1))-$((${#HOTPLUG_VID} + 4))`
HOTPLUG_PID=`echo "0000""$HOTPLUG_PID" | cut -c $((${#HOTPLUG_PID} + 1))-$((${#HOTPLUG_PID} + 4))`

# Some weird devices don't change IDs. They only switch the device class.
# If the device has the target class -> no action (and vice versa)
# get class
HOTPLUG_CLASS=`echo "$TYPE" | tr -d '\r' | cut -d '/' -f 1`

# check it is a WWAN dongle
# *****TO DO??*****

HOTPLUG_DEVICE_ID=$DEVNUM:$HOTPLUG_VID:$HOTPLUG_PID
HOTPLUG_LOCK_FILE=$DATAPATH/$DEVICE_DATA_PRENAME:$HOTPLUG_DEVICE_ID$HOTPLUG_LOCK_FE

wwan_log "==================================================" 1

case $ACTION in
	add|"")
		wwan_log "[$0] event add $HOTPLUG_DEVICE_ID start"
		
		# device lock up first
		while ! mkdir $HOTPLUG_LOCK_FILE
		do
			wwan_log "[$0] $HOTPLUG_LOCK_FILE exist"
		    exit
		done
		wwan_log "[$0] create $HOTPLUG_LOCK_FILE"
		
		# save hotplug environment parameters
		# *****TO DO!!*****

		# run wwan-main.sh add
		wwan_log "[$0] $HOTPLUG_DEVICE_ID enter wwan-main.sh add"
		$WWAN_MAIN add $DEVNUM $HOTPLUG_VID $HOTPLUG_PID $HOTPLUG_CLASS
		
		wwan_log "[$0] event add $HOTPLUG_DEVICE_ID end"
		
		###test###
		#DEVICE_DIR=$DATAPATH/$DEVICE_DATA_PRENAME:$HOTPLUG_DEVICE_ID
		#DEVICE_STATUS_FILE=$DEVICE_DIR/$DEVICE_STATUS_NAME
		#DEVICE_STATUS=`cat $DEVICE_STATUS_FILE | tr -d '\r'`
		#if [ "$DEVICE_STATUS" = "DRIVER_READY" ]; then
		#	$WWAN_MAIN init $DEVNUM $HOTPLUG_VID $HOTPLUG_PID /var/home/root/wwan_config
		#	
		#	wwan_log "[$0] $WWAN_MAIN up $DEVNUM $HOTPLUG_VID $HOTPLUG_PID"
		#fi
		###test###
		
		;;
	remove)
		wwan_log "[$0] event remove $HOTPLUG_DEVICE_ID start"
		
		# run wwan-main.sh remove
		wwan_log "[$0] $HOTPLUG_DEVICE_ID enter wwan-main.sh remove"
		$WWAN_MAIN remove $DEVNUM $HOTPLUG_VID $HOTPLUG_PID
		
		# remove device lock
		wwan_log "[$0] remove $HOTPLUG_LOCK_FILE"
		rm -rf $HOTPLUG_LOCK_FILE
		;;
esac

wwan_log "==================================================" 1
wwan_log "" 1