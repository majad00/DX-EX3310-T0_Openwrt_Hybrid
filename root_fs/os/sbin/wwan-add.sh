#!/bin/sh

# Copyright (C) ZyXEL Communications, Corp. All Rights Reserved.

# $1: device number
# $2: VID
# $3: PID
# $4: CLASS

#set -x

# Environment Variables
#WWANPATH=/sbin  # set the WWAN directory path #~!@#$%^&*()_+

. $WWANPATH/wwan-lib.sh

wwan_log "[$0] enter"

KERNEL_VERSION=`uname -r` #~!@#$%^&*()_+
SERIAL_MODULES=/lib/modules/$KERNEL_VERSION #~!@#$%^&*()_+
CLASS_MODULES=/lib/modules/$KERNEL_VERSION #~!@#$%^&*()_+
USBNET_MODULES=/lib/modules/$KERNEL_VERSION #~!@#$%^&*()_+
RFKILL_MODULES=/lib/modules/$KERNEL_VERSION #~!@#$%^&*()_+
USB_DEVICE_LIST_DIR=/sys/bus/usb/devices

DEVICE_NUMBER=$1
VID=$2
PID=$3
if [ "$DEVICE_NUMBER" = "" -o "$VID" = "" -o "$PID" = "" ]; then
	wwan_log "[$0] DEVICE_NUMBER=$DEVICE_NUMBER, VID=$VID, PID=$PID; can't find DEVICE_NUMBER or VID or PID"
	exit
fi
CLASS=$4

DEVICE_ID=$DEVICE_NUMBER:$VID:$PID
DEVICE_DIR=$DATAPATH/$DEVICE_DATA_PRENAME:$DEVICE_ID
if [ -e "$DEVICE_DIR" ]; then
	wwan_log "[$0] $DEVICE_ID already processed, so do nothing now"
	exit
fi
# create WWAN device info dir
mkdir $DEVICE_DIR

DEVICE_STATUS_FILE=$DEVICE_DIR/$DEVICE_STATUS_NAME
DEVICE_TYPE_FILE=$DEVICE_DIR/$DEVICE_TYPE_NAME
DEVICE_DRIVER_FILE=$DEVICE_DIR/$DEVICE_DRIVER_NAME
DEVICE_DIAL_FILE=$DEVICE_DIR/$DEVICE_DIAL_IF_NAME
DEVICE_CMD_FILE=$DEVICE_DIR/$DEVICE_CMD_IF_NAME
DEVICE_MODEL_FILE=$DEVICE_DIR/$DEVICE_MODEL_NAME
DEVICE_PECULIAR_FILE=$DEVICE_DIR/$DEVICE_PECULIAR_NAME

MATCH_WWAN_PACKAGE=$DEVICE_DIR/$MATCH_WWAN_PACKAGE_NAME
MS_REPORT=$DEVICE_DIR/MS-report

WP_MODESWITCH_CMD_NAME="MODESWITCH_CMD"
WP_CHANGE_MODE_CMD_NAME="CHANGE_MODE_CMD"
WP_TARGET_CLASS_NAME="TARGET_CLASS"
WP_TARGET_IF_CLASS_NAME="TARGET_IF_CLASS"
WP_TARGET_IF_SUBCLASS_NAME="TARGET_IF_SUBCLASS"
WP_TARGET_IF_PROTOCOL_NAME="TARGET_IF_PROTOCOL"
WP_TARGET_IF_INFO_NAME="TARGET_IF_INFO"
WP_TARGET_NUM_INTERFACE_NAME="TARGET_NUM_INTERFACE"
WP_RESET_NAME="RESET"
WP_DRIVER_NAME="DRIVER"
WP_DIAL_INTERFACE_NAME="DIAL_INTERFACE"
WP_CMD_INTERFACE_NAME="CMD_INTERFACE"
WP_MODEL_NAME="NAME"
WP_PECULIAR="PECULIAR"
MODE_SWITCH_PRE_DELAY=2

echo "DETECT_USB_DEVICE" > $DEVICE_STATUS_FILE


