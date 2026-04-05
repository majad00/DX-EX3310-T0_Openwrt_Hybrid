#set -x
#!/bin/sh
# Copyright (C) ZyXEL Communications, Corp. All Rights Reserved.
# Version 1.0

#driver_remove() {
	#echo "[$0] Remove drivers..."
	#rmmod option.ko
	#rmmod sierra.ko
	#rmmod usb_wwan.ko
	#rmmod usbserial.ko
	#rmmod lg-vl600.ko
	#rmmod cdc-acm.ko
	#rmmod rndis_host.ko
	#rmmod cdc_ether.ko
	#rmmod cdc-wdm.ko
	#rmmod usbnet.ko
	#rmmod hso.ko
	#rmmod rfkill.ko
#}

description() {
	clear
	echo -e "There are 7 kind of driver, but we still have to classify the drivers into\ncertain types. Here is a table for drivers and devices"
	echo -e "----------------------------------------------"
	echo -e "|  Device  |  Driver                         |"
	echo -e "=============================================="
	echo -e "|  ttyUSB  |  usbserial, option              |"
	echo -e "----------------------------------------------"
	echo -e "|  ttyACM  |  cdc-acm                        |"
	echo -e "----------------------------------------------"
	echo -e "|  ttyHS   |  hso                            |"
	echo -e "----------------------------------------------"
	echo -e "|  eth     |  cdc-ecm, rndis_host, qmi-wwan  |"
	echo -e "----------------------------------------------\n"
}

result() {
	for PORT in $(ls $USB_INTERFACE_DIR | grep -v : | grep -v usb); do
		for FACE in $(ls $USB_INTERFACE_DIR/$PORT/ | grep ^[1-2]); do
			DRI=`cat $USB_INTERFACE_DIR/$PORT/$FACE/uevent | grep "DRIVER" | grep -v "PHYSDEVDRIVER" | cut -d '=' -f 2`
			if [ "$DRI" == "option" ]; then
				write_conf $VID $PID usbserial ttyUSB
				DEV=ttyUSB
				return
			elif [ "$DRI" == "cdc_acm" ]; then
				write_conf $VID $PID cdc-acm ttyACM
				DEV=ttyACM
				return
			elif [ "$DRI" == "cdc_ether" ]; then
				write_conf $VID $PID cdc_ecm eth
				DEV=eth
				return
			elif [ "$DRI" == "rndis_host" ]; then
				write_conf $VID $PID rndis_host eth
				DEV=eth
				return
			elif [ "$DRI" == "hso" ]; then
				write_conf $VID $PID hso ttyHS
				DEV=ttyHS
				return
			elif [ "$DRI" == "qmi-wwan" ]; then
				write_conf $VID $PID qmi-wwan eth
				DEV=eth
				return
			elif [ "$DRI" == "" ] || [ "$DRI" == "usb-storage" ]; then
				continue
			fi
		done
		echo "No driver..."
	done
}

write_conf() {
	echo "TARGET_VID: $1" > /var/tmp/porting_config
	echo "TARGET_PID: $2" >> /var/tmp/porting_config
	echo "DRIVER: $3" >> /var/tmp/porting_config
	echo "DEVICE: $4" >> /var/tmp/porting_config
}

tty_test() {
	if [ $1 = "eth" ]; then
		echo -e "Device is eth"
		echo -e "--------------------------------------------------------------------------------\n"
		return
	fi

	echo -e "\nPlease wait for Get dial and CMD interface..."
	echo "available tty is:" >> /var/tmp/porting_config
	for tty in $(ls /dev/$1*); do
		chat -V -t 1 "" "AT" "OK" "" < $tty > $tty 2> /var/tmp/chat_tty &
		sleep 1
		if [ -f /var/tmp/chat_tty ]; then
			RES=`grep 'OK' /var/tmp/chat_tty`
			if [ "$RES" = "OK" ]; then
				cat /var/tmp/chat_tty 2> /dev/null
				echo [$0] $tty is available!
				echo $tty >> /var/tmp/porting_config
			fi
		else
			echo "Can't find /var/tmp/chat_tty"
			#cat /var/tmp/porting_config
			ps | grep chat | grep -v "grep" | awk '{print $1}' | xargs kill
			rm /var/tmp/chat_tty 2> /dev/null
			echo -e "--------------------------------------------------------------------------------\n"
			return
		fi
		rm /var/tmp/chat_tty
	done
	echo -e "--------------------------------------------------------------------------------\n"
}

SERIAL_MODULES=/lib/modules/`uname -r`/kernel/drivers/usb/serial
CLASS_MODULES=/lib/modules/`uname -r`/kernel/drivers/usb/class
USBNET_MODULES=/lib/modules/`uname -r`/kernel/drivers/net/usb
RFKILL_MODULES=/lib/modules/`uname -r`/kernel/net/rfkill
MODULES=/lib/modules/usbhost

USB_INTERFACE_DIR=/sys/bus/usb/devices
USB_INTERFACE_LIST=`ls $USB_INTERFACE_DIR | grep -v : | grep -v usb`
if [ "$USB_INTERFACE_LIST" = "" ]; then
	echo "No USB devices!"
	exit 0
fi
VID=`cat $USB_INTERFACE_DIR/$USB_INTERFACE_LIST/idVendor`
PID=`cat $USB_INTERFACE_DIR/$USB_INTERFACE_LIST/idProduct`
DEV=ttyUSB
##################### insmod driver #####################
#driver_remove
rm /var/tmp/porting_config 2> /dev/null
clear


echo -e "Plug `ls $USB_INTERFACE_DIR | grep -v : | grep -v usb | wc -l` USB dongle(s)"
result

