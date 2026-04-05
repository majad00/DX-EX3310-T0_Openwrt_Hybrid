#!/bin/sh

# Copyright (C) ZyXEL Communications, Corp. All Rights Reserved.

# $1: device number
# $2: VID
# $3: PID

#set -x

# Environment Variables
#WWANPATH=/sbin  # set the WWAN directory path #~!@#$%^&*()_+

. $WWANPATH/wwan-lib.sh

wwan_log "[$0] enter"

DEVICE_NUMBER=$1
VID=$2
PID=$3
if [ "$DEVICE_NUMBER" = "" -o "$VID" = "" -o "$PID" = "" ]; then
	wwan_log "[$0] DEVICE_NUMBER=$DEVICE_NUMBER, VID=$VID, PID=$PID; can't find DEVICE_NUMBER or VID or PID"
	exit
fi

DEVICE_ID=$DEVICE_NUMBER:$VID:$PID
DEVICE_DIR=$DATAPATH/$DEVICE_DATA_PRENAME:$DEVICE_ID
if ! [ -e "$DEVICE_DIR" ]; then
	wwan_log "[$0] can't find DEVICE_DIR $DEVICE_DIR, exit"
	exit
fi

DEVICE_INIT_FILE=$DEVICE_DIR/$DEVICE_INIT_NAME
INIT_STATUS=`cat $DEVICE_INIT_FILE`
if [ "$INIT_STATUS" != "INIT_READY" ]; then
	wwan_log "[$0] INIT is not READY, connection up case interrupt, exit"
	exit
fi

wwan_log "[$0] pppd file $DEVICE_DIR/$DEVICE_PPP_3G_NAME &"
pppd file $DEVICE_DIR/$DEVICE_PPP_3G_NAME &
#pppd /dev/ttyUSB0 modem nodetach persist holdoff 1 pppname pppoWWAN0 connect "chat -v -f $DEVICE_DIR/ppp_tty_chat" &

#wwan_log "[$0] run pppd /dev/ttyUSB0 modem nodetach noauth noipdefault defaultroute usepeerdns crtscts lock debug maxfail 10 persist holdoff 1 pppname pppoWWAN1 connect \"chat -v -f $DEVICE_DIR/ppp_tty_chat\" &"
#pppd /dev/ttyUSB0 modem usepeerdns user password persist holdoff 1 lcp-echo-interval 10 lcp-echo-failure 2 pppname pppoWWAN0 connect "chat -v -f $DEVICE_DIR/ppp_tty_chat" &
#wwan_log "[$0] run pppd /dev/ttyUSB0 modem nodetach noauth noipdefault defaultroute usepeerdns crtscts lock debug maxfail 10 persist holdoff 1 pppname pppoWWAN1 connect \"chat -v -f $DEVICE_DIR/ppp_tty_chat\" &"
#pppd /dev/ttyUSB0 modem nodetach noauth noipdefault defaultroute usepeerdns crtscts lock debug maxfail 10 persist holdoff 1 pppname pppoWWAN1 connect "chat -v \'\' ATZ OK AT+CGDCONT=1,\'IP\',\'internet\' OK ATDT*99# CONNECT \'\'" &

#wwan_log "[$0] run pppd /dev/ttyUSB0 modem usepeerdns persist user password holdoff 1 lcp-echo-interval 10 lcp-echo-failure 2 linkname pppd5566 pppname pppoWWAN0 connect \"chat -v -f $DEVICE_DIR/ppp_tty_chat\" &"
#pppd /dev/ttyUSB0 modem usepeerdns persist user password holdoff 1 lcp-echo-interval 10 lcp-echo-failure 2 linkname pppd5566 pppname pppoWWAN0 connect "chat -v -f $DEVICE_DIR/ppp_tty_chat" &

#wwan_log "[$0] run pppd /dev/ttyUSB0 modem persist holdoff 1 linkname pppd5566 pppname pppoWWAN0 connect \"chat -v -f $DEVICE_DIR/ppp_tty_chat\" &"
#pppd /dev/ttyUSB0 modem persist holdoff 1 linkname pppd5566 pppname pppoWWAN0 connect "chat -v -f $DEVICE_DIR/ppp_tty_chat" &

DEVICE_CONN_FILE=$DEVICE_DIR/$DEVICE_CONN_NAME
DEVICE_PPP_PID_FILE=$DEVICE_DIR/$DEVICE_PPP_PID_NAME
echo "$!" > $DEVICE_PPP_PID_FILE
echo "UP" > $DEVICE_CONN_FILE
wwan_log "[$0] connection up done, exit"
#exit
