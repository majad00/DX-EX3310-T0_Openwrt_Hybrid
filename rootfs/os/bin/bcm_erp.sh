#!/bin/sh
INTF_wl0=`cat /proc/net/dev | grep wl0`
INTF_wl1=`cat /proc/net/dev | grep wl1`
BAND_wl0=
BAND_wl1=
CMD_INTF=
BCMERP="/tmp/.bcmerp"

if [[ -e "/bin/wlctl" ]] ; then
	if [[ "$INTF_wl0" != "" ]] ; then
		BAND_wl0=`wl -i wl0 band`
	fi
	if [[ "$INTF_wl1" != "" ]] ; then
		BAND_wl1=`wl -i wl1 band`
	fi
fi

help() {
	echo ""
	echo "Usage:	$0 <help | wl0 | wl1 | restore>"
	echo ""
}

if [[ "$1" == "wl0" ]] || [[ "$1" == "wl1" ]] ; then
	CMD_INTF=$1
elif [[ "$1" == "2G" ]] ; then
	if [[ "$BAND_wl0" == "b" ]] ; then
		CMD_INTF="wl0"
	elif [[ "$BAND_wl1" == "b" ]] ; then
		CMD_INTF="wl1"
	fi
elif [[ "$1" == "5G" ]] ; then
	if [[ "$BAND_wl0" == "a" ]] ; then
		CMD_INTF="wl0"
	elif [[ "$BAND_wl1" == "a" ]] ; then
		CMD_INTF="wl1"
	fi
elif [[ "$1" == "restore" ]] ; then
	$BCMERP
	exit 0
else
	help
	exit 0
fi

echo "Command Interface=$CMD_INTF"

if [[ "$CMD_INTF" == "" ]] ; then
	exit 0
fi


P1=`wl -i $CMD_INTF rxchain_pwrsave_enable`
P2=`wl -i $CMD_INTF rxchain`
P3=`wl -i $CMD_INTF txchain`
P4=`wl -i $CMD_INTF aspm`
echo "#!/bin/sh" > $BCMERP
echo "wl -i $CMD_INTF rxchain_pwrsave_enable $P1" >> $BCMERP
echo "wl -i $CMD_INTF rxchain $P2" >> $BCMERP
echo "wl -i $CMD_INTF txchain $P3" >> $BCMERP
echo "wl -i $CMD_INTF aspm $P4" >> $BCMERP
chmod 755 $BCMERP

wl -i $CMD_INTF rxchain_pwrsave_enable 1
wl -i $CMD_INTF rxchain 1
wl -i $CMD_INTF txchain 1
wl -i $CMD_INTF aspm 0x3

