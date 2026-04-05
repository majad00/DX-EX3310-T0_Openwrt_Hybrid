#!/bin/sh

export PATH=/home/bin:/home/scripts:/opt/bin:/bin:/sbin:/usr/bin:/usr/sbin
#export LD_LIBRARY_PATH=/lib/public:/lib/private:/usr/lib:/lib:/usr/lib/ebtables:/usr/lib/iptables

SUPPORT_LIB64=`ls / | grep lib64`
if [ "$SUPPORT_LIB64" == "lib64" ] ;then
export LD_LIBRARY_PATH=/lib/public:/lib/private:/lib/gpl:/usr/lib:/lib:/lib64/gpl:/lib64:/usr/lib/ebtables:/usr/lib/iptables
else
export LD_LIBRARY_PATH=/lib/public:/lib/private:/usr/lib:/lib:/usr/lib/ebtables:/usr/lib/iptables
fi

CORE_FILE=/etc/zcmd_dump

Check_Brcm_PwrSave()
{
	if [ -f $CORE_FILE ]; then
		ulimit -c unlimited
		echo "/var/log/core_%e.%p.%t " > /proc/sys/kernel/core_pattern
		echo 2 > /proc/sys/fs/suid_dumpable
		echo 1 > /proc/sys/kernel/print-fatal-signals
		echo "=========== zcmd_core_dump.sh: Settings the core_pattern,suid_dumpable,print-fatal-signals for zcmd gdb ==========="
	fi
	
	if [ -e /lib/modules/*/extra/pwrmngtd.ko ] && [ -e /bin/pwrctl ]; then
		echo "Set PowerSave to auto by default ......"
		/bin/pwrctl config --cpuspeed 256
	fi
}

Set_Default_Time()
{
	date -s `uname -v | sed 's/\(.\+\)SMP\(.\+\)/\2/' | sed 's/\(.\+\)EMPT\(.\+\)/\2/' | awk '{print $6"."$2"."$3"-"$4}' | sed 's/Jan/01/g;s/Mar/03/g;s/Feb/02/g;s/Apr/04/g;s/May/05/g;s/Jun/06/g;s/Jul/07/g;s/Aug/08/g;s/Sep/09/g;s/Oct/10/g;s/Nov/11/g;s/Dec/12/g'`; date +%T -s "-23:00:00"; date +%T -s "00:00:00"
}

Set_Localhost_to_hosts_file()
{
	echo 127.0.0.1 localhost >> /tmp/hosts
}

case "$1" in
	start)
		Check_Brcm_PwrSave
		Set_Default_Time
		Set_Localhost_to_hosts_file
		echo 0 > /proc/sys/net/ipv6/conf/default/disable_ipv6
		/bin/zcmd
		exit 0
		;;

	*)
		echo "$0: unrecognized option $1"
		exit 1
		;;

esac