check_ncm_support() {

	CMD_IFTERFACE=/dev/ttyUSB0
	CMD_RESPONSE_FILE=/tmp/cmd_response_file

	chat -V -s TIMEOUT 1 "" "ATI" "OK" "" < $CMD_IFTERFACE > $CMD_IFTERFACE 2> $CMD_RESPONSE_FILE

# Manufacturer: huawei
# Model: E3272
# Revision: 21.436.11.00.372
# IMEI: 862601021035482
# +GCAP: +CGSM,+DS,+ES

	DONGLE_NAME=`grep Model $CMD_RESPONSE_FILE | tr -d '\r' | cut -d ' ' -f 2-`
	wwan_log "[$0] $DONGLE_NAME"

	if [ "$DONGLE_NAME" != "E3272" ]; then
		return 1;
	fi

	chat -V -s TIMEOUT 1 "" "AT\^SETPORT=?" "OK" "" < $CMD_IFTERFACE > $CMD_IFTERFACE 2> $CMD_RESPONSE_FILE

# ^SETPORT:1: 3G MODEM
# ^SETPORT:2: 3G PCUI
# ^SETPORT:3: 3G DIAG
# ^SETPORT:5: 3G GPS
# ^SETPORT:A: BLUE TOOTH
# ^SETPORT:16: NCM
# ^SETPORT:A1: CDROM
# ^SETPORT:A2: SD
# ^SETPORT:10: 4G MODEM
# ^SETPORT:12: 4G PCUI
# ^SETPORT:13: 4G DIAG
# ^SETPORT:14: 4G GPS

	NCM_PORT_NUM=`grep "NCM" $CMD_RESPONSE_FILE | tr -d '\r' | cut -d ':' -f 2`

	chat -V -s TIMEOUT 1 "" "AT\^SETPORT?" "OK" "" < $CMD_IFTERFACE > $CMD_IFTERFACE 2> $CMD_RESPONSE_FILE

# ^SETPORT:A1,A2;10,12,16,A1,A2

	if [ "`grep $NCM_PORT_NUM $CMD_RESPONSE_FILE | wc -l`" != "0" ]; then
		wwan_log "[$0] SUPPORT NCM"
		return 0;
	else
		wwan_log "[$0] NOT SUPPORT NCM"
		return 1;
	fi
}

##################### usb modeswitch #####################
# need mode switch?
rm -rf $MATCH_WWAN_PACKAGE
$WWANPATH/wwan-package-match.sh DEFAULT $VID $PID $MATCH_WWAN_PACKAGE
if [ -f "$MATCH_WWAN_PACKAGE" ]; then
	MODEL_NAME=`grep $WP_MODEL_NAME $MATCH_WWAN_PACKAGE | tr -d '\r' | cut -d ' ' -f 2-`
	echo "$MODEL_NAME" > $DEVICE_MODEL_FILE

	PECULIAR_DONGLE=`grep $WP_PECULIAR $MATCH_WWAN_PACKAGE | tr -d '\r' | cut -d ' ' -f 2-`
	if [ "$PECULIAR_DONGLE" != "" ]; then
		echo "$PECULIAR_DONGLE" > $DEVICE_PECULIAR_FILE
	fi
	
	TARGET_CLASS=`grep $WP_TARGET_CLASS_NAME $MATCH_WWAN_PACKAGE | tr -d '\r' | tr -d ' ' | cut -d ':' -f 2`
	if [ "$TARGET_CLASS" != "" ]; then
		Hex2Doc $TARGET_CLASS
		TARGET_CLASS=$?
		if [ "$TARGET_CLASS" = "$CLASS" ]; then
			TARGET_MODE_HIT="1"
			wwan_log "[$0] TARGET_MODE_HIT set 1"
		fi
	fi
	
	TARGET_NUM_INTERFACE=`grep $WP_TARGET_NUM_INTERFACE_NAME $MATCH_WWAN_PACKAGE | tr -d '\r' | tr -d ' ' | cut -d ':' -f 2`
	if [ "$TARGET_NUM_INTERFACE" != "" ]; then
		# check DEVICE is /sys/bus/usb/devices/?-?, output to USB_DEVICE_DIR
		USB_DEVICE_LIST=`ls $USB_DEVICE_LIST_DIR | grep -v : | grep -v usb`
		cnt=`echo "$USB_DEVICE_LIST" | wc -l`
		for i in `seq 1 $cnt`; do
			SELECT_DEVICE=`echo "$USB_DEVICE_LIST" | head -$i | tail -1`
			USB_DEVICE_DIR=$USB_DEVICE_LIST_DIR/$SELECT_DEVICE
			SELECT_DEVNUM=`cat $USB_DEVICE_DIR/devnum`
			SELECT_VID=`cat $USB_DEVICE_DIR/idVendor`
			SELECT_PID=`cat $USB_DEVICE_DIR/idProduct`
			if [ "$SELECT_DEVNUM" -eq "$DEVICE_NUMBER" -a "$SELECT_VID" = "$VID" -a "$SELECT_PID" = "$PID" ]; then
				DEVICE_NUM_INTERFACE=`cat $USB_DEVICE_DIR/bNumInterfaces | tr -d '\r' | tr -d ' '`
				wwan_log "[$0] found bNumInterfaces is $DEVICE_NUM_INTERFACE"
				if [ "$TARGET_NUM_INTERFACE" = "$DEVICE_NUM_INTERFACE" ]; then
					TARGET_MODE_HIT="1"
					wwan_log "[$0] TARGET_MODE_HIT set 1"
				fi
				break
			fi
			USB_DEVICE_DIR=""
		done
	fi
	
	#if [ "$TARGET_CLASS" = "" -o "$TARGET_CLASS" != "$CLASS" ]; then
	if [ "$TARGET_MODE_HIT" != "1" ]; then
		echo "MODE_SWITCH" > $DEVICE_STATUS_FILE
		wwan_log "[$0] need mode switch"
		USB_MODESWITCH_CMD=`grep $WP_MODESWITCH_CMD_NAME $MATCH_WWAN_PACKAGE | tr -d '\r' | cut -d ':' -f 2`
		if [ "$USB_MODESWITCH_CMD" != "" ]; then
			if [ "$VID" = "12d1" -a "$PID" = "1f01" ]; then # spceial dongle, need to insmod drivers before modeswitch
				wwan_log "[$0] insmod usbnet"
				insmod $USBNET_MODULES/usbnet.ko
				wwan_log "[$0] insmod cdc_ether"
				insmod $USBNET_MODULES/cdc_ether.ko
			fi
			#sleep $MODE_SWITCH_PRE_DELAY
			wwan_log "[$0] usb_modeswitch -v $VID -p $PID $USB_MODESWITCH_CMD"
			usb_modeswitch -v $VID -p $PID $USB_MODESWITCH_CMD > $MS_REPORT
		else
			wwan_log "[$0] no need WWAN to mode switch"
		fi

		SWITCH_CMD=`grep "$WP_CHANGE_MODE_CMD_NAME" $MATCH_WWAN_PACKAGE | tr -d '\r' | cut -d ':' -f 2`
		if [ "$SWITCH_CMD" != "" ]; then
			sleep $MODE_SWITCH_PRE_DELAY
			wwan_log "[$0] need sepcial $SWITCH_CMD cmd"
			$SWITCH_CMD
		else
			wwan_log "[$0] no need sepcial mode switch cmd"
		fi
		
		
		RESET_FLAG=`grep $WP_RESET_NAME $MATCH_WWAN_PACKAGE | tr -d '\r' | cut -d ':' -f 2`
		if [ "$RESET_FLAG" != "" ]; then
			wwan_log "[$0] need to reset dongle"
			if [ "$RESET_FLAG" != "0" ]; then
				wwan_log "[$0] sleep $RESET_FLAG sec"
				sleep $RESET_FLAG
			fi
			wwan_log "[$0] usb_modeswitch -v $VID -p $PID -R 1"
			usb_modeswitch -v $VID -p $PID -R 1
		fi
		wwan_log "[$0] mode switch case done, exit"
		exit
	fi
