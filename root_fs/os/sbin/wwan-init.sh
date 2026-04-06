#!/bin/sh

# Copyright (C) ZyXEL Communications, Corp. All Rights Reserved.

# $1: device number
# $2: VID
# $3: PID
# $4: reinit
# $5: config file

#set -x

# Environment Variables
#WWANPATH=/sbin  # set the WWAN directory path #~!@#$%^&*()_+

. $WWANPATH/wwan-lib.sh

echo "[$0] enter" > /dev/console

DEVICE_NUMBER=$1
VID=$2
PID=$3
REINIT=$4
if [ "$DEVICE_NUMBER" = "" -o "$VID" = "" -o "$PID" = "" ]; then
	wwan_log "[$0] DEVICE_NUMBER=$DEVICE_NUMBER, VID=$VID, PID=$PID; can't find DEVICE_NUMBER or VID or PID"
	exit
fi

DEVICE_ID=$DEVICE_NUMBER:$VID:$PID
DEVICE_DIR=$DATAPATH/$DEVICE_DATA_PRENAME:$DEVICE_ID
if [ ! -e "$DEVICE_DIR" ]; then
	wwan_log "[$0] can't find DEVICE_DIR $DEVICE_DIR, exit"
	exit
fi

if [ "$5" = "" ]; then
	CONFIG_FILE=$DEVICE_DIR/$DEVICE_CONFIG_NAME
else
	CONFIG_FILE=$5
fi

CMD_RESPONSE_NAME=cmd_tmp
DEVICE_STATUS_FILE=$DEVICE_DIR/$DEVICE_STATUS_NAME
DEVICE_INIT_FILE=$DEVICE_DIR/$DEVICE_INIT_NAME
DEVICE_TYPE_FILE=$DEVICE_DIR/$DEVICE_TYPE_NAME
DEVICE_DRIVER_FILE=$DEVICE_DIR/$DEVICE_DRIVER_NAME
DEVICE_DIAL_FILE=$DEVICE_DIR/$DEVICE_DIAL_IF_NAME
DEVICE_CMD_FILE=$DEVICE_DIR/$DEVICE_CMD_IF_NAME
DEVICE_PECULIAR_FILE=$DEVICE_DIR/$DEVICE_PECULIAR_NAME
CMD_RESPONSE_FILE=$DEVICE_DIR/$CMD_RESPONSE_NAME

DEVICE_STATUS=`cat $DEVICE_STATUS_FILE`
if [ "$DEVICE_STATUS" != "DRIVER_READY" ]; then
	wwan_log "[$0] DRIVER is not READY, init case interrupt, exit"
	exit
fi

echo "INIT_DEVICE" > $DEVICE_INIT_FILE

# check config file
if ! [ -e "$CONFIG_FILE" ]; then
	echo "WITHOUT_CONFIG" > $DEVICE_INIT_FILE
	wwan_log "[$0] can't find CONFIG_FILE $CONFIG_FILE, exit"
	exit
fi

# check cmd device
CMD_DEV_IF=`cat $DEVICE_CMD_FILE`

#check HWL mode
if [ -f "$WHL_FILE" ]; then
	wwan_log "[$0] HWL mode active!!!"
	hwl_case=ON
fi

# Keep PIN verification result
PIN_VERIFICATION_FILE=$DATAPATH/$PIN_VERIFICATION_NAME

#-------------------------------------------------------------------------------
# function : reset
#
# $1 : Command interface device
#
at_reset() {
	retry=3

	for i in `seq 1 $retry`; do
		if chat -V -s TIMEOUT 1 "" "ATZ" "OK" "" < $1 > $1; then
			echo "ATZ_OK" > $DEVICE_INIT_FILE
			wwan_log "[$0] ATZ OK"
			break
		else
			echo "ATZ_FAIL" > $DEVICE_INIT_FILE
			wwan_log "[$0] ATZ FAIL, retry: $i"
#			sleep 1
		fi
	done
}

#-------------------------------------------------------------------------------
# function : check PIN code
#
# $1 : Command interface device
#
at_check_pin_code() {
	retry=7

	for i in `seq 1 $retry`; do
		chat -V -s TIMEOUT 1 "" "AT+CPIN?" "OK" "" < $1 > $1 2> $CMD_RESPONSE_FILE

		if grep "READY" $CMD_RESPONSE_FILE; then
			echo "CPIN_READY" > $DEVICE_INIT_FILE
			wwan_log "[$0] AT+CPIN? READY"
			echo "PIN_Verification_Pass" > $PIN_VERIFICATION_FILE
			break
		elif grep "SIM PIN" $CMD_RESPONSE_FILE; then
			echo "NEED_PIN_CODE" > $DEVICE_INIT_FILE
			wwan_log "[$0] AT+CPIN? SIM PIN"
			# to do unlock SIM PIN
			break
		elif grep "SIM PUK" $CMD_RESPONSE_FILE; then
			echo "NEED_PUK_CODE" > $DEVICE_INIT_FILE
			wwan_log "[$0] AT+CPIN? SIM PUK"
			# to do unlock SIM PUK
			break
		elif grep "SIM failure" $CMD_RESPONSE_FILE; then
			echo "SIM_FAILURE" > $DEVICE_INIT_FILE
			wwan_log "[$0] AT+CPIN? SIM failure"
			break
		elif grep "busy" $CMD_RESPONSE_FILE; then
			echo "SIM_BUSY" > $DEVICE_INIT_FILE
			wwan_log "[$0] AT+CPIN? SIM BUSY, retry: $i"
			sleep 4
		else
			echo "CPIN_FAIL" > $DEVICE_INIT_FILE
			wwan_log "[$0] AT+CPIN? FAIL, retry: $i"
#			sleep 1
		fi
	done
}

