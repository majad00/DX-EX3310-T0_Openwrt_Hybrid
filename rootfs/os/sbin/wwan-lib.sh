#!/bin/sh

# Copyright (C) ZyXEL Communications, Corp. All Rights Reserved.

#set -x

# WWANPATH: WWAN scripts's directory path
# DATAPATH: WWAN output files's directory path
# RUN_WWAN_PACKAGE: run_wwanpackage file path

DEBUG_MODE=1 #~!@#$%^&*()_+

VERSION=1.20 #~!@#$%^&*()_+

PRINTER_DEVICE=/dev/console #~!@#$%^&*()_+

DRIVER_BUILD_IN="n" #~!@#$%^&*()_+

# PATH
DATAPATH=/var/wwan # set WWAN output files's directory path
SYSTEMPATH=/sys
DEVICEPATH=/dev

# FILE
#RUN_WWAN_PACKAGE=/var/wwan/run_wwanpackage #~!@#$%^&*()_+
DEBUG_FILE=$DATAPATH/wwan.debug
WHL_FILE=/var/wwan/HWL

# VAULE
DEVICE_DATA_PRENAME=wwan_dev
DEVICE_CONFIG_NAME=config

DEVICE_INFO_NAME=dev_info

DEVICE_STATUS_NAME=dev_status
DEVICE_INIT_NAME=dev_init
DEVICE_TYPE_NAME=dev_type
DEVICE_DRIVER_NAME=dev_driver
DEVICE_DIAL_IF_NAME=dev_if_dial
DEVICE_CMD_IF_NAME=dev_if_cmd
DEVICE_ETH_IF_NAME=dev_if_eth
DEVICE_CONN_NAME=dev_conn
DEVICE_PPP_PID_NAME=dev_ppp_pid
DEVICE_MODEL_NAME=dev_name
DEVICE_PECULIAR_NAME=dev_peculiar
DEVICE_CONN_STATUS_NAME=dev_conn_status

DEVICE_VENDOR_NAME=dev_vendor
DEVICE_PRODUCT_NAME=dev_product

DEVICE_UPDATE_NAME=dev_update

MATCH_WWAN_PACKAGE_NAME=match_wwanpackage

DEVICE_PPP_3G_NAME=options_ppp_tty
DEVICE_PPP_CHAT_NAME=ppp_tty_chat

PIN_VERIFICATION_NAME=PIN_verification

# CONFIG
CONFIG_DIAL_NAME=DIAL
CONFIG_APN_NAME=APN
CONFIG_PIN_NAME=PIN
CONFIG_PUK_NAME=PUK
CONFIG_NEWPIN_NAME=NEWPIN
CONFIG_USERNAME_NAME=USERNAME
CONFIG_PASSWORD_NAME=PASSWORD
CONFIG_NAILEDUP_NAME=NAILEDUP
CONFIG_ONDEMAND_NAME=ONDEMAND
CONFIG_PPPIFNAME_NAME=PPPIFNAME

######################## FUNCTION START ########################
# function wwan_log()
# $1: print mesg
# $2: if 0 => don't write to debug file; if 1 => only write to debug file
wwan_log()
{
	if [ "$2" != "0" ]; then
		echo `date` "$1" >> $DEBUG_FILE
	fi
	
	if [ "$DEBUG_MODE" = "1" -a "$2" != "1" ]; then
		if [ "$PRINTER_DEVICE" = "" ]; then
			echo "@ $1 @"
		else
			echo "@ $1 @" >> $PRINTER_DEVICE
		fi
	fi
}

# function at_cmd()
# $1: cmd
# $2: device
# $3: output
# $4: wait time
at_cmd()
{
	if [ "$4" = "" ]; then
		kill_delay=1
	else
		kill_delay=$4
	fi
	
#	rm -rf $3
	echo -e "$1\r" > $2
	cat $2 > $3 &
	CAT_PID=$!
	
	sleep $kill_delay
#	kill $CAT_PID
#	sleep 1
	kill -9 $CAT_PID
}

# function Hex2Doc_Sub()
# $1: Hex, call by Hex2Doc()
# return: Doc
Hex2Doc_Sub()
{
	VALUE=$1
	if [ "$VALUE" = "f" -o "$VALUE" = "F" ]; then
		VALUE=15
	elif [ "$VALUE" = "e" -o "$VALUE" = "E" ]; then
		VALUE=14
	elif [ "$VALUE" = "d" -o "$VALUE" = "D" ]; then
		VALUE=13
	elif [ "$VALUE" = "c" -o "$VALUE" = "C" ]; then
		VALUE=12
	elif [ "$VALUE" = "b" -o "$VALUE" = "B" ]; then
		VALUE=11
	elif [ "$VALUE" = "a" -o "$VALUE" = "A" ]; then
		VALUE=10
	fi
	
	return $VALUE
}

# function Hex2Doc()
# $1: Hex
# return: Doc
Hex2Doc()
{
	VALUE=$1
	VALUE=`echo "00""$VALUE" | cut -c $((${#VALUE} + 1))-$((${#VALUE} + 2))`
	TENS=`echo "$VALUE" | cut -c 1-1`
	ONES=`echo "$VALUE" | cut -c 2-2`

	Hex2Doc_Sub $TENS
	TENS=$?
	TENS=$(($TENS*16))

	Hex2Doc_Sub $ONES
	ONES=$?

	return $(($TENS+$ONES))
}
######################## FUNCTION END ########################