fi

##################### insmod driver #####################
# in WWAN mode?
rm -rf $MATCH_WWAN_PACKAGE
$WWANPATH/wwan-package-match.sh TARGET $VID $PID $MATCH_WWAN_PACKAGE
if [ -f "$MATCH_WWAN_PACKAGE" ]; then
	echo "NEED_INSRET_DRIVER" > $DEVICE_STATUS_FILE
	wwan_log "[$0] need insert driver"
	
	MODEL_NAME=`grep $WP_MODEL_NAME $MATCH_WWAN_PACKAGE | tr -d '\r' | cut -d ' ' -f 2-`
	echo "$MODEL_NAME" > $DEVICE_MODEL_FILE

	PECULIAR_DONGLE=`grep $WP_PECULIAR $MATCH_WWAN_PACKAGE | tr -d '\r' | cut -d ' ' -f 2-`
	if [ "$PECULIAR_DONGLE" != "" ]; then
		echo "$PECULIAR_DONGLE" > $DEVICE_PECULIAR_FILE
	fi
	
	RESET_FLAG=`grep $WP_RESET_NAME $MATCH_WWAN_PACKAGE | tr -d '\r' | cut -d ':' -f 2`
	if [ "$RESET_FLAG" != "" -a "$RESET_FLAG" != "0" ]; then
		wwan_log "[$0] sleep $RESET_FLAG sec"
		sleep $RESET_FLAG
	fi
	
	DRIVER=`grep $WP_DRIVER_NAME $MATCH_WWAN_PACKAGE | tr -d '\r' | cut -d ':' -f 2 | cut -b 2-`

	if [ "$DRIVER_BUILD_IN" = "y" ]; then
		wwan_log "[$0] wait for driver init"
		sleep 1;
	fi
	
	if [ "$DRIVER" = "usbserial" ]; then
		if [ "$DRIVER_BUILD_IN" != "y" ]; then
##			wwan_log "[$0] $SERIAL_MODULES/usbserial.ko vendor=0x$VID product=0x$PID"
##			insmod $SERIAL_MODULES/usbserial.ko vendor=0x$VID product=0x$PID
			wwan_log "[$0] insmod usbserial"
			insmod $SERIAL_MODULES/usbserial.ko
			wwan_log "[$0] insmod usb_wwan"
			insmod $SERIAL_MODULES/usb_wwan.ko
			wwan_log "[$0] insmod option"
			insmod $SERIAL_MODULES/option.ko
		fi
		wwan_log "[$0] add \"$VID $PID\" to option.ko"
		echo "$VID $PID" > /sys/bus/usb-serial/drivers/option1/new_id
		DEVICE_TYPE=tty
		DEVICE_NAME=ttyUSB
	elif [ "$DRIVER" = "option" -o "$DRIVER" = "sierra" ]; then
		if [ "$DRIVER_BUILD_IN" != "y" ]; then
			wwan_log "[$0] insmod usbserial"
			insmod $SERIAL_MODULES/usbserial.ko
			wwan_log "[$0] insmod $DRIVER"
			insmod $SERIAL_MODULES/$DRIVER.ko
		fi
		DRIVER="${DRIVER}1"
		DEVICE_TYPE=tty
		DEVICE_NAME=ttyUSB
	elif [ "$DRIVER" = "cdc-acm" ]; then
		if [ "$DRIVER_BUILD_IN" != "y" ] ; then
			wwan_log "[$0] insmod cdc-acm"
			insmod $CLASS_MODULES/cdc-acm.ko
		fi
		DEVICE_TYPE=tty
		DEVICE_NAME=ttyACM
	elif [ "$DRIVER" = "cdc-ecm" ]; then
		if [ "$DRIVER_BUILD_IN" != "y" ]; then
			wwan_log "[$0] insmod usbnet"
			insmod $USBNET_MODULES/usbnet.ko
			wwan_log "[$0] insmod cdc_ether"
			insmod $USBNET_MODULES/cdc_ether.ko
		fi
		DEVICE_TYPE=net
	elif [ "$DRIVER" = "cdc-ncm" ]; then
		if [ "$DRIVER_BUILD_IN" != "y" ]; then
			wwan_log "[$0] insmod usbnet"
			insmod $USBNET_MODULES/usbnet.ko
			wwan_log "[$0] insmod cdc_ncm"
			insmod $USBNET_MODULES/cdc_ncm.ko
		fi

		CLASS=`grep $WP_TARGET_IF_CLASS_NAME $MATCH_WWAN_PACKAGE | tr -d '\r' | cut -d ':' -f 2 | cut -b 2-`
		SUBCLASS=`grep $WP_TARGET_IF_SUBCLASS_NAME $MATCH_WWAN_PACKAGE | tr -d '\r' | cut -d ':' -f 2 | cut -b 2-`
		PROTOCOL=`grep $WP_TARGET_IF_PROTOCOL_NAME $MATCH_WWAN_PACKAGE | tr -d '\r' | cut -d ':' -f 2 | cut -b 2-`
		INFO=`grep $WP_TARGET_IF_INFO_NAME $MATCH_WWAN_PACKAGE | tr -d '\r' | cut -d ':' -f 2 | cut -b 2-`

		wwan_log "[$0] add \"$VID $PID $CLASS $SUBCLASS $PROTOCOL $INFO\" to cdc_ncm.ko"
		echo "$VID $PID $CLASS $SUBCLASS $PROTOCOL $INFO" > /sys/bus/usb/drivers/cdc_ncm/new_id

		DEVICE_TYPE=net
	elif [ "$DRIVER" = "cdc-ncm usbserial" ]; then
		wwan_log "[$0] Special case, insmod cdc-ncm and usbserial at sametime"
		if [ "$DRIVER_BUILD_IN" != "y" ]; then
			wwan_log "[$0] insmod usbnet"
			insmod $USBNET_MODULES/usbnet.ko
#			wwan_log "[$0] insmod cdc-wdm"
#			insmod $CLASS_MODULES/cdc-wdm.ko
			wwan_log "[$0] insmod cdc_ncm"
			insmod $USBNET_MODULES/cdc_ncm.ko
#			wwan_log "[$0] insmod huawei_cdc_ncm"
#			insmod $USBNET_MODULES/huawei_cdc_ncm.ko

			wwan_log "[$0] insmod usbserial"
			insmod $SERIAL_MODULES/usbserial.ko
			wwan_log "[$0] insmod usb_wwan"
			insmod $SERIAL_MODULES/usb_wwan.ko
			wwan_log "[$0] insmod option"
			insmod $SERIAL_MODULES/option.ko
		fi

		CLASS=`grep $WP_TARGET_IF_CLASS_NAME $MATCH_WWAN_PACKAGE | tr -d '\r' | cut -d ':' -f 2 | cut -b 2-`
		SUBCLASS=`grep $WP_TARGET_IF_SUBCLASS_NAME $MATCH_WWAN_PACKAGE | tr -d '\r' | cut -d ':' -f 2 | cut -b 2-`
		PROTOCOL=`grep $WP_TARGET_IF_PROTOCOL_NAME $MATCH_WWAN_PACKAGE | tr -d '\r' | cut -d ':' -f 2 | cut -b 2-`
		INFO=`grep $WP_TARGET_IF_INFO_NAME $MATCH_WWAN_PACKAGE | tr -d '\r' | cut -d ':' -f 2 | cut -b 2-`

		wwan_log "[$0] add \"$VID $PID $CLASS $SUBCLASS $PROTOCOL $INFO\" to cdc_ncm.ko"
		echo "$VID $PID $CLASS $SUBCLASS $PROTOCOL $INFO" > /sys/bus/usb/drivers/cdc_ncm/new_id

		wwan_log "[$0] add \"$VID $PID\" to option.ko"
		echo "$VID $PID" > /sys/bus/usb-serial/drivers/option1/new_id

		DEVICE_TYPE=net

		#
		# only support E3272 12d1:1506 
		#
		if [ "$VID" = "12d1" -a "$PID" = "1506" ]; then
			if check_ncm_support; then
				wwan_log "[$0] NCM mode"
				DEVICE_TYPE=net
			else
				wwan_log "[$0] Serial mode"
				DEVICE_TYPE=tty
				DEVICE_NAME=ttyUSB
			fi
		fi

	elif [ "$DRIVER" = "rndis_host" ]; then
		if [ "$DRIVER_BUILD_IN" != "y" ]; then
			wwan_log "[$0] insmod usbnet"
			insmod $USBNET_MODULES/usbnet.ko
			wwan_log "[$0] insmod cdc_ether"
			insmod $USBNET_MODULES/cdc_ether.ko
			wwan_log "[$0] insmod rndis_host"
			insmod $USBNET_MODULES/rndis_host.ko
		fi
		DEVICE_TYPE=net
	elif [ "$DRIVER" = "hso" ]; then
		if [ "$DRIVER_BUILD_IN" != "y" ]; then
			wwan_log "[$0] insmod rfkill"
			insmod $RFKILL_MODULES/rfkill.ko
			wwan_log "[$0] insmod hso"
			insmod $USBNET_MODULES/hso.ko
		fi
		wwan_log "[$0] add \"$VID $PID\" to hso.ko"
		echo "$VID $PID" > /sys/bus/usb/drivers/hso/new_id
		DEVICE_TYPE=tty
		DEVICE_NAME=ttyHS
	elif [ "$DRIVER" = "qmi-wwan" ]; then
		if [ "$DRIVER_BUILD_IN" != "y" ]; then
			wwan_log "[$0] insmod usbnet"
			insmod $USBNET_MODULES/usbnet.ko
			wwan_log "[$0] insmod cdc-wdm"
			insmod $CLASS_MODULES/cdc-wdm.ko
			wwan_log "[$0] insmod qmi_wwan"
			insmod $USBNET_MODULES/qmi_wwan.ko
		fi

		CLASS=`grep $WP_TARGET_IF_CLASS_NAME $MATCH_WWAN_PACKAGE | tr -d '\r' | cut -d ':' -f 2 | cut -b 2-`
		SUBCLASS=`grep $WP_TARGET_IF_SUBCLASS_NAME $MATCH_WWAN_PACKAGE | tr -d '\r' | cut -d ':' -f 2 | cut -b 2-`
		PROTOCOL=`grep $WP_TARGET_IF_PROTOCOL_NAME $MATCH_WWAN_PACKAGE | tr -d '\r' | cut -d ':' -f 2 | cut -b 2-`
		INFO=`grep $WP_TARGET_IF_INFO_NAME $MATCH_WWAN_PACKAGE | tr -d '\r' | cut -d ':' -f 2 | cut -b 2-`

		wwan_log "[$0] add \"$VID $PID $CLASS $SUBCLASS $PROTOCOL $INFO\" to qmi_wwan.ko"

		echo "$VID $PID $CLASS $SUBCLASS $PROTOCOL $INFO" > /sys/bus/usb/drivers/qmi_wwan/new_id
		DEVICE_TYPE=net
	elif [ "$DRIVER" = "qmi-wwan usbserial" ]; then
	# for MX5301 Quctel solution (EG06/EG12)
		if [ "$DRIVER_BUILD_IN" != "y" ]; then
			wwan_log "Quectel insmod driver --- BEGIN"
			wwan_log "[$0] insmod usbserial"
			insmod $USBNET_MODULES/usbserial.ko
			wwan_log "[$0] insmod usbnet"
			insmod $USBNET_MODULES/usbnet.ko
			wwan_log "[$0] insmod usb_wwan"
			insmod $CLASS_MODULES/usb_wwan.ko
			wwan_log "[$0] insmod option"
			insmod $CLASS_MODULES/option.ko
			wwan_log "[$0] modprobe qmi_wwan_q"
			modprobe qmi_wwan_q.ko
			wwan_log "[$0] modprobe qmi_wwan"
			modprobe qmi_wwan.ko
			wwan_log "Quectel insmod driver --- END"
		fi
		CLASS=`grep $WP_TARGET_IF_CLASS_NAME $MATCH_WWAN_PACKAGE | tr -d '\r' | cut -d ':' -f 2 | cut -b 2-`
		SUBCLASS=`grep $WP_TARGET_IF_SUBCLASS_NAME $MATCH_WWAN_PACKAGE | tr -d '\r' | cut -d ':' -f 2 | cut -b 2-`
		PROTOCOL=`grep $WP_TARGET_IF_PROTOCOL_NAME $MATCH_WWAN_PACKAGE | tr -d '\r' | cut -d ':' -f 2 | cut -b 2-`
		INFO=`grep $WP_TARGET_IF_INFO_NAME $MATCH_WWAN_PACKAGE | tr -d '\r' | cut -d ':' -f 2 | cut -b 2-`

		wwan_log "[$0] add \"$VID $PID $CLASS $SUBCLASS $PROTOCOL $INFO\" to qmi_wwan_q.ko"

		echo "$VID $PID $CLASS $SUBCLASS $PROTOCOL $INFO" > /sys/bus/usb/drivers/qmi_wwan_q/new_id
		DEVICE_TYPE=net
	elif [ "$DRIVER" = "lg-vl600" ]; then
		if [ "$DRIVER_BUILD_IN" != "y" ]; then
			wwan_log "[$0] insmod cdc-acm"
			insmod $CLASS_MODULES/cdc-acm.ko
			wwan_log "[$0] insmod $DRIVER"
			insmod /lib/modules/usbhost/$DRIVER.ko
		fi
	elif [ "$DRIVER" = "rmnet" ]; then
		if [ "$DRIVER_BUILD_IN" != "y" ]; then
			wwan_log "[$0] need to insmod, yet"
		fi
		DEVICE_TYPE=net
		malmanager -c /var/malmanager.cfg > /dev/null &
	elif [ "$DRIVER" = "cdc-ecm usbserial" ]; then
		wwan_log "[$0] Special case, insmod cdc-ecm and usbserial at sametime"
		#if [ "$DRIVER_BUILD_IN" != "y" ]; then
			wwan_log "[$0] insmod usbnet"
			insmod $USBNET_MODULES/usbnet.ko
			wwan_log "[$0] insmod cdc_ether"
			insmod $USBNET_MODULES/cdc_ether.ko

			wwan_log "[$0] insmod usbserial"
			insmod $SERIAL_MODULES/usbserial.ko
			wwan_log "[$0] insmod usb_wwan"
			insmod $SERIAL_MODULES/usb_wwan.ko
			wwan_log "[$0] insmod option"
			insmod $SERIAL_MODULES/option.ko
			wwan_log "[$0] add \"$VID $PID\" to option.ko"
		#fi
		echo "$VID $PID" > /sys/bus/usb-serial/drivers/option1/new_id
		DEVICE_TYPE=net
	elif [ "$DRIVER" = "gobinet usbserial" ]; then
		wwan_log "[$0] GobiNet, insmod GobiNet and usbserial at sametime"
		#if [ "$DRIVER_BUILD_IN" != "y" ]; then
			wwan_log "[$0] insmod usbnet"
			insmod $USBNET_MODULES/usbnet.ko
			wwan_log "[$0] insmod GobiNet"
			insmod $SERIAL_MODULES/GobiNet.ko
			wwan_log "[$0] insmod usbserial"
			insmod $SERIAL_MODULES/usbserial.ko
			wwan_log "[$0] insmod usb_wwan"
			insmod $SERIAL_MODULES/usb_wwan.ko
			wwan_log "[$0] insmod option"
			insmod $SERIAL_MODULES/option.ko
			wwan_log "[$0] add \"$VID $PID\" to option.ko"
		#fi
		echo "$VID $PID" > /sys/bus/usb-serial/drivers/option1/new_id
		DEVICE_TYPE=net
	else
		echo "UNKNOWN_DRIVER" > $DEVICE_STATUS_FILE
		wwan_log "[$0] unknown driver $DRIVER"
		wwan_log "[$0] insert driver case interrupt, exit"
		exit
	fi
	
	echo "$DEVICE_TYPE" > $DEVICE_TYPE_FILE
	echo "$DRIVER" > $DEVICE_DRIVER_FILE
	echo "INSRET_DRIVER" > $DEVICE_STATUS_FILE
	wwan_log "[$0] insert driver case done, exit"
	