#-------------------------------------------------------------------------------
# Function : unlock PUK code and PIN code
#
# $1 : Command interface device
#
at_unlock_puk_and_pin_code() {
	INIT_STATUS=`cat $DEVICE_INIT_FILE`

	if [ "$INIT_STATUS" = "NEED_PUK_CODE" ]; then
		CONFIG_PUK_CODE=`grep $CONFIG_PUK_NAME $CONFIG_FILE | tr -d '\r' | tr -d ' ' | cut -d ':' -f 2`
		CONFIG_NEW_PIN_CODE=`grep $CONFIG_NEWPIN_NAME $CONFIG_FILE | tr -d '\r' | tr -d ' ' | cut -d ':' -f 2`
		if [ "$CONFIG_PUK_CODE" == "" -o "$CONFIG_NEW_PIN_CODE" == "" ]; then
			echo "WITHOUT_PUK_PIN" > $DEVICE_INIT_FILE
			wwan_log "[$0] can't find PUK code or PIN code, exit"
			exit
		fi
		RECHECK_CPIN=ON
		if chat -V -s TIMEOUT 1 "" "AT+CPIN=\"$CONFIG_PUK_CODE\", \"$CONFIG_NEW_PIN_CODE\"" "OK" "" < $1 > $1; then
			echo "ENTER_PUK_OK" > $DEVICE_INIT_FILE
			wwan_log "[$0] enter PUK OK"
		else
			echo "ENTER_PUK_FAIL" > $DEVICE_INIT_FILE
			wwan_log "[$0] enter PUK FAIL"
		fi
	elif [ "$INIT_STATUS" = "NEED_PIN_CODE" ]; then
		CONFIG_PIN_CODE=`grep $CONFIG_PIN_NAME $CONFIG_FILE | tr -d '\r' | tr -d ' ' | cut -d ':' -f 2`
		if [ "$CONFIG_PIN_CODE" == "" ]; then
			echo "WITHOUT_PIN" > $DEVICE_INIT_FILE
			wwan_log "[$0] can't find PIN code, exit"
			exit
		fi
		RECHECK_CPIN=ON
		if chat -V -s TIMEOUT 1 "" "AT+CPIN=\"$CONFIG_PIN_CODE\"" "OK" "" < $1 > $1; then
			echo "ENTER_PIN_OK" > $DEVICE_INIT_FILE
			wwan_log "[$0] enter PIN OK"
		else
			echo "ENTER_PIN_FAIL" > $DEVICE_INIT_FILE
			wwan_log "[$0] enter PIN FAIL"
			echo "PIN_Verification_Failure" > $PIN_VERIFICATION_FILE
		fi
	fi
}

#-------------------------------------------------------------------------------
# function : check network status
#
#
# $1 : Command interface device
#
at_check_network_status() {
	retry=6
	sleep 3

	for i in `seq 1 $retry`; do
		CREG_STATUS=""
		chat -V -s TIMEOUT 1 "" "AT+CREG?" "OK" "" < $1 > $1 2> $CMD_RESPONSE_FILE
		if grep ",1" $CMD_RESPONSE_FILE; then
			CREG_STATUS=1
			wwan_log "[$0] AT+CREG? ,1"
		elif grep ",5" $CMD_RESPONSE_FILE; then
			CREG_STATUS=5
			wwan_log "[$0] AT+CREG? ,5"
		elif grep "SIM failure" $CMD_RESPONSE_FILE; then
			CREG_STATUS=-1
			wwan_log "[$0] AT+CREG? SIM failure"
		elif grep "COMMAND NOT SUPPORT" $CMD_RESPONSE_FILE; then
			CREG_STATUS=-1
			wwan_log "[$0] AT+CREG? COMMAND NOT SUPPORT"
		elif grep "ERROR" $CMD_RESPONSE_FILE; then
			CREG_STATUS=-1
			wwan_log "[$0] AT+CREG? ERROR"
		fi
		
		wwan_log "[$0] CREG_STATUS is $CREG_STATUS"

		if [ "$CREG_STATUS" = "1" ]; then
			echo "CREG_READY" > $DEVICE_INIT_FILE
			wwan_log "[$0] AT+CREG? registered"
			break
		elif [ "$CREG_STATUS" = "5" ]; then
			echo "CREG_READY_ROAMING" > $DEVICE_INIT_FILE
			wwan_log "[$0] AT+CREG? registered (roaming)"
			break
		fi

		
		CGREG_STATUS=""
		chat -V -s TIMEOUT 1 "" "AT+CGREG?" "OK" "" < $1 > $1 2> $CMD_RESPONSE_FILE
		if grep ",1" $CMD_RESPONSE_FILE; then
			CGREG_STATUS=1
			wwan_log "[$0] AT+CGREG? ,1"
		elif grep ",5" $CMD_RESPONSE_FILE; then
			CGREG_STATUS=5
			wwan_log "[$0] AT+CGREG? ,5"
		elif grep "SIM failure" $CMD_RESPONSE_FILE; then
			CGREG_STATUS=-1
			wwan_log "[$0] AT+CGREG? SIM failure"
		elif grep "COMMAND NOT SUPPORT" $CMD_RESPONSE_FILE; then
			CGREG_STATUS=-1
			wwan_log "[$0] AT+CGREG? COMMAND NOT SUPPORT"
		elif grep "ERROR" $CMD_RESPONSE_FILE; then
			CGREG_STATUS=-1
			wwan_log "[$0] AT+CGREG? ERROR"
		fi
		
		wwan_log "[$0] CGREG_STATUS is $CGREG_STATUS"
		
		if [ "$CGREG_STATUS" = "1" ]; then
			echo "CREG_READY" > $DEVICE_INIT_FILE
			wwan_log "[$0] AT+CGREG? registered"
			break
		elif [ "$CGREG_STATUS" = "5" ]; then
			echo "CREG_READY_ROAMING" > $DEVICE_INIT_FILE
			wwan_log "[$0] AT+CGREG? registered (roaming)"
			break
		fi
		

		CEREG_STATUS=""
		chat -V -s TIMEOUT 1 "" "AT+CEREG?" "OK" "" < $1 > $1 2> $CMD_RESPONSE_FILE
		if grep ",1" $CMD_RESPONSE_FILE; then
			CEREG_STATUS=1
			wwan_log "[$0] AT+CEREG? ,1"
		elif grep ",5" $CMD_RESPONSE_FILE; then
			CEREG_STATUS=5
			wwan_log "[$0] AT+CEREG? ,5"
		elif grep "SIM failure" $CMD_RESPONSE_FILE; then
			CEREG_STATUS=-1
			wwan_log "[$0] AT+CEREG? SIM failure"
		elif grep "COMMAND NOT SUPPORT" $CMD_RESPONSE_FILE; then
			CEREG_STATUS=-1
			wwan_log "[$0] AT+CEREG? COMMAND NOT SUPPORT"
		elif grep "ERROR" $CMD_RESPONSE_FILE; then
			CEREG_STATUS=-1
			wwan_log "[$0] AT+CEREG? ERROR"
		fi

		wwan_log "[$0] CEREG_STATUS is $CEREG_STATUS"
		
		if [ "$CEREG_STATUS" = "1" ]; then
			echo "CREG_READY" > $DEVICE_INIT_FILE
			wwan_log "[$0] AT+CEREG? registered"
			break
		elif [ "$CEREG_STATUS" = "5" ]; then
			echo "CREG_READY_ROAMING" > $DEVICE_INIT_FILE
			wwan_log "[$0] AT+CEREG? registered (roaming)"
			break
		elif [ "$CREG_STATUS" = "-1" -a "$CGREG_STATUS" = "-1" -a "$CEREG_STATUS" = "-1" ]; then
			echo "CREG_FAIL" > $DEVICE_INIT_FILE
			wwan_log "[$0] AT+CREG? FAIL, break"
			break
		else
			echo "CREG_UNKNOWN" > $DEVICE_INIT_FILE
			wwan_log "[$0] AT+CEREG? unregistered"
			sleep 5
		fi
	done
}

