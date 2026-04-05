dmzEbtables=`ebtables -t filter -L DMZ`
if [ "$dmzEbtables" == "" ]; then
  ebtables -t filter -N DMZ -P RETURN
  ebtables -t filter -I FORWARD 1 -j DMZ
fi
ebtables -t filter -F DMZ
dmz=`cfg nat_conf get | grep 'Default Server Address' | awk '{print $5}'`
if [ "$dmz" != "" ] && [ "$dmz" != "0.0.0.0" ]; then
  ip -s -s neigh flush all
  ping "$dmz" -w 10 > /dev/null
  dmzMac=`arp -a | grep "$dmz" | awk '{print $4}'`
  if [ "$dmzMac" != "" ]; then
    br=`ip route get "$dmz" | grep 'br' | awk '{print $3}'`
    gw=`ip route get "$dmz" | grep 'br' | awk '{print $5}'`
    subnet=`ip -o -f inet addr show | grep "$br" | awk '{print $4}'`
    if [ "$gw" != "" ] && [ "$subnet" != "" ]; then
      ebtables -t filter -A DMZ -p IPv4 --ip-src "$subnet" --ip-dst "$gw" -j RETURN
      ebtables -t filter -A DMZ -p IPv4 --ip-src "$gw" --ip-dst "$subnet" -j RETURN
      ebtables -t filter -A DMZ -p IPv4 --ip-src "$subnet" --ip-dst "$dmz" -j DROP
      ebtables -t filter -A DMZ -p IPv4 --ip-src "$dmz" --ip-dst "$subnet" -j DROP
    fi
    dmzPort=`brctl showmacs "$br" | grep "$dmzMac" | awk '{print $5}'`
    if [ "$dmzPort" == "eth0.1" ]; then
      /userfs/bin/ethphxcmd gsww2 0 0x2304 0x00f80000
      /userfs/bin/ethphxcmd gsww2 0 0x2204 0x00f70000
      /userfs/bin/ethphxcmd gsww2 0 0x2104 0x00f70000
      /userfs/bin/ethphxcmd gsww2 0 0x2004 0x00f70000
      exit 0
    elif [ "$dmzPort" == "eth0.2" ]; then
      /userfs/bin/ethphxcmd gsww2 0 0x2304 0x00fb0000
      /userfs/bin/ethphxcmd gsww2 0 0x2204 0x00f40000
      /userfs/bin/ethphxcmd gsww2 0 0x2104 0x00fb0000
      /userfs/bin/ethphxcmd gsww2 0 0x2004 0x00fb0000
      exit 0
    elif [ "$dmzPort" == "eth0.3" ]; then
      /userfs/bin/ethphxcmd gsww2 0 0x2304 0x00fd0000
      /userfs/bin/ethphxcmd gsww2 0 0x2204 0x00fd0000
      /userfs/bin/ethphxcmd gsww2 0 0x2104 0x00f20000
      /userfs/bin/ethphxcmd gsww2 0 0x2004 0x00fd0000
      exit 0
    elif [ "$dmzPort" == "eth0.4" ]; then
      /userfs/bin/ethphxcmd gsww2 0 0x2304 0x00fe0000
      /userfs/bin/ethphxcmd gsww2 0 0x2204 0x00fe0000
      /userfs/bin/ethphxcmd gsww2 0 0x2104 0x00fe0000
      /userfs/bin/ethphxcmd gsww2 0 0x2004 0x00f10000
      exit 0
    fi
  fi
fi
/userfs/bin/ethphxcmd gsww2 0 0x2304 0x00ff0003
/userfs/bin/ethphxcmd gsww2 0 0x2204 0x00ff0003
/userfs/bin/ethphxcmd gsww2 0 0x2104 0x00ff0003
/userfs/bin/ethphxcmd gsww2 0 0x2004 0x00ff0003
ebtables -t filter -F DMZ
exit 0
