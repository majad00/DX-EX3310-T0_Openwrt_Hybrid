#!/bin/sh

#internet led module install
KERNELVER=`uname -r`

test -e /lib/modules/$KERNELVER/zyinetled.ko && insmod /lib/modules/$KERNELVER/zyinetled.ko