#-------------------------------------------------------------------------------
DEVICE_TYPE=`cat $DEVICE_TYPE_FILE`
if [ "$DEVICE_TYPE" = "tty" ]; then
	enable_ppp_chat=1

	if [ "$CMD_DEV_IF" = "" ]; then
		echo "WITHOUT_CMD_DEV_IF" > $DEVICE_INIT_FILE
		wwan_log "[$0] can't find CMD_DEV_IF $CMD_DEV_IF, exit"
		exit
	fi
	CMD_IF_DEV=$DEVICEPATH/$CMD_DEV_IF

	# reset
	at_reset $CMD_IF_DEV
	
	# HUAWEI must disable CURC
	retry=2
	if [ "$VID" = "12d1" ]; then
		for i in `seq 1 $retry`; do
			if chat -V -s TIMEOUT 1 "" "AT\^CURC=0" "OK" "" < $CMD_IF_DEV > $CMD_IF_DEV; then
				echo "CURC_OK" > $DEVICE_INIT_FILE
				wwan_log "[$0] AT^CURC=0 OK"
				break
			else
				echo "CURC_FAIL" > $DEVICE_INIT_FILE
				wwan_log "[$0] AT^CURC=0 FAIL, retry: $i"
#				sleep 1
			fi
		done
		sleep 1
		# This command disable function of STK, becuase E367u-2 + Telkom SIM always make issue on connection
		for i in `seq 1 $retry`; do
			if chat -V -s TIMEOUT 1 "" "AT\^STSF=0" "OK" "" < $CMD_IF_DEV > $CMD_IF_DEV; then
				echo "STSF_OK" > $DEVICE_INIT_FILE
				wwan_log "[$0] AT^STSF=0 OK"
				break
			else
				echo "STSF_FAIL" > $DEVICE_INIT_FILE
				wwan_log "[$0] AT^STSF=0 FAIL, retry: $i"
#				sleep 1
		fi
		done
	fi

	# set CFUN
	retry=3
	for i in `seq 1 $retry`; do
		if chat -V -s TIMEOUT 1 "" "AT+CFUN=1" "OK" "" < $CMD_IF_DEV > $CMD_IF_DEV; then
			echo "CFUN_OK" > $DEVICE_INIT_FILE
			if [ "$hwl_case" = "ON" ]; then
				wwan_log "[$0] AT+CFUN=1 OK, waiting for dongle init..."
				sleep 10
			else
				wwan_log "[$0] AT+CFUN=1 OK"
			fi
			break
		else
			echo "CFUN_FAIL" > $DEVICE_INIT_FILE
			wwan_log "[$0] AT+CFUN=1 FAIL, retry: $i"
#			sleep 1
		fi
	done
	
	if [ "$hwl_case" = "ON" ]; then
		if [ "$VID" = "0586" -a "$PID" = "3440" -o "$VID" = "2001" -a "$PID" = "7d01" -o "$VID" = "2001" -a "$PID" = "7d02" ]; then
			retry=3
			change_mode=OFF
			for i in `seq 1 $retry`; do
				if chat -V -s TIMEOUT 1 "" "AT+ERAT?" "OK" "" < $CMD_IF_DEV > $CMD_IF_DEV 2> $CMD_RESPONSE_FILE; then
					ERAT3=`grep "," $CMD_RESPONSE_FILE | cut -d ',' -f 3`
					ERAT4=`grep "," $CMD_RESPONSE_FILE | cut -d ',' -f 4`
					wwan_log "[$0] ERAT is $ERAT3,$ERAT4"
					if [ "$ERAT3" = "1" ]; then
						if [ "$ERAT4" = "2" ]; then
							wwan_log "[$0] to the right mode"
							change_mode=ON
						fi
						break
					elif [ "$ERAT3" = "0" ]; then
						wwan_log "[$0] to the right mode"
						change_mode=ON
						break
					elif [ "$ERAT3" = "2" ]; then
						wwan_log "[$0] to the right mode"
						change_mode=ON
						break
					fi
				fi
			done
		
			if [ "$change_mode" = "ON" ]; then
				sleep 1
				for i in `seq 1 $retry`; do
					if chat -V -s TIMEOUT 1 "" "AT+ERAT=1,0" "OK" "" < $CMD_IF_DEV > $CMD_IF_DEV; then
						echo "ERAT_OK" > $DEVICE_INIT_FILE
						wwan_log "[$0] AT+ERAT=1,0 OK"
						sleep 10
						break
					else
						echo "ERAT_FAIL" > $DEVICE_INIT_FILE
						wwan_log "[$0] AT+ERAT=1,0 FAIL, retry: $i"
						sleep 1
					fi
				done
			fi
		fi
	fi

	# check PIN code
	at_check_pin_code $CMD_IF_DEV

	# unlock PUK code and PIN code
	RECHECK_CPIN=OFF

	at_unlock_puk_and_pin_code $CMD_IF_DEV

	# recheck PIN code
	if [ "$RECHECK_CPIN" = "ON" ]; then

		at_check_pin_code $CMD_IF_DEV

	fi

	INIT_STATUS=`cat $DEVICE_INIT_FILE`
	if [ "$INIT_STATUS" != "CPIN_READY" -a "$INIT_STATUS" != "CPIN_FAIL" ]; then
		wwan_log "[$0] CPIN ISSUE, init case interrupt, exit"
		exit
	fi

	# check network status
	at_check_network_status $CMD_IF_DEV

	INIT_STATUS=`cat $DEVICE_INIT_FILE`
	if [ "$INIT_STATUS" = "CREG_UNKNOWN" -o "$INIT_STATUS" = "CREG_DENIED" ]; then
		wwan_log "[$0] CREG ISSUE, init case interrupt, exit"
		exit
	fi

	if [ "$enable_ppp_chat" = "1" ]; then
		# set CHAT config
		PPP_CHAT_FILE=$DEVICE_DIR/$DEVICE_PPP_CHAT_NAME
		CONFIG_DIAL=`grep $CONFIG_DIAL_NAME $CONFIG_FILE | tr -d '\r' | tr -d ' ' | cut -d ':' -f 2`
		if [ "$CONFIG_DIAL" = "" ]; then
			CONFIG_DIAL=*99#
		fi
		CONFIG_APN=`grep $CONFIG_APN_NAME $CONFIG_FILE | tr -d '\r' | tr -d ' ' | cut -d ':' -f 2`

		echo -e "\"\" ATZ" > $PPP_CHAT_FILE
