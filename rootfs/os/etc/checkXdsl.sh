adsl=`wan show ADSL_MGNT | grep Connected`
vdsl=`wan show VD_MGNT | grep Connected`
rm /tmp/WAN_PTM
rm /tmp/WAN_ATM
if [ "$adsl" != "" ]; then
	touch /tmp/WAN_ATM
fi
if [ "$vdsl" != "" ]; then
	touch /tmp/WAN_PTM
fi
exit (0)
