#!/bin/sh

ZYEE_PATH=/misc/modsw/tr157du/zyee

case "$1" in
    start)
        echo "starting ZYEE support ..."
        # mount mtd11:misc1 to /misc1 with ubifs. should move to sysinit?!
#        ubiattach -m 11
#        sleep 1
#        ubimkvol /dev/ubi1 --name=misc1 --type=dynamic --maxavsize
#        sleep 1
#        mount -t ubifs ubi1:misc1 /misc1
#        sleep 1
        
        if [ ! -d $ZYEE_PATH ] ; then
            mkdir -p $ZYEE_PATH
        fi
        
        for d in $(ls $ZYEE_PATH) ; do
            mkdir -p /var/lib/lxc/$d
            cp $ZYEE_PATH/$d/lxc.conf /var/lib/lxc/$d/config
        done
        exit 0
        ;;

    *)
        echo "$0: unrecognized option $1"
        exit 1
        ;;

esac