#		echo "OK ATQ0V1E1&C1&D2S0=0+FCLASS=0" >> $PPP_CHAT_FILE
		if [ "$CONFIG_APN" != "" ]; then
			echo -e "OK AT+CGDCONT=1,\"IP\",\"$CONFIG_APN\"" >> $PPP_CHAT_FILE
		fi
		echo "OK ATDT$CONFIG_DIAL" >> $PPP_CHAT_FILE
		echo -e "CONNECT \"\"" >> $PPP_CHAT_FILE

		# set PPP config
		PPP_3G_FILE=$DEVICE_DIR/$DEVICE_PPP_3G_NAME
		CONFIG_NAILEDUP=`grep $CONFIG_NAILEDUP_NAME $CONFIG_FILE | tr -d '\r' | tr -d ' ' | cut -d ':' -f 2`
		CONFIG_ONDEMAND=`grep $CONFIG_ONDEMAND_NAME $CONFIG_FILE | tr -d '\r' | tr -d ' ' | cut -d ':' -f 2`
		CONFIG_USERNAME=`grep $CONFIG_USERNAME_NAME $CONFIG_FILE | tr -d '\r' | tr -d ' ' | cut -d ':' -f 2`
		CONFIG_PASSWORD=`grep $CONFIG_PASSWORD_NAME $CONFIG_FILE | tr -d '\r' | tr -d ' ' | cut -d ':' -f 2`
		CONFIG_PPPIFNAME=`grep $CONFIG_PPPIFNAME_NAME $CONFIG_FILE | tr -d '\r' | tr -d ' ' | cut -d ':' -f 2`

		DIAL_TTY_DEV_NAME=`cat $DEVICE_DIAL_FILE`
		if [ "$DIAL_TTY_DEV_NAME" = "" ]; then
			echo "WITHOUT_DIAL_TTY_DEVICE" > $DEVICE_INIT_FILE
			wwan_log "[$0] can't find DIAL_TTY_DEVICE $DIAL_TTY_DEV_NAME, exit"
			exit
		fi
		DIAL_TTY_DEV=$DEVICEPATH/$DIAL_TTY_DEV_NAME

		echo "$DIAL_TTY_DEV" > $PPP_3G_FILE
#		echo "9600" > $PPP_3G_FILE
		echo "modem" >> $PPP_3G_FILE
		echo "nodetach" >> $PPP_3G_FILE
#		echo "noccp" >> $PPP_3G_FILE
#		echo "novj" >> $PPP_3G_FILE
#		echo "novjccomp" >> $PPP_3G_FILE
		#echo "noauth" >> $PPP_3G_FILE
		#echo "noipdefault" >> $PPP_3G_FILE
		#echo "defaultroute" >> $PPP_3G_FILE
#		echo "passive" >> $PPP_3G_FILE
		#echo "usepeerdns" >> $PPP_3G_FILE
		#echo "crtscts" >> $PPP_3G_FILE
		#echo "lock" >> $PPP_3G_FILE
		#echo "debug" >> $PPP_3G_FILE
		#echo "maxfail 10" >> $PPP_3G_FILE
#		echo "ipcp-accept-local" >> $PPP_3G_FILE
#		echo "ipcp-accept-remote" >> $PPP_3G_FILE
		if [ "$CONFIG_NAILEDUP" != "1" ]; then
			echo "demand" >> $PPP_3G_FILE
			echo "idle $CONFIG_ONDEMAND" >> $PPP_3G_FILE
#		else
#			echo "persist" >> $PPP_3G_FILE
		fi
		echo "holdoff 0" >> $PPP_3G_FILE
		if [ "$CONFIG_USERNAME" != "" ]; then
			echo "user $CONFIG_USERNAME" >> $PPP_3G_FILE
			echo "password $CONFIG_PASSWORD" >> $PPP_3G_FILE
		fi
		# [start] this option is VMG5313 only
		#echo "linkname pppd2" >> $PPP_3G_FILE
		if [ "$CONFIG_PPPIFNAME" != "" ]; then
			echo "pppname $CONFIG_PPPIFNAME" >> $PPP_3G_FILE
		else
			echo "pppname pppowwan0" >> $PPP_3G_FILE
		fi
		# [end] this option is VMG5313 only
		echo -e "connect \"chat -v -f $PPP_CHAT_FILE\"" >> $PPP_3G_FILE
	fi
elif [ "$DEVICE_TYPE" = "net" ]; then

	# check dial 
#	DIAL_DEV_IF=`cat $DEVICE_DIAL_FILE`
#	if [ "$DIAL_DEV_IF" = "" ]; then
#		echo "WITHOUT_DIAL_DEV_IF" > $DEVICE_INIT_FILE
#		wwan_log "[$0] can't find DIAL_DEV_IF $DIAL_DEV_IF, exit"
#		exit
#	fi

#-------------------------------------------------------------------------------
	if [ "$REINIT" = "reinit" ]; then

		if [ "$CMD_DEV_IF" = "" ]; then
			echo "WITHOUT_CMD_DEV_IF" > $DEVICE_INIT_FILE
			wwan_log "[$0] can't find CMD_DEV_IF $CMD_DEV_IF, exit"
			exit
		fi
		CMD_IF_DEV=$DEVICEPATH/$CMD_DEV_IF

		DEVICE_DRIVER=`cat $DEVICE_DRIVER_FILE`
		if [ "$DEVICE_DRIVER" = "qmi-wwan" ]; then
			zqmictl $CMD_IF_DEV --wds-stop-network
		elif [ "$DEVICE_DRIVER" = "cdc-ncm usbserial" ]; then
			chat -V -s TIMEOUT 1 "" "AT\^NDISDUP=1,0" "\^NDISSTAT" "" < $CMD_IF_DEV > $CMD_IF_DEV
		elif [ "$DEVICE_DRIVER" = "gobinet usbserial" ]; then
			chat -V -s TIMEOUT 1 "" "AT\$qcrmcall=0,1" "OK" "" < $CMD_IF_DEV > $CMD_IF_DEV
		elif [ "$DEVICE_DRIVER" = "rmnet" ]; then
			wwan_log "[$0] reinit rmnet device"
			exit
		elif [ "$DEVICE_DRIVER" = "cdc-ecm usbserial" ]; then
			wwan_log "[$0] reinit cdc-ecm usbserial device"
			exit
		fi
	fi

