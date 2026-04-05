#!/bin/sh

# Copyright (C) ZyXEL Communications, Corp. All Rights Reserved.

# need cmd: printf, cat, cut, wc, tr, grep, seq, head, tail

# $1: wwan-main cmd option (add, remove, init, info, up, down)
# $2: device number
# $3: VID
# $4: PID
# $5: CLASS (for add) or config file (for init)

# WWANPATH: WWAN scripts's directory path
# DATAPATH: WWAN output files's directory path
# RUN_WWAN_PACKAGE: run_wwanpackage file path

#set -x

WWANPATH=/sbin  # set the WWAN scripts's directory path #~!@#$%^&*()_+
export WWANPATH
. $WWANPATH/wwan-lib.sh

DEVICE_NUMBER=$2
VID=$3
PID=$4
if [ "$1" = "add" ]; then
	CLASS=$5
elif [ "$1" = "init" -o "$1" = "reinit" ]; then
	CONFIG_FILE=$5
fi
DEVICE_ID=$DEVICE_NUMBER:$VID:$PID
DEVICE_DIR=$DATAPATH/$DEVICE_DATA_PRENAME:$DEVICE_ID
DEVICE_STATUS_FILE=$DEVICE_DIR/$DEVICE_STATUS_NAME

if [ "$DEVICE_NUMBER" = "" -o "$VID" = "" -o "$PID" = "" ]; then
	wwan_log "[$0] DEVICE_NUMBER=$DEVICE_NUMBER, VID=$VID, PID=$PID; can't find DEVICE_NUMBER or VID or PID"
	exit
fi

#-------------------------------------------------------------------------------
# function : wwan_init
#
# $1 : /sbin/wwan-main.sh
# $2 : init / reinit
#
wwan_init () {
	wwan_log "------------------------------------------------" 1
	wwan_log "[$1] $2 case"

	wwan_log "[$1] $2 device $DEVICE_NUMBER start"
	$WWANPATH/wwan-init.sh $DEVICE_NUMBER $VID $PID $2 $CONFIG_FILE
	wwan_log "[$1] $2 device $DEVICE_NUMBER end"
		
	wwan_log "[$1] update info $DEVICE_NUMBER start"
	$WWANPATH/wwan-info.sh $DEVICE_NUMBER $VID $PID
	wwan_log "[$1] update info $DEVICE_NUMBER end"
		
	wwan_log "------------------------------------------------" 1
}

#-------------------------------------------------------------------------------
case $1 in
	add)
		wwan_log "------------------------------------------------" 1
		wwan_log "[$0] $1 case"
		
		# check parameters
		if [ "$DEVICE_NUMBER" = "" -o "$VID" = "" -o "$PID" = "" ]; then
			wwan_log "[$0] need operators [device number] [VID] [PID]" 0
			exit
		fi
		
		wwan_log "[$0] add device $DEVICE_NUMBER start"
		$WWANPATH/wwan-add.sh $DEVICE_NUMBER $VID $PID $CLASS
		wwan_log "[$0] add device $DEVICE_NUMBER end"
		
		wwan_log "[$0] update info $DEVICE_NUMBER start"
		$WWANPATH/wwan-info.sh $DEVICE_NUMBER $VID $PID
		wwan_log "[$0] update info $DEVICE_NUMBER end"
		
		wwan_log "------------------------------------------------" 1
		;;
	remove)
		wwan_log "------------------------------------------------" 1
		wwan_log "[$0] $1 case"
		
		wwan_log "[$0] remove device $DEVICE_NUMBER start"
		$WWANPATH/wwan-remove.sh $DEVICE_NUMBER $VID $PID
		wwan_log "[$0] remove device $DEVICE_NUMBER end"
		
		wwan_log "------------------------------------------------" 1
		;;
	init)
		wwan_init $0 $1
		;;
	reinit)
		wwan_init $0 $1
		;;
	update)
		wwan_log "------------------------------------------------" 1
		wwan_log "[$0] $1 case"
		
		wwan_log "[$0] update device status $DEVICE_NUMBER start"
		$WWANPATH/wwan-update.sh $DEVICE_NUMBER $VID $PID
		wwan_log "[$0] update device status $DEVICE_NUMBER end"
		
		wwan_log "------------------------------------------------" 1
		;;
	info)
		wwan_log "------------------------------------------------" 1
		wwan_log "[$0] $1 case"
		
		wwan_log "[$0] update info $DEVICE_NUMBER start"
		$WWANPATH/wwan-info.sh $DEVICE_NUMBER $VID $PID
		wwan_log "[$0] update info $DEVICE_NUMBER end"
		
		wwan_log "------------------------------------------------" 1
		;;
	status)
		wwan_log "------------------------------------------------" 1
#		wwan_log "[$0] $1 case"
		
#		wwan_log "[$0] connection status $DEVICE_NUMBER start"
		$WWANPATH/wwan-conn-status.sh $DEVICE_NUMBER $VID $PID
#		wwan_log "[$0] connection status $DEVICE_NUMBER end"
		
		wwan_log "------------------------------------------------" 1
		;;
	up)
		wwan_log "------------------------------------------------" 1
		wwan_log "[$0] $1 case"
		
		wwan_log "[$0] connection up $DEVICE_NUMBER start"
		$WWANPATH/wwan-conn-up.sh $DEVICE_NUMBER $VID $PID
		wwan_log "[$0] connection up $DEVICE_NUMBER end"
		
		wwan_log "------------------------------------------------" 1
		;;
	down)
		wwan_log "[$0] $1 case"
		
		wwan_log "[$0] connection down $DEVICE_NUMBER start"
		$WWANPATH/wwan-conn-down.sh $DEVICE_NUMBER $VID $PID
		wwan_log "[$0] connection down $DEVICE_NUMBER end"
		
		wwan_log "------------------------------------------------" 1
		;;
	*|"help")
		wwan_log "[$0] Copyright (C) ZyXEL Communications, Corp. All Rights Reserved." 0
		wwan_log "		version: $VERSION, cmd type [cmd] [device number] [VID] [PID]" 0
#		wwan_log "		add: add a WWAN device, [cmd] [device number] [VID] [PID] [CLASS]" 0
#		wwan_log "		remove: remove a WWAN device, [cmd] [device number] [VID] [PID]" 0
		wwan_log "		init: apply confing setting to init dongle, [cmd] [device number] [VID] [PID] (option)[config file]" 0
		wwan_log "		update: update WWAN sevice status, [cmd] [device number] [VID] [PID]" 0
		wwan_log "		info: update WWAN device information, [cmd] [device number] [VID] [PID]" 0
		wwan_log "		up: connection up, [cmd] [device number] [VID] [PID]" 0
		wwan_log "		down: connection down, [cmd] [device number] [VID] [PID]" 0
		;;
esac