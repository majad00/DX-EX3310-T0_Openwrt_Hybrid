#!/bin/sh

# Copyright (C) ZyXEL Communications, Corp. All Rights Reserved.

# $1: device number
# $2: VID
# $3: PID

#set -x

# Environment Variables
#WWANPATH=/sbin  # set the WWAN directory path #~!@#$%^&*()_+

. $WWANPATH/wwan-lib.sh

echo "[$0] enter" > /dev/console

DEVICE_NUMBER=$1
VID=$2
PID=$3
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

CMD_RESPONSE_NAME=cmd_tmp
DEVICE_STATUS_FILE=$DEVICE_DIR/$DEVICE_STATUS_NAME
DEVICE_TYPE_FILE=$DEVICE_DIR/$DEVICE_TYPE_NAME
DEVICE_CMD_FILE=$DEVICE_DIR/$DEVICE_CMD_IF_NAME
CMD_RESPONSE_FILE=$DEVICE_DIR/$CMD_RESPONSE_NAME
DEVICE_UPDATE_FILE=$DEVICE_DIR/$DEVICE_UPDATE_NAME
DEVICE_MODEL_FILE=$DEVICE_DIR/$DEVICE_MODEL_NAME
DEVICE_DRIVER_FILE=$DEVICE_DIR/$DEVICE_DRIVER_NAME

DEVICE_STATUS=`cat $DEVICE_STATUS_FILE`
if [ "$DEVICE_STATUS" != "DRIVER_READY" ]; then
	wwan_log "[$0] DRIVER is not READY, update case interrupt, exit"
	exit
fi

if [ -e "$DEVICE_UPDATE_FILE" ]; then
	# SERVICE_PROVIDER=`grep "service_provider" $DEVICE_UPDATE_FILE | tr -d '\r' | tr -d ' ' | cut -d ':' -f 2`
	# SIGNAL_STRENGTH=`grep "signal_strength" $DEVICE_UPDATE_FILE | tr -d '\r' | tr -d ' ' | cut -d ':' -f 2`
	MANUFACTURER=`grep "manufacturer" $DEVICE_UPDATE_FILE | tr -d '\r' | tr -d ' ' | cut -d ':' -f 2`
	MODEL=`grep "model" $DEVICE_UPDATE_FILE | tr -d '\r' | tr -d ' ' | cut -d ':' -f 2`
	FW_VERSION=`grep "fw_version" $DEVICE_UPDATE_FILE | tr -d '\r' | tr -d ' ' | cut -d ':' -f 2`
	SIM_IMSI=`grep "sim_imsi" $DEVICE_UPDATE_FILE | tr -d '\r' | tr -d ' ' | cut -d ':' -f 2`
fi

DEVICE_TYPE=`cat $DEVICE_TYPE_FILE`
DRIVER_TYPE=`cat $DEVICE_DRIVER_FILE`

if [ "$DEVICE_TYPE" = "tty" ]; then
	CMD_TTY_DEV_NAME=`cat $DEVICE_CMD_FILE`
	if [ "$CMD_TTY_DEV_NAME" = "" ]; then
		wwan_log "[$0] can't find CMD_TTY_DEVICE $CMD_TTY_DEV_NAME, exit"
		exit
	fi
	CMD_TTY_DEV=$DEVICEPATH/$CMD_TTY_DEV_NAME
	
	# Service Provider
	#  AT+COPS=3,0
	#  AT+COPS?
	if [ "$SERVICE_PROVIDER" = "" ]; then
		chat -V -s TIMEOUT 1 "" "AT+COPS=3,0" "OK" "" < $CMD_TTY_DEV > $CMD_TTY_DEV
		chat -V -s TIMEOUT 1 "" "AT+COPS?" "OK" "" < $CMD_TTY_DEV > $CMD_TTY_DEV 2> $CMD_RESPONSE_FILE
		SERVICE_PROVIDER=`grep "," $CMD_RESPONSE_FILE | cut -d ',' -f 3 | tr -d '"' | tr -d '/\n'`
		Technology=`grep "," $CMD_RESPONSE_FILE | cut -d ',' -f 4 | tr -d '"' | tr -d '/\n'`
	fi
	echo "service_provider:$SERVICE_PROVIDER" > $DEVICE_UPDATE_FILE
	echo "technology:$Technology" >> $DEVICE_UPDATE_FILE
	wwan_log "[$0] Service Provider: $SERVICE_PROVIDER"
	wwan_log "[$0] Technology: $Technology"
	
	# Signal Strength
	#  AT+CSQ
	#  dbm = -113 + rssi*2;
	if [ "$SIGNAL_STRENGTH" = "" ]; then
		chat -V -s TIMEOUT 1 "" "AT+CSQ" "OK" "" < $CMD_TTY_DEV > $CMD_TTY_DEV 2> $CMD_RESPONSE_FILE
		SIGNAL_STRENGTH=`grep "," $CMD_RESPONSE_FILE | cut -d ':' -f 2 | cut -d ',' -f 1 | tr -d " " | tr -d '/\n'`
	fi
	echo "signal_strength:$SIGNAL_STRENGTH" >> $DEVICE_UPDATE_FILE
	wwan_log "[$0] Signal Strength: $SIGNAL_STRENGTH"
	
	# Connection Uptime
	#  need to add
	
	# Manufacturer
	#  AT+CGMI
	if [ "$MANUFACTURER" = "" ]; then
#		chat -V -s TIMEOUT 1 "" "AT+CGMI" "OK" "" < $CMD_TTY_DEV > $CMD_TTY_DEV 2> $CMD_RESPONSE_FILE
#		MANUFACTURER=`sed -e "s/AT//g" -e "s/CGMI//g" -e "s/OK//g" $CMD_RESPONSE_FILE`
#		MANUFACTURER=`echo $MANUFACTURER | tr -d " " | tr -d '/\n' | tr -d ":" | tr -d '+'`

		MANUFACTURER=`cat $DEVICE_MODEL_FILE | cut -d ' ' -f 1 | cut -d '_' -f 1`
	fi
	echo "manufacturer:$MANUFACTURER" >> $DEVICE_UPDATE_FILE
	wwan_log "[$0] Manufacturer: $MANUFACTURER"
	
	# Model
	#  AT+CGMM
	if [ "$MODEL" = "" ]; then
		if [ "$MANUFACTURER" = "HUAWEI" ]; then
			chat -V -s TIMEOUT 1 "" "AT+CGMM" "OK" "" < $CMD_TTY_DEV > $CMD_TTY_DEV 2> $CMD_RESPONSE_FILE
			MODEL=`sed -e "s/AT//g" -e "s/CGMM//g" -e "s/OK//g" $CMD_RESPONSE_FILE`
			MODEL=`echo $MODEL | tr -d " " | tr -d '/\n' | tr -d ":" | tr -d '+'`
		else
			MODEL=`cat $DEVICE_MODEL_FILE | cut -d ' ' -f 1 | cut -d '_' -f 2`
		fi
	fi
	echo "model:$MODEL" >> $DEVICE_UPDATE_FILE
	wwan_log "[$0] Model: $MODEL"
	
	# FW Version
	#  AT+CGMR
	if [ "$FW_VERSION" = "" ]; then
		chat -V -s TIMEOUT 1 "" "AT+CGMR" "OK" "" < $CMD_TTY_DEV > $CMD_TTY_DEV 2> $CMD_RESPONSE_FILE
		FW_VERSION=`sed -e "s/AT//g" -e "s/CGMR//g" -e "s/OK//g" $CMD_RESPONSE_FILE`
		FW_VERSION=`echo $FW_VERSION | tr -d " " | tr -d '/\n' | tr -d ":" | tr -d '+'`
	fi
	echo "fw_version:$FW_VERSION" >> $DEVICE_UPDATE_FILE
	wwan_log "[$0] FW Version: $FW_VERSION"
	
	# SIM IMSI
	#  AT+CIMI
	if [ "$SIM_IMSI" = "" ]; then
		chat -V -s TIMEOUT 1 "" "AT+CIMI" "OK" "" < $CMD_TTY_DEV > $CMD_TTY_DEV 2> $CMD_RESPONSE_FILE
		SIM_IMSI=`sed -e "s/AT//g" -e "s/CIMI//g" -e "s/OK//g" $CMD_RESPONSE_FILE`
		SIM_IMSI=`echo $SIM_IMSI | tr -d " " | tr -d '/\n' | tr -d ":" | tr -d '+'`
	fi
	echo "sim_imsi:$SIM_IMSI" >> $DEVICE_UPDATE_FILE
	wwan_log "[$0] SIM IMSI: $SIM_IMSI"
	
	# HUAWEI check PIN remaining authentication times
	if [ "$REMAINING_PIN" = "" ]; then
		chat -V -s TIMEOUT 1 "" "AT\^CPIN?" "OK" "" < $CMD_TTY_DEV > $CMD_TTY_DEV 2> $CMD_RESPONSE_FILE
		REMAINING_PIN=`grep "," $CMD_RESPONSE_FILE | cut -d ',' -f 2 | tr -d ' ' | tr -d '/\n'`
	fi
	echo "remaining_pin:$REMAINING_PIN" >> $DEVICE_UPDATE_FILE
	wwan_log "[$0] Remaining PIN: $REMAINING_PIN"
elif [ "$DRIVER_TYPE" = "qmi-wwan usbserial" ]; then
	wwan_log "Update cellular information (qmi-wwan usbserial)!!!"
	CMD_TTY_DEV_NAME=`cat $DEVICE_CMD_FILE`

	if [ "$CMD_TTY_DEV_NAME" = "" ]; then
		wwan_log "[$0] can't find CMD_TTY_DEVICE $CMD_TTY_DEV_NAME, exit"
		exit
	fi
	CMD_TTY_DEV=$DEVICEPATH/$CMD_TTY_DEV_NAME

	if [ -e "$DEVICE_UPDATE_FILE" ]; then
		MANUFACTURER=`grep "manufacturer" $DEVICE_UPDATE_FILE | tr -d '\r' | tr -d ' ' | cut -d ':' -f 2`
		MODEL=`grep "model" $DEVICE_UPDATE_FILE | tr -d '\r' | tr -d ' ' | cut -d ':' -f 2`
		FW_VERSION=`grep "fw_version" $DEVICE_UPDATE_FILE | tr -d '\r' | tr -d ' ' | cut -d ':' -f 2`
		SIM_IMSI=`grep "sim_imsi" $DEVICE_UPDATE_FILE | tr -d '\r' | tr -d ' ' | cut -d ':' -f 2`
	fi

	# Service Provider
	#  AT+COPS=3,0
	#  AT+COPS?
	if [ "$SERVICE_PROVIDER" = "" ]; then
		chat -V -s TIMEOUT 1 "" "AT+COPS=3,0" "OK" "" < $CMD_TTY_DEV > $CMD_TTY_DEV
		chat -V -s TIMEOUT 1 "" "AT+COPS?" "OK" "" < $CMD_TTY_DEV > $CMD_TTY_DEV 2> $CMD_RESPONSE_FILE
		SP_BOTH=`sed -e "s/AT//g" -e "s/COPS?//g" -e "s/OK//g" $CMD_RESPONSE_FILE`
		SP_BOTH=`echo $SP_BOTH | tr -d " " | tr -d '/\n' | tr -d ":" | tr -d '+'`
		SERVICE_PROVIDER=`echo $SP_BOTH | cut -d ',' -f 3 | tr -d '"' | tr -d '/\n'`
		Technology_value=`echo $SP_BOTH | cut -d ',' -f 4 | tr -d '"' | tr -d '/\n'`
		if [ "$Technology_value" = "7" ]; then
			Technology = "E-UTRAN"
		elif [ "$Technology_value" = "6" ]; then
			Technology = "UTRAN W/HSDPA adn HSUPA"
		elif [ "$Technology_value" = "5" ]; then
			Technology = "UTRAN W/HSUPA"
		elif [ "$Technology_value" = "4" ]; then
			Technology = "UTRAN W/HSDPA"
		elif [ "$Technology_value" = "2" ]; then
			Technology = "UTRAN"
		else
			Technology = "UNKNOWN"
		fi
	fi
	echo "service_provider:$SERVICE_PROVIDER" > $DEVICE_UPDATE_FILE
	echo "technology:$Technology" >> $DEVICE_UPDATE_FILE
	wwan_log "[$0] Service Provider: $SERVICE_PROVIDER"
	wwan_log "[$0] Technology: $Technology"

	# Signal Strength
	#  AT+CSQ
	#  dbm = -113 + rssi*2;
	if [ "$SIGNAL_STRENGTH" = "" ]; then
		chat -V -s TIMEOUT 1 "" "AT+CSQ" "OK" "" < $CMD_TTY_DEV > $CMD_TTY_DEV 2> $CMD_RESPONSE_FILE
		SIGNAL_STRENGTH=`grep "," $CMD_RESPONSE_FILE | cut -d ':' -f 2 | cut -d ',' -f 1 | tr -d " " | tr -d '/\n'`
	fi
	echo "signal_strength:$SIGNAL_STRENGTH" >> $DEVICE_UPDATE_FILE
	wwan_log "[$0] Signal Strength: $SIGNAL_STRENGTH"

	# Manufacturer
	#  AT+CGMI
	if [ "$MANUFACTURER" = "" ]; then