#-------------------------------------------------------------------------------
	DEVICE_DRIVER=`cat $DEVICE_DRIVER_FILE`
	if [ "$DEVICE_DRIVER" = "qmi-wwan" ]; then

		if [ "$CMD_DEV_IF" = "" ]; then
			echo "WITHOUT_CMD_DEV_IF" > $DEVICE_INIT_FILE
			wwan_log "[$0] can't find CMD_DEV_IF $CMD_DEV_IF, exit"
			exit
		fi
		CMD_IF_DEV=$DEVICEPATH/$CMD_DEV_IF

		#check PIN code
		retry=3
		for i in `seq 1 $retry`; do
#			qmicli -d $CMD_IF_DEV --dms-uim-get-pin-status | grep -E "PIN1" -A 3 > $CMD_RESPONSE_FILE
			zqmictl $CMD_IF_DEV --dms-uim-get-pin-status | grep -E "PIN1" -A 3 > $CMD_RESPONSE_FILE
			if grep -E "disabled|enabled-verified" $CMD_RESPONSE_FILE; then
				echo "CPIN_READY" > $DEVICE_INIT_FILE
				wwan_log "[$0] get-pin-status READY"
				break
			elif grep "enabled-not-verified" $CMD_RESPONSE_FILE; then
				echo "NEED_PIN_CODE" > $DEVICE_INIT_FILE
				wwan_log "[$0] get-pin-status NEED PIN"
				#to do unlock SIM PIN
				break
			else
				echo "CPIN_FAIL" > $DEVICE_INIT_FILE
				wwan_log "[$0] get-pin-status FAIL, retry: $i"
#				sleep 1
			fi
		done

		# unlock PIN code
		RECHECK_CPIN=OFF
		INIT_STATUS=`cat $DEVICE_INIT_FILE`
		if [ "$INIT_STATUS" = "NEED_PIN_CODE" ]; then
			CONFIG_PIN_CODE=`grep $CONFIG_PIN_NAME $CONFIG_FILE | tr -d '\r' | tr -d ' ' | cut -d ':' -f 2`
			if [ "$CONFIG_PIN_CODE" == "" ]; then
				echo "WITHOUT_PIN" > $DEVICE_INIT_FILE
				wwan_log "[$0] can't find PIN code, exit"
				exit
			fi
			RECHECK_CPIN=ON
#			qmicli -d $CMD_IF_DEV --dms-uim-verify-pin=PIN,$CONFIG_PIN_CODE > $CMD_RESPONSE_FILE
			zqmictl $CMD_IF_DEV --dms-uim-verify-pin=PIN,$CONFIG_PIN_CODE > $CMD_RESPONSE_FILE
			if grep "PIN verified successfully" $CMD_RESPONSE_FILE; then
				echo "ENTER_PIN_OK" > $DEVICE_INIT_FILE
				wwan_log "[$0] enter PIN OK"
			else
				echo "ENTER_PIN_FAIL" > $DEVICE_INIT_FILE
				wwan_log "[$0] enter PIN FAIL"
			fi
		fi

		# recheck PIN code
		if [ "$RECHECK_CPIN" = "ON" ]; then
			retry=3
			for i in `seq 1 $retry`; do
#				qmicli -d $CMD_IF_DEV --dms-uim-get-pin-status | grep PIN1 -A 3 > $CMD_RESPONSE_FILE
				zqmictl $CMD_IF_DEV --dms-uim-get-pin-status | grep PIN1 -A 3 > $CMD_RESPONSE_FILE
				if grep -E "disabled|enabled-verified" $CMD_RESPONSE_FILE; then
					echo "CPIN_READY" > $DEVICE_INIT_FILE
					wwan_log "[$0] get-pin-status READY"
					break
				elif grep "enabled-not-verified" $CMD_RESPONSE_FILE; then
					echo "NEED_PIN_CODE" > $DEVICE_INIT_FILE
					wwan_log "[$0] get-pin-status NEED PIN"
					#to do unlock SIM PIN
					break
				else
					echo "CPIN_FAIL" > $DEVICE_INIT_FILE
					wwan_log "[$0] get-pin-status FAIL, retry: $i"
#					sleep 1
				fi
			done
		fi

		INIT_STATUS=`cat $DEVICE_INIT_FILE`
		if [ "$INIT_STATUS" != "CPIN_READY" ]; then
			wwan_log "[$0] get-pin-status ISSUE, init case interrupt, exit"
#			exit
		fi

		# check network status
		retry=10
		for i in `seq 1 $retry`; do
#			qmicli -d $CMD_IF_DEV --nas-get-serving-system > $CMD_RESPONSE_FILE
			zqmictl $CMD_IF_DEV --nas-get-serving-system > $CMD_RESPONSE_FILE
			if grep "'registered'" $CMD_RESPONSE_FILE; then
				echo "CREG_READY" > $DEVICE_INIT_FILE
				wwan_log "[$0] AT+CREG? registered"
				break
			else
				echo "CREG_FAIL" > $DEVICE_INIT_FILE
				wwan_log "[$0] AT+CREG? FAIL, retry: $i"
#				break
				sleep 2
			fi
		done

		INIT_STATUS=`cat $DEVICE_INIT_FILE`
		if [ "$INIT_STATUS" != "CREG_READY" ]; then
			wwan_log "[$0] get-serving-system ISSUE, init case interrupt, exit"
#			exit
		fi

		# connect dongle's wan side
		CONFIG_APN=`grep $CONFIG_APN_NAME $CONFIG_FILE | tr -d '\r' | tr -d ' ' | cut -d ':' -f 2`
		if [ "$CONFIG_APN" = "" ]; then
			echo "WITHOUT_APN" > $DEVICE_INIT_FILE
			wwan_log "[$0] can't find APN $CONFIG_FILE, exit"
			exit
		fi
		CONFIG_USERNAME=`grep $CONFIG_USERNAME_NAME $CONFIG_FILE | tr -d '\r' | tr -d ' ' | cut -d ':' -f 2`
		CONFIG_PASSWORD=`grep $CONFIG_PASSWORD_NAME $CONFIG_FILE | tr -d '\r' | tr -d ' ' | cut -d ':' -f 2`
		if [ "$CONFIG_USERNAME" != "" -a "$CONFIG_PASSWORD" != "" ]; then
			UN_PW=",BOTH,$CONFIG_USERNAME,$CONFIG_PASSWORD"
		fi
#		qmicli -d $CMD_IF_DEV --wds-start-network=$CONFIG_APN$UN_PW --client-no-release-cid
		wwan_log "[$0] zqmictl $CMD_IF_DEV --wds-start-network=$CONFIG_APN$UN_PW"
		zqmictl $CMD_IF_DEV --wds-start-network=$CONFIG_APN$UN_PW
		sleep 2
#-------------------------------------------------------------------------------
	elif [ "$DEVICE_DRIVER" = "qmi-wwan usbserial" ]; then  #qmi-wwan usbserial
		quectel-CM &
#-------------------------------------------------------------------------------
	elif [ "$DEVICE_DRIVER" = "cdc-ncm usbserial" ]; then

		if [ "$CMD_DEV_IF" = "" ]; then
			echo "WITHOUT_CMD_DEV_IF" > $DEVICE_INIT_FILE
			wwan_log "[$0] can't find CMD_DEV_IF $CMD_DEV_IF, exit"
			exit
		fi
		CMD_IF_DEV=$DEVICEPATH/$CMD_DEV_IF

		# reset
		at_reset $CMD_IF_DEV

		# HUAWEI must disable CURC
		retry=2
		if [ "$VID" = "12d1" ]; then
			for i in `seq 1 $retry`; do
				if chat -V -s TIMEOUT 1 "" "AT\^CURC=0" "OK" "" < $CMD_IF_DEV > $CMD_IF_DEV; then
					echo "CURC_OK" > $DEVICE_INIT_FILE
					wwan_log "[$0] AT^CURC=0 OK"
					break
				else
					echo "CURC_FAIL" > $DEVICE_INIT_FILE
					wwan_log "[$0] AT^CURC=0 FAIL, retry: $i"
#					sleep 1
				fi
			done
			sleep 1
			# This command disable function of STK, becuase E367u-2 + Telkom SIM always make issue on connection
#			for i in `seq 1 $retry`; do
#				if chat -V -s TIMEOUT 1 "" "AT\^STSF=0" "OK" "" < $CMD_IF_DEV > $CMD_IF_DEV; then
#					echo "STSF_OK" > $DEVICE_INIT_FILE
#					wwan_log "[$0] AT^STSF=0 OK"
#					break
#				else
#					echo "STSF_FAIL" > $DEVICE_INIT_FILE
#					wwan_log "[$0] AT^STSF=0 FAIL, retry: $i"
#					sleep 1
#			fi
#			done
		fi

		# set CFUN
		retry=3
		for i in `seq 1 $retry`; do
			if chat -V -s TIMEOUT 1 "" "AT+CFUN=1" "OK" "" < $CMD_IF_DEV > $CMD_IF_DEV; then
				echo "CFUN_OK" > $DEVICE_INIT_FILE
				wwan_log "[$0] AT+CFUN=1 OK"
				break
			else
				echo "CFUN_FAIL" > $DEVICE_INIT_FILE
				wwan_log "[$0] AT+CFUN=1 FAIL, retry: $i"
#				sleep 1
			fi
		done

		# check PIN code
		at_check_pin_code $CMD_IF_DEV

		# unlock PUK code and PIN code
		RECHECK_CPIN=OFF

		at_unlock_puk_and_pin_code $CMD_IF_DEV

		# recheck PIN code
		if [ "$RECHECK_CPIN" = "ON" ]; then

			at_check_pin_code $CMD_IF_DEV

		fi

		INIT_STATUS=`cat $DEVICE_INIT_FILE`
		if [ "$INIT_STATUS" != "CPIN_READY" -a "$INIT_STATUS" != "CPIN_FAIL" ]; then
			wwan_log "[$0] CPIN ISSUE, init case interrupt, exit"
			exit
		fi

		# check network status
		at_check_network_status $CMD_IF_DEV

		INIT_STATUS=`cat $DEVICE_INIT_FILE`
		if [ "$INIT_STATUS" = "CREG_UNKNOWN" -o "$INIT_STATUS" = "CREG_DENIED" ]; then
			wwan_log "[$0] CREG ISSUE, init case interrupt, exit"
			exit
		fi

		CONFIG_APN=`grep $CONFIG_APN_NAME $CONFIG_FILE | tr -d '\r' | tr -d ' ' | cut -d ':' -f 2`
		if [ "$CONFIG_APN" = "" ]; then
			echo "WITHOUT_APN" > $DEVICE_INIT_FILE
			wwan_log "[$0] can't find APN $CONFIG_FILE, exit"
			exit
		fi

		CONFIG_USERNAME=`grep $CONFIG_USERNAME_NAME $CONFIG_FILE | tr -d '\r' | tr -d ' ' | cut -d ':' -f 2`
		CONFIG_PASSWORD=`grep $CONFIG_PASSWORD_NAME $CONFIG_FILE | tr -d '\r' | tr -d ' ' | cut -d ':' -f 2`

		if [ "$CONFIG_USERNAME" != "" -a "$CONFIG_PASSWORD" != "" ]; then
			UN_PW=",\"$CONFIG_USERNAME\",\"$CONFIG_PASSWORD\""
		fi

		CMD_IF_DEV=$DEVICEPATH/ttyUSB1

		wwan_log "[$0] chat -V -s TIMEOUT 1 "" "AT\^NDISDUP=1,1,\"$CONFIG_APN\"$UN_PW" "\^NDISSTAT" "" < $CMD_IF_DEV > $CMD_IF_DEV"
		chat -V -s TIMEOUT 1 "" "AT\^NDISDUP=1,1,\"$CONFIG_APN\"$UN_PW" "\^NDISSTAT" "" < $CMD_IF_DEV > $CMD_IF_DEV

		sleep 2
#-------------------------------------------------------------------------------
	elif [ "$DEVICE_DRIVER" = "gobinet usbserial" ]; then

		wwan_log "[$0] !!!!!!!!!!GobiNet driver cmd start!!!!!!!!!"

		if [ "$CMD_DEV_IF" = "" ]; then
			echo "WITHOUT_CMD_DEV_IF" > $DEVICE_INIT_FILE
			wwan_log "[$0] can't find CMD_DEV_IF $CMD_DEV_IF, exit"
			exit
		fi
		CMD_IF_DEV=$DEVICEPATH/$CMD_DEV_IF

		# reset
		at_reset $CMD_IF_DEV

		# check PIN code
		at_check_pin_code $CMD_IF_DEV

		# unlock PUK code and PIN code
		RECHECK_CPIN=OFF

		at_unlock_puk_and_pin_code $CMD_IF_DEV

		# recheck PIN code
		if [ "$RECHECK_CPIN" = "ON" ]; then

			at_check_pin_code $CMD_IF_DEV

		fi

		INIT_STATUS=`cat $DEVICE_INIT_FILE`
		if [ "$INIT_STATUS" != "CPIN_READY" -a "$INIT_STATUS" != "CPIN_FAIL" ]; then
			wwan_log "[$0] CPIN ISSUE, init case interrupt, exit"
			exit
		fi

		# check network status
		at_check_network_status $CMD_IF_DEV

		INIT_STATUS=`cat $DEVICE_INIT_FILE`
		if [ "$INIT_STATUS" = "CREG_READY" -o "$INIT_STATUS" = "CREG_READY_ROAMING" ]; then
			chat -V -s TIMEOUT 1 "" "AT\$qcrmcall=1,1" "OK" "" < $CMD_IF_DEV > $CMD_IF_DEV 2> $CMD_RESPONSE_FILE
			wwan_log "[$0] AT$qcrmcall=1,1 setup PDP $CMD_RESPONSE_FILE"
		elif [ "$INIT_STATUS" = "CREG_UNKNOWN" -o "$INIT_STATUS" = "CREG_DENIED" ]; then
			wwan_log "[$0] CREG ISSUE, init case interrupt, exit"
			exit
		fi
#-------------------------------------------------------------------------------
	elif [ "$DEVICE_DRIVER" = "rmnet" ]; then

		# check MALM, SIM card and PIN code
		wwan_log "[$0] check MALM, SIM card and PIN code"
		retry=3
		for i in `seq 1 $retry`; do
			JsonClient /tmp/cgi-2-sys get_wwan_pin_status > $CMD_RESPONSE_FILE
			if grep "\"card_status\": 1" $CMD_RESPONSE_FILE; then
				#echo "SIM_READY" > $DEVICE_INIT_FILE
				#wwan_log "[$0] get_wwan_pin_status READY"
				if grep "\"status\": 2" $CMD_RESPONSE_FILE; then
					echo "CPIN_READY" > $DEVICE_INIT_FILE
					wwan_log "[$0] get_wwan_pin_status READY"
					break
				elif grep "\"status\": 3" $CMD_RESPONSE_FILE; then
					echo "CPIN_READY" > $DEVICE_INIT_FILE
					wwan_log "[$0] get_wwan_pin_status READY"
					break
				elif grep "\"status\": 1" $CMD_RESPONSE_FILE; then
					echo "NEED_PIN_CODE" > $DEVICE_INIT_FILE
					wwan_log "[$0] get_wwan_pin_status NEED PIN"
					break
				else
					echo "CPIN_FAIL" > $DEVICE_INIT_FILE
					wwan_log "[$0] get_wwan_pin_status FAIL, retry: $i"
					sleep 1
				fi
			elif grep -v "\"errno\": 0" $CMD_RESPONSE_FILE | grep "\"errno\":"; then
				wwan_log "[$0] malm is not ready, retry: $i"
				sleep 10
			else
				echo "WITHOUT_SIM" > $DEVICE_INIT_FILE
				wwan_log "[$0] get_wwan_pin_status FAIL, retry: $i"
#				break
				sleep 2
			fi
		done

		# unlock PIN code
		RECHECK_CPIN=OFF
		INIT_STATUS=`cat $DEVICE_INIT_FILE`
		if [ "$INIT_STATUS" = "NEED_PIN_CODE" ]; then
			wwan_log "[$0] do unlock PIN code"
			CONFIG_PIN_CODE=`grep $CONFIG_PIN_NAME $CONFIG_FILE | tr -d '\r' | tr -d ' ' | cut -d ':' -f 2`
			if [ "$CONFIG_PIN_CODE" == "" ]; then
				echo "WITHOUT_PIN" > $DEVICE_INIT_FILE
				wwan_log "[$0] can't find PIN code, exit"
				exit
			fi
			wwan_log "[$0] PIN code is $CONFIG_PIN_CODE"
			RECHECK_CPIN=ON
			eval "JsonClient /tmp/cgi-2-sys set_wwan_verify_pin '{\"pin_id\": 1, \"pin_code\": \"$CONFIG_PIN_CODE\"}'" > $CMD_RESPONSE_FILE
			if grep "\"errno\": 0" $CMD_RESPONSE_FILE; then
				echo "ENTER_PIN_OK" > $DEVICE_INIT_FILE
				wwan_log "[$0] enter PIN OK"
			else
				echo "ENTER_PIN_FAIL" > $DEVICE_INIT_FILE
				wwan_log "[$0] enter PIN FAIL"
			fi
		fi

		# recheck PIN code
		if [ "$RECHECK_CPIN" = "ON" ]; then
			wwan_log "[$0] do recheck PIN code"
			retry=3
			for i in `seq 1 $retry`; do
				JsonClient /tmp/cgi-2-sys get_wwan_pin_status > $CMD_RESPONSE_FILE
				if grep "\"status\": 2" $CMD_RESPONSE_FILE; then
					echo "CPIN_READY" > $DEVICE_INIT_FILE
					wwan_log "[$0] get_wwan_pin_status READY"
					break
				elif grep "\"status\": 3" $CMD_RESPONSE_FILE; then
					echo "CPIN_READY" > $DEVICE_INIT_FILE
					wwan_log "[$0] get_wwan_pin_status READY"
					break
				elif grep "\"status\": 1" $CMD_RESPONSE_FILE; then
					echo "NEED_PIN_CODE" > $DEVICE_INIT_FILE
					wwan_log "[$0] get_wwan_pin_status NEED PIN"
					break
				else
					echo "CPIN_FAIL" > $DEVICE_INIT_FILE
					wwan_log "[$0] get_wwan_pin_status FAIL, retry: $i"
					sleep 1
				fi
			done
		fi

		INIT_STATUS=`cat $DEVICE_INIT_FILE`
		if [ "$INIT_STATUS" != "CPIN_READY" ]; then
			wwan_log "[$0] get_wwan_pin_status ISSUE, init case interrupt, exit"
			exit
		fi

		# check network status
		retry=4
		for i in `seq 1 $retry`; do
			JsonClient /tmp/cgi-2-sys get_wwan_serving_system_status > $CMD_RESPONSE_FILE
			if grep "\"radio_mode\": 2" $CMD_RESPONSE_FILE; then
				echo "CREG_READY" > $DEVICE_INIT_FILE
				wwan_log "[$0] AT+CREG? 2G registered"
				break
			elif grep "\"radio_mode\": 3" $CMD_RESPONSE_FILE; then
				echo "CREG_READY" > $DEVICE_INIT_FILE
				wwan_log "[$0] AT+CREG? 3G registered"
				break
			elif grep "\"radio_mode\": 4" $CMD_RESPONSE_FILE; then
				echo "CREG_READY" > $DEVICE_INIT_FILE
				wwan_log "[$0] AT+CREG? 4G registered"
				break
			else
				echo "CREG_FAIL" > $DEVICE_INIT_FILE
				wwan_log "[$0] AT+CREG? FAIL, retry: $i"
