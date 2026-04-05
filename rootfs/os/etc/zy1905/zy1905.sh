#! /bin/bash
# description : IEEE 1905.1 (zy1905) utility script
# author : Benson Lin
# date : Oct 2013

if [ "$1" == "stop" ]; then
	echo "Stop IEEE 1905.1 (zy1905) utility ..."
	touch /tmp/zy1905_stop
elif [ "$1" == "restart" ]; then
	echo "Restart IEEE 1905.1 (zy1905) utility ..."
	touch /tmp/zy1905_restart	
elif [ "$1" == "start" ]; then
	testing=$(ps | grep -w "zy1905" | grep -v "zy1905.sh") 		
	if [ "$testing" != "" ]; then
		echo -e "An \e[1;33;40mactive\e[0m instance of IEEE 1905.1 (zy1905) utility has existed."
		exit
	else
		echo "Start IEEE 1905.1 (zy1905) utility ..."
		/sbin/zy1905 &
	fi
elif [ "$1" == "enableTopol" ]; then
	echo "Enable the IEEE 1905.1 (zy1905) network topology capabilities ..."
	touch /tmp/zy1905_enableTopol	
elif [ "$1" == "disableTopol" ]; then
	echo "Disable the IEEE 1905.1 (zy1905) network topology capabilities ..."
	touch /tmp/zy1905_disableTopol			
elif [ "$1" == "debug" ]; then
	echo "Set debug level to $2 ..."
	touch /tmp/zy1905_debug
	echo "$2" > /tmp/zy1905_debug	
elif [ "$1" == "check" ]; then
	echo "check IEEE 1905.1 (zy1905) utility status(active/inactive) ..."
	testing=$(ps | grep -w "zy1905" | grep -v "zy1905.sh") 		
	if [ "$testing" != "" ]; then
		echo -e "IEEE 1905.1 (zy1905) utility status: \e[1;33;40m(active)\e[0m."		
	else
		echo -e "IEEE 1905.1 (zy1905) utility status: \e[1;33;40m(inactive)\e[0m."
	fi				
else
	echo "Usage: ./zy1905.sh [stop] [restart] [start] [enableTopol] [disableTopol] [debug <debug_level>] [check]"
	echo -e "\n"
	echo "[stop]:"
	echo -e "\tstop IEEE 1905.1 (zy1905) utility."	
	echo "[restart]:"
	echo -e "\trestart IEEE 1905.1 (zy1905) utility."	
	echo "[start]:"
	echo -e "\tstart IEEE 1905.1 (zy1905) utility."	
	echo "[enableTopol]:"
	echo -e "\tenable the IEEE 1905.1 (zy1905) network topology capabilities."	
	echo "[disableTopol]:"
	echo -e "\tdisable the IEEE 1905.1 (zy1905) network topology capabilities."		
	echo "[debug]:"
	echo -e "\tset debug level."	
	echo "<debug_level>:"
	echo -e "\t0 : Critical errors."
    	echo -e "\t1 : Regular errors."; 
    	echo -e "\t2 : Warning messages."  	
    	echo -e "\t4 : Informational messages." 
    	echo -e "\t5 : Debugging messages."    	 	
    	echo "[check]:"
    	echo -e "\tcheck IEEE 1905.1 (zy1905) utility status(active/inactive)."	
    	echo -e "\n"		
fi	