#!/bin/sh

# Copyright (C) ZyXEL Communications, Corp. All Rights Reserved.

# $1: 1 is huawei(^)
# $2: CMD (ex: CPIN?)
# $3: device (ex: /dev/ttyUSB0)

#set -x

# Environment Variables
#WWANPATH=/sbin  # set the WWAN directory path #~!@#$%^&*()_+

if [ "$1" = "1" ]; then
	operation="\^"
else
	operation="+"
fi

chat -V -s TIMEOUT 1 "" "AT$operation$2" "OK" "" < $3 > $3

exit
