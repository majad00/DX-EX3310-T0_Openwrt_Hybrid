#!/bin/sh

if [ $# != 1 ] ; then
		echo "usage: $0 [agent/controller]"
		exit 0
fi

DeviceRole=$1

if [ $DeviceRole = "agent" ] ; then
	ISAgent=1
	MAP_CONF=/etc/map_cfg_agent.txt
	MAPD_CONF=/etc/mapd_cfg_agent.txt
else
	ISAgent=0
	MAP_CONF=/etc/map_cfg.txt
	MAPD_CONF=/etc/mapd_cfg.txt
fi	
MAP_WTS_BSS_INFO_CFG_FILE=/etc/wts_bss_info_config
MAPD_STRNG_CONF_FILE=/etc/mapd_strng.conf

	if [ ! -f $MAP_CONF ] ; then
		echo "error:$MAP_CONF not exist"
		exit 1
	fi
	if [ ! -f $MAPD_CONF ] ; then
		echo "error:$MAPD_CONF not exist"
		exit 1
	fi
	if [ ! -f $MAP_WTS_BSS_INFO_CFG_FILE ] ; then
		echo "error:$MAP_WTS_BSS_INFO_CFG_FILE not exist"
		exit 1
	fi

	if [	"$ISAgent" = "1" ] ; then
		/sbin/ifconfig apcli0 down
		/sbin/ifconfig apclii0 down
		/sbin/ifconfig apcli0 up
		brctl addif br0 apcli0
		/sbin/ifconfig apclii0 up
		brctl addif br0 apclii0
		iwpriv apcli0 set ApCliEnable=0
		iwpriv apcli0 set ApCliiEnable=0
		tcapi set mesh_mapcfg bss_config_priority "ra0;ra1;ra2;ra3;rai0;rai1;rai2;rai3;apcli0;apclii0"
		/userfs/bin/wapp > /dev/null &
		sleep 15
		/userfs/bin/p1905_managerd -r1 -f $MAP_CONF -F $MAP_WTS_BSS_INFO_CFG_FILE > /dev/console &
		sleep 5
		/userfs/bin/mapd -G $MAP_WTS_BSS_INFO_CFG_FILE -I $MAPD_CONF -O $MAPD_STRNG_CONF_FILE > /dev/console&
	else
		/userfs/bin/wapp > /dev/null &
		sleep 15
		/userfs/bin/p1905_managerd -r0 -f $MAP_CONF -F $MAP_WTS_BSS_INFO_CFG_FILE > /dev/console &
		sleep 5
		/userfs/bin/mapd -G $MAP_WTS_BSS_INFO_CFG_FILE -I $MAPD_CONF -O $MAPD_STRNG_CONF_FILE > /dev/console&
	fi
	

	
