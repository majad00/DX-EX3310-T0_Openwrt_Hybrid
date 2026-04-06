#!/bin/sh
#Platform: MTK/Econet (MTK_EVA).
#Script Name: zyims.sh
#Script Version: v1.0.4.
#Script History:
#
#  v1.0.0: Initial/first version.
#
#  v1.0.2: (2015.10.27, Tue.)
#    (a)Support to generate the Core Dump (CoreDump) file while Crashing by being bringed-up under the 'unlimited' result condition of the command "ulimit -c" (which is for configuring the Core File Size of the system).
#
#  v1.0.3: (2015.12.22, Tue.)
#    (a)Enhance the Core Dump (CoreDump) file generation function:
#       (i)Correct the Environment Variable format - WRONG:"$(oldUlimit)" ===> CORRECT:$oldUlimit.
#       (ii)Skip to Restore the (original) Core Dump file's filename format.
#
#  v1.0.4: (2018.10.23, Tue.)
#    (a)Enhance the Core Dump (CoreDump) file generation function.
#       (i)Change the default Core Dump file generation path/directory from "/data/" ==(to)==> "/tmp/", which is defined by the Environment Variable '$COREDUMP_PATH'.
#       (ii)Improve the related debug message(s).
#

NAME="ZyIMS VoIP"
#----------
COREDUMP_PATH="/tmp"
#----------


start()
{
    #chrt -f 95 icf.exe /usr/bin/icf.cfg >/dev/console 2>/dev/console &
    #chrt -f 95 icf.exe >/dev/console 2>/dev/console &
    #chrt -f 95 mm.exe >/dev/console 2>/dev/console &
    #chrt -f 95 voiceApp >/dev/console 2>/dev/console &
	icf.exe /var/icf.cfg >/dev/console 2>/dev/console &
	mm.exe >/dev/console 2>/dev/console &
	voiceApp >/dev/console 2>/dev/console &
}

start_with_inter_module_delay_start()
{
    #chrt -f 95 icf.exe /usr/bin/icf.cfg >/dev/console 2>/dev/console &
    #chrt -f 95 icf.exe >/dev/console 2>/dev/console &
	icf.exe /var/icf.cfg >/dev/console 2>/dev/console &
    sleep 3
    #chrt -f 95 mm.exe >/dev/console 2>/dev/console &
	mm.exe >/dev/console 2>/dev/console &
    sleep 1
    #chrt -f 95 voiceApp >/dev/console 2>/dev/console &
	voiceApp >/dev/console 2>/dev/console &
}

stop9()
{
    killall -9 voiceApp
    killall -9 mm.exe
    killall -9 icf.exe
    #rm iptk_es.chanl >/dev/null 2>/dev/null
}

stop15()
{
    killall -15 voiceApp
    killall -15 mm.exe
    killall -15 icf.exe
    #rm iptk_es.chanl >/dev/null 2>/dev/null
}

restart9()
{
    stop9
    sleep 2
    start
}

restart15()
{
    stop15
    sleep 2
    start
}


#Backup the original CoreDump setting and change it to 'unlimited' for ZyIMS VoIP supportting to generate the CoreDump file while Crashing.
oldUlimit=`ulimit -c`
ulimit -c unlimited
echo "$COREDUMP_PATH/core.%e.%p.%h.%t" > /proc/sys/kernel/core_pattern

case "$1" in
    start)
             echo "Starting $NAME"
             start
             ;;
    start2)
             echo "Starting $NAME with inter-module delay start"
             start_with_inter_module_delay_start
             ;;
    stop)
             echo "Stopping $NAME"
             stop15
             ;;

    stop9)
             echo "Stopping $NAME by SIGKILL(9)"
             stop9
             ;;

    stop15)
             echo "Stopping $NAME by SIGTERM(15)"
             stop15
             ;;

    restart)
             echo "Restarting $NAME"
             restart15
             ;;

    restart9)
             echo "Restarting $NAME by SIGKILL(9) to stop"
             restart9
             ;;

    restart15)
             echo "Restarting $NAME by SIGTERM(15) to stop"
             restart15
             ;;

    *)
        echo "Usage: $0 {start|stop|restart}" >&2
        exit 1
        ;;
esac

#Restore the original CoreDump setting before leaving.
ulimit -c $oldUlimit

exit 0