while :
do
	echo "Start mount the drivers, please chose one driver..."
	echo " 1) cat /proc/bus/usb/devices"
	echo " 2) tty devices test"
	echo " 3) Description"
	echo " 4) Show porting result"
	echo " 0) exit"

	read -p ": " CASE_SEL

	case "$CASE_SEL" in
		#a | A) # usbserial
			#driver_remove 2> /dev/null
			#echo "[$0] Try to mount the driver: usbserial.ko → usb_wwan.ko → option.ko ..."
			#insmod $MODULES/usbserial.ko 2> /dev/null
			#insmod $SERIAL_MODULES/usbserial.ko 2> /dev/null
			#insmod $MODULES/usb_wwan.ko 2> /dev/null
			#insmod $SERIAL_MODULES/usb_wwan.ko 2> /dev/null
			#insmod $MODULES/option.ko 2> /dev/null
			#insmod $SERIAL_MODULES/option.ko 2> /dev/null
			#sleep 1
			#echo -e "\n[$0] echo the target VID $VID and PID $PID to new_id.\n"
			#echo "$VID $PID" > /sys/bus/usb-serial/drivers/option1/new_id
			#write_conf $VID $PID usbserial ttyUSB
			#DEV=ttyUSB
			#result
			#;;
		#b | B) # option
			#driver_remove 2> /dev/null
			#echo "[$0] Try to mount the driver: usbserial.ko → option.ko ..."
			#insmod $MODULES/usbserial.ko 2> /dev/null
			#insmod $SERIAL_MODULES/usbserial.ko 2> /dev/null
			#insmod $MODULES/option.ko 2> /dev/null
			#insmod $SERIAL_MODULES/option.ko 2> /dev/null
			#sleep 1
			##echo -e "\n[$0] Entering the target VID $VID and PID $PID.\n"
			##echo "$VID $PID" > /sys/bus/usb-serial/drivers/option1/new_id
			#write_conf $VID $PID usbserial ttyUSB
			#DEV=ttyUSB
			#result
			#;;
		#c | C) # cdc-acm
			#driver_remove 2> /dev/null
			#echo "[$0] Try to mount the driver: cdc-acm.ko"
			#insmod $MODULES/cdc-acm.ko 2> /dev/null
			#insmod $CLASS_MODULES/cdc-acm.ko 2> /dev/null
			#write_conf $VID $PID cdc-acm ttyACM
			#DEV=ttyACM
			#result
			#;;
		#d | D) # cdc-ecm
			#driver_remove 2> /dev/null
			#echo "[$0] Try to mount the driver: usbnet.ko → cdc-ether.k"
			#insmod $MODULES/usbnet.ko 2> /dev/null
			#insmod $USBNET_MODULES/usbnet.ko 2> /dev/null
			#insmod $MODULES/cdc_ether.ko 2> /dev/null
			#insmod $USBNET_MODULES/cdc_ether.ko 2> /dev/null
			#write_conf $VID $PID cdc-ecm eth
			#DEV=eth
			#result
			#;;
		#e | E) # rndis_host
			#driver_remove 2> /dev/null
			#echo "[$0] Try to mount the driver: usbnet.ko → cdc_ether.ko → rndis_host.ko"
			#insmod $MODULES/usbnet.ko 2> /dev/null
			#insmod $USBNET_MODULES/usbnet.ko 2> /dev/null
			#insmod $MODULES/cdc_ether.ko 2> /dev/null
			#insmod $USBNET_MODULES/cdc_ether.ko 2> /dev/null
			#insmod $MODULES/rndis_host.ko 2> /dev/null
			#insmod $USBNET_MODULES/rndis_host.ko 2> /dev/null
			#write_conf $VID $PID rndis_host eth
			#DEV=eth
			#result
			#;;
		#f | F) # hso
			#driver_remove 2> /dev/null
			#echo "[$0] Try to mount the driver: rfkill.ko → hso.ko"
			#insmod $MODULES/rfkill.ko 2> /dev/null
			#insmod $RFKILL_MODULES/rfkill.ko 2> /dev/null
			#insmod $MODULES/hso.ko 2> /dev/null
			#insmod $USBNET_MODULES/hso.ko 2> /dev/null
			#echo -e "\n[$0] echo the target VID $VID and PID $PID new_id.\n"
			#echo "$VID $PID" > /sys/bus/usb/drivers/hso/new_id
			#write_conf $VID $PID hso ttyHS
			#DEV=ttyHS
			#result
			#;;
		#g | G) # qmi-wwan
			#driver_remove 2> /dev/null
			#echo "[$0] Try to mount the driver: usbnet.ko → cdc-wdm.ko → qmi_wwan.ko"
			#insmod $MODULES/usbnet.ko 2> /dev/null
			#insmod $USBNET_MODULES/usbnet.ko 2> /dev/null
			#insmod $MODULES/cdc-wdm.ko 2> /dev/null
			#insmod $USBNET_MODULES/cdc-wdm.ko 2> /dev/null
			#insmod $MODULES/qmi_wwan.ko 2> /dev/null
			#insmod $CLASS_MODULES/qmi_wwan.ko 2> /dev/null
			#write_conf $VID $PID qmi-wwan eth
			#DEV=eth
			#result
			#;;
		1)	cat /proc/bus/usb/devices;;
		2)	tty_test $DEV;;
		3)	description;;
		4)
			if [ -f /var/tmp/porting_config ]; then
				echo -e "--------------------------------------------------------------------------------"
				cat /var/tmp/porting_config
				echo -e "--------------------------------------------------------------------------------\n"
			else
				echo -e "Can't find the /var/tmp/porting_config or no information.\n"
			fi
			;;
		0)	echo "Bye!"
			exit 0;;
		*) echo -e "...Sorry, please try again...\n\n";;
	esac

done
exit 0