##################### search interface or tty device #####################
	# check DEVICE is /sys/bus/usb/devices/?-?, output to USB_DEVICE_DIR
	USB_DEVICE_LIST=`ls $USB_DEVICE_LIST_DIR | grep -v : | grep -v usb`
	cnt=`echo "$USB_DEVICE_LIST" | wc -l`
	for i in `seq 1 $cnt`; do
		SELECT_DEVICE=`echo "$USB_DEVICE_LIST" | head -$i | tail -1`
		USB_DEVICE_DIR=$USB_DEVICE_LIST_DIR/$SELECT_DEVICE
		SELECT_DEVNUM=`cat $USB_DEVICE_DIR/devnum`
		SELECT_VID=`cat $USB_DEVICE_DIR/idVendor`
		SELECT_PID=`cat $USB_DEVICE_DIR/idProduct`
		if [ "$SELECT_DEVNUM" -eq "$DEVICE_NUMBER" -a "$SELECT_VID" = "$VID" -a "$SELECT_PID" = "$PID" ]; then
			echo "SYSDEV_READY" > $DEVICE_STATUS_FILE
			wwan_log "[$0] found device in system"
			break
		fi
		USB_DEVICE_DIR=""
	done
	
	if [ "$USB_DEVICE_DIR" = "" ]; then
		echo "WITHOUT_SYSDEV" > $DEVICE_STATUS_FILE
		wwan_log "[$0] can't find device in system"
		wwan_log "[$0] search interface case interrupt, exit"
		exit
	fi
	
	# find which INTERFACE (/sys/bus/usb/devices/?-?/?-?:?-?) have ttyDEV or netIF, output to USB_INTERFACE_DEVICE
	USB_INTERFACE_LIST=`ls $USB_DEVICE_DIR | grep :`
	cnt=`echo "$USB_INTERFACE_LIST" | wc -l`
	for i in `seq 1 $cnt`; do
		SELECT_INTERFACE=`echo "$USB_INTERFACE_LIST" | head -$i | tail -1`
		USB_INTERFACE_DIR=$USB_DEVICE_DIR/$SELECT_INTERFACE
		USB_INTERFACE_DEVICE=`ls $USB_INTERFACE_DIR | grep $DEVICE_TYPE`
		if [ "$USB_INTERFACE_DEVICE" != "" ]; then
			break
		fi
		USB_INTERFACE_DEVICE=""
	done
	
	if [ "$USB_INTERFACE_DEVICE" = "" ]; then
		echo "WITHOUT_IFDEV" > $DEVICE_STATUS_FILE
		wwan_log "[$0] can't find interface device in system"
		wwan_log "[$0] search interface case interrupt, exit"
		exit
	fi
	
	# find dial device name of ttyDEV or netIF, output to REAL_IF_DEV
	if [ "$DEVICE_TYPE" = "tty" ]; then
		if echo "$USB_INTERFACE_DEVICE" | grep :; then
			REAL_IF_DEV=`echo "$USB_INTERFACE_DEVICE" | cut -d ':' -f 2`
		else
			REAL_IF_DEV=`echo "$USB_INTERFACE_DEVICE" | grep $DEVICE_NAME` # MTK platform, BRCM platform
		fi
		if [ "$REAL_IF_DEV" = "" ]; then
			REAL_IF_DEV=`ls $USB_INTERFACE_DIR/$USB_INTERFACE_DEVICE | grep $DEVICE_NAME`
			ls $USB_INTERFACE_DIR/$USB_INTERFACE_DEVICE
			if [ "$REAL_IF_DEV" = "" ]; then
				echo "WITHOUT_REAL_IFDEV" > $DEVICE_STATUS_FILE
				wwan_log "[$0] can't find interface device in system"
				wwan_log "[$0] search interface case interrupt, exit"
				exit
			fi
		fi
		TTY_NUMBER=`echo ${REAL_IF_DEV} | cut -c $((${#DEVICE_NAME} + 1)) - ${#REAL_IF_DEV}`
		DIAL_IF=`grep $WP_DIAL_INTERFACE_NAME $MATCH_WWAN_PACKAGE | tr -d '\r' | tr -d ' ' | cut -d ':' -f 2`
		CMD_IF=`grep $WP_CMD_INTERFACE_NAME $MATCH_WWAN_PACKAGE | tr -d '\r' | tr -d ' ' | cut -d ':' -f 2`

		if [ "$VID" = "12d1" -a "$PID" = "1506" ]; then
			DIAL_IF=0
			CMD_IF=0
		fi

		REAL_DIAL_IF_DEV=$DEVICE_NAME$(($TTY_NUMBER + $DIAL_IF))
		echo "$REAL_DIAL_IF_DEV" > $DEVICE_DIAL_FILE
		REAL_CMD_IF_DEV=$DEVICE_NAME$(($TTY_NUMBER + $CMD_IF))
		echo "$REAL_CMD_IF_DEV" > $DEVICE_CMD_FILE
	elif [ "$DEVICE_TYPE" = "net" ]; then
		if echo "$USB_INTERFACE_DEVICE" | grep :; then
			REAL_DIAL_IF_DEV=`echo "$USB_INTERFACE_DEVICE" | cut -d ':' -f 2` # MTK platform
		else
			REAL_DIAL_IF_DEV=`ls $USB_INTERFACE_DIR/$USB_INTERFACE_DEVICE` # BRCM platform
		fi
		if [ "$REAL_DIAL_IF_DEV" = "" ]; then
			echo "WITHOUT_REAL_IFDEV" > $DEVICE_STATUS_FILE
			wwan_log "[$0] can't find interface device in system"
			wwan_log "[$0] search interface case interrupt, exit"
			exit
		fi
		if [ "$DRIVER" = "rmnet" ]; then
			if echo "$REAL_DIAL_IF_DEV" | grep "rmnet_usb"; then
				REAL_DIAL_IF_DEV="rmnet_data0"
			fi
		fi
		echo "$REAL_DIAL_IF_DEV" > $DEVICE_DIAL_FILE
		
		if [ "$DRIVER" = "qmi-wwan" ]; then
			REAL_CMD_IF_DEV=`ls $USB_INTERFACE_DIR/"usb"` # BRCM platform
			echo "$REAL_CMD_IF_DEV" > $DEVICE_CMD_FILE
		fi

		if [ "$DRIVER" = "qmi-wwan usbserial" ]; then
			DEVICE_NAME_Q=`grep DEVICE $MATCH_WWAN_PACKAGE | tr -d '\r' | cut -d ':' -f 2 | cut -b 2-`
			TTY_NUMBER_Q=`grep CMD_INTERFACE $MATCH_WWAN_PACKAGE | tr -d '\r' | cut -d ':' -f 2 | cut -b 2-`
			REAL_CMD_IF_DEV=$DEVICE_NAME_Q$TTY_NUMBER_Q # for AT channel
			echo "$REAL_CMD_IF_DEV" > $DEVICE_CMD_FILE
			#wwan_log "REAL_CMD_IF_DEV : $REAL_CMD_IF_DEV"
		fi

		if [ "$DRIVER" = "cdc-ecm usbserial" -o "$DRIVER" = "gobinet usbserial" -o "$DRIVER" = "cdc-ncm usbserial" ]; then
			USB_INTERFACE_LIST=`ls $USB_DEVICE_DIR | grep :`
			cnt=`echo "$USB_INTERFACE_LIST" | wc -l`
			for i in `seq 1 $cnt`; do
				SELECT_INTERFACE=`echo "$USB_INTERFACE_LIST" | head -$i | tail -1`
				USB_INTERFACE_DIR=$USB_DEVICE_DIR/$SELECT_INTERFACE
				USB_INTERFACE_DEVICE=`ls $USB_INTERFACE_DIR | grep "tty"`
				if [ "$USB_INTERFACE_DEVICE" != "" ]; then
					break
				fi
				USB_INTERFACE_DEVICE=""
			done
			DEVICE_NAME_T=ttyUSB
			if echo "$USB_INTERFACE_DEVICE" | grep :; then
				REAL_IF_DEV=`echo "$USB_INTERFACE_DEVICE" | cut -d ':' -f 2`
			else
				REAL_IF_DEV=`echo "$USB_INTERFACE_DEVICE" | grep $DEVICE_NAME_T` # MTK platform, BRCM platform
			fi
			TTY_NUMBER=`echo ${REAL_IF_DEV} | cut -c $((${#DEVICE_NAME_T} + 1)) - ${#REAL_IF_DEV}`
			CMD_IF=`grep $WP_CMD_INTERFACE_NAME $MATCH_WWAN_PACKAGE | tr -d '\r' | tr -d ' ' | cut -d ':' -f 2`
			REAL_CMD_IF_DEV=$DEVICE_NAME_T$(($TTY_NUMBER + $CMD_IF))
			echo "$REAL_CMD_IF_DEV" > $DEVICE_CMD_FILE
		fi
	fi

	echo "DRIVER_READY" > $DEVICE_STATUS_FILE
	wwan_log "[$0] search interface case done, exit"
	exit
fi

##################### other cases #####################
wwan_log "[$0] it is not a WWAN dongle, exit"
rm -rf $DEVICE_DIR
#exit