#		chat -V -s TIMEOUT 1 "" "AT+CGMI" "OK" "" < $CMD_TTY_DEV > $CMD_TTY_DEV 2> $CMD_RESPONSE_FILE
#		MANUFACTURER=`sed -e "s/AT//g" -e "s/CGMI//g" -e "s/OK//g" $CMD_RESPONSE_FILE`
#		MANUFACTURER=`echo $MANUFACTURER | tr -d " " | tr -d '/\n' | tr -d ":" | tr -d '+'`
		MANUFACTURER=`cat $DEVICE_MODEL_FILE | cut -d ' ' -f 1 | cut -d '_' -f 1`
	fi
	echo "manufacturer:$MANUFACTURER" >> $DEVICE_UPDATE_FILE
	wwan_log "[$0] Manufacturer: $MANUFACTURER"

	# Model
	#  AT+CGMM
	if [ "$MODEL" = "" ]; then
		if [ "$MANUFACTURER" = "HUAWEI" ]; then
			chat -V -s TIMEOUT 1 "" "AT+CGMM" "OK" "" < $CMD_TTY_DEV > $CMD_TTY_DEV 2> $CMD_RESPONSE_FILE
			MODEL=`sed -e "s/AT//g" -e "s/CGMM//g" -e "s/OK//g" $CMD_RESPONSE_FILE`
			MODEL=`echo $MODEL | tr -d " " | tr -d '/\n' | tr -d ":" | tr -d '+'`
		else
			MODEL=`cat $DEVICE_MODEL_FILE | cut -d ' ' -f 1 | cut -d '_' -f 2`
		fi
	fi
	echo "model:$MODEL" >> $DEVICE_UPDATE_FILE
	wwan_log "[$0] Model: $MODEL"

	# FW Version
	#  AT+CGMR
	if [ "$FW_VERSION" = "" ]; then
		chat -V -s TIMEOUT 1 "" "AT+GMR" "OK" "" < $CMD_TTY_DEV > $CMD_TTY_DEV 2> $CMD_RESPONSE_FILE
		FW_VERSION=`sed -e "s/AT//g" -e "s/GMR//g" -e "s/OK//g" $CMD_RESPONSE_FILE | tr -d " " | tr -d '/\n' | tr -d ":" | tr -d '+'`
		#FW_VERSION=`echo $FW_VERSION | tr -d " " | tr -d '/\n' | tr -d ":" | tr -d '+'`
	fi
	echo "fw_version:$FW_VERSION" >> $DEVICE_UPDATE_FILE
	wwan_log "[$0] FW Version: $FW_VERSION"

	# SIM IMSI
	#  AT+CIMI
	if [ "$SIM_IMSI" = "" ]; then
		chat -V -s TIMEOUT 1 "" "AT+CIMI" "OK" "" < $CMD_TTY_DEV > $CMD_TTY_DEV 2> $CMD_RESPONSE_FILE
		SIM_IMSI=`sed -e "s/AT//g" -e "s/CIMI//g" -e "s/OK//g" $CMD_RESPONSE_FILE  | tr -d " " | tr -d '/\n' | tr -d ":" | tr -d '+'`

	fi
	echo "sim_imsi:$SIM_IMSI" >> $DEVICE_UPDATE_FILE
	wwan_log "[$0] SIM IMSI: $SIM_IMSI"

	# PIN Status
	#  AT+CPIN?
	if [ "$REMAINING_PIN" = "" ]; then
		chat -V -s TIMEOUT 1 "" "AT+CPIN?" "OK" "" < $CMD_TTY_DEV > $CMD_TTY_DEV 2> $CMD_RESPONSE_FILE
		REMAINING_PIN=`sed -e "s/AT//g" -e "s/CPIN?//g" -e "s/OK//g" $CMD_RESPONSE_FILE`
		REMAINING_PIN=`echo $REMAINING_PIN | cut -d ':' -f 2 | tr -d '"' | tr -d '/\n'`
	fi
	echo "remaining_pin:$REMAINING_PIN" >> $DEVICE_UPDATE_FILE
	wwan_log "[$0] Remaining PIN: $REMAINING_PIN"
else
	if [ "$VID" = "1bbb" ]; then
		if [ "$PID" = "0195" -o "$PID" = "0908" ]; then
			if [ "$SIM_IMSI" = "" ]; then
				curl -k -X POST http://ik40.home/jrd/webapi?api=GetSystemInfo -H "Origin: http://ik40.home" -H "Referer: http://ik40.home/index.html" -d {\"jsonrpc\":\"2.0\",\"method\":\"GetSystemInfo\",\"params\":null,\"id\":\"13.3\"}> $CMD_RESPONSE_FILE
				SIM_IMSI=`cat $CMD_RESPONSE_FILE | cut -d "," -f 9 | awk '{print $2}'| tr -d '"'`
                if [ "$SIM_IMSI" != "" ]; then
					echo "sim_imsi:$SIM_IMSI" >> $DEVICE_UPDATE_FILE
					wwan_log "[$0] SIM IMSI: $SIM_IMSI"
                fi
            fi
			exit
		fi
	fi
	wwan_log "[$0] it is not tty dongle, update function do nothing"

fi

wwan_log "[$0] update done, exit"
#exit