#				break
				sleep 5
			fi
		done

		INIT_STATUS=`cat $DEVICE_INIT_FILE`
		if [ "$INIT_STATUS" != "CREG_READY" ]; then
			wwan_log "[$0] get_wwan_serving_system_status ISSUE, init case interrupt, exit"
			exit
		fi

		# connect dongle's wan side
		CONFIG_APN=`grep $CONFIG_APN_NAME $CONFIG_FILE | tr -d '\r' | tr -d ' ' | cut -d ':' -f 2`
		CONFIG_DIAL=`grep $CONFIG_DIAL_NAME $CONFIG_FILE | tr -d '\r' | tr -d ' ' | cut -d ':' -f 2`
		CONFIG_USERNAME=`grep $CONFIG_USERNAME_NAME $CONFIG_FILE | tr -d '\r' | tr -d ' ' | cut -d ':' -f 2`
		CONFIG_PASSWORD=`grep $CONFIG_PASSWORD_NAME $CONFIG_FILE | tr -d '\r' | tr -d ' ' | cut -d ':' -f 2`
		eval "JsonClient /tmp/cgi-2-sys set_wwan_apn_selection '{\"mode\": 1, \"apn\": \"$CONFIG_APN\", \"user_name\": \"$CONFIG_USERNAME\", \"password\": \"$CONFIG_PASSWORD\", \"dial_num\": \"$CONFIG_DIAL\"}'"
		#sleep 1
		eval "JsonClient /tmp/cgi-2-sys set_network_connection_mode '{\"manual_mode\": 1}'"
#-------------------------------------------------------------------------------
	elif [ "$DEVICE_DRIVER" = "cdc-ecm usbserial" ]; then

		if [ "$CMD_DEV_IF" = "" ]; then
			echo "WITHOUT_CMD_DEV_IF" > $DEVICE_INIT_FILE
			wwan_log "[$0] can't find CMD_DEV_IF $CMD_DEV_IF, exit"
			exit
		fi
		CMD_IF_DEV=$DEVICEPATH/$CMD_DEV_IF

		if [ -f $DEVICE_PECULIAR_FILE ]; then
			DEVICE_CHECK=`cat $DEVICE_PECULIAR_FILE`
			if [ "$DEVICE_CHECK" = "NWQMICONNECT" ]; then
				wwan_log "[$0] Peculiar dongle NOVATEL USB551L"

				# wwan_log "[$0] Wait 3 seconds for preparing SIM"
				sleep 1

				# check PIN code
				at_check_pin_code $CMD_IF_DEV

				# unlock PUK code and PIN code
				RECHECK_CPIN=OFF

				at_unlock_puk_and_pin_code $CMD_IF_DEV

				# recheck PIN code
				if [ "$RECHECK_CPIN" = "ON" ]; then

					at_check_pin_code $CMD_IF_DEV

				fi

				INIT_STATUS=`cat $DEVICE_INIT_FILE`
				if [ "$INIT_STATUS" != "CPIN_READY" -a "$INIT_STATUS" != "CPIN_FAIL" ]; then
					wwan_log "[$0] CPIN ISSUE, init case interrupt, exit"
					exit
				fi

				# check network status
				at_check_network_status $CMD_IF_DEV

				CONFIG_APN=`grep $CONFIG_APN_NAME $CONFIG_FILE | tr -d '\r' | tr -d ' ' | cut -d ':' -f 2`
				#CONFIG_DIAL=`grep $CONFIG_DIAL_NAME $CONFIG_FILE | tr -d '\r' | tr -d ' ' | cut -d ':' -f 2`
				CONFIG_USERNAME=`grep $CONFIG_USERNAME_NAME $CONFIG_FILE | tr -d '\r' | tr -d ' ' | cut -d ':' -f 2`
				CONFIG_PASSWORD=`grep $CONFIG_PASSWORD_NAME $CONFIG_FILE | tr -d '\r' | tr -d ' ' | cut -d ':' -f 2`

				retry=3
				for i in `seq 1 $retry`; do
					chat -V -s TIMEOUT 1 "" "AT\$nwqmiconnect=,,,,,,$CONFIG_APN,,,$CONFIG_USERNAME,$CONFIG_PASSWORD" "OK" "" < $CMD_IF_DEV > $CMD_IF_DEV
					wwan_log "[$0] Start connection..."
					sleep 35
					chat -V -s TIMEOUT 1 "" "AT\$nwqmistatus" "OK" "" < $CMD_IF_DEV > $CMD_IF_DEV 2> $CMD_RESPONSE_FILE
					if grep "QMI_RESULT_SUCCESS:0" $CMD_RESPONSE_FILE; then
						wwan_log "[$0] AT\$nwqmistatus success"
						break
					elif grep "QMI_ERR_CALL_FAILED" $CMD_RESPONSE_FILE; then
						wwan_log "[$0] AT\$nwqmistatus connect failure, try again"
						chat -V -s TIMEOUT 1 "" "AT\$nwqmidisconnect" "OK" "" < $CMD_IF_DEV > $CMD_IF_DEV
						if [ $i = '3' ]; then
							echo "CONNECT_FAIL" > $DEVICE_INIT_FILE
							exit
						fi
						sleep 3
					elif grep "ERROR" $CMD_RESPONSE_FILE; then
						wwan_log "[$0] AT\$nwqmistatus ERROR"
					fi
				done
			fi
		else
			wwan_log "[$0] can't open $DEVICE_PECULIAR_FILE file"
		fi
	fi

	if [ "$REINIT" = "reinit" ]; then
		DEVICE_DRIVER=`cat $DEVICE_DRIVER_FILE`
		if [ "$DEVICE_DRIVER" = "qmi-wwan" ]; then
			wwan_log "[$0] reinit qmi-wwan device"
			# QMI dongle need renew dhcp
#			kill -SIGUSR1 "`ps | grep "udhcpc" | head -n 1 | cut -d ' ' -f 2`"
			kill -SIGUSR1 "`cat /var/dhcp*`"
		elif [ "$DEVICE_DRIVER" = "cdc-ncm usbserial" ]; then
			wwan_log "[$0] reinit cdc-ncm usbserial device"

		elif [ "$DEVICE_DRIVER" = "gobinet usbserial" ]; then
			wwan_log "[$0] reinit gobinet usbserial device"
			# QMI dongle need renew dhcp
			kill -SIGUSR1 "`cat /var/dhcp*`"
		elif [ "$DEVICE_DRIVER" = "rmnet" ]; then
			wwan_log "[$0] reinit rmnet device"

		elif [ "$DEVICE_DRIVER" = "cdc-ecm usbserial" ]; then
			wwan_log "[$0] reinit cdc-ecm usbserial device"
		fi
	fi
	
#	ifconfig $DIAL_DEV_IF up
#	udhcpc -i $DIAL_DEV_IF &
else
	echo "INIT_FAIL" > $DEVICE_INIT_FILE
	wwan_log "[$0] unknown driver $DRIVER"
	wwan_log "[$0] init device fail, exit"
	exit
fi

echo "INIT_READY" > $DEVICE_INIT_FILE
wwan_log "[$0] init device done, exit"
#exit
