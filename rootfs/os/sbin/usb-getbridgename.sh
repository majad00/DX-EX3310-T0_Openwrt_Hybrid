#/bin/sh

FindBridge() {
	find_dev=$1
	brctl show | while read line; do {
		case "$line" in
			"bridge name"*) ;;	# ignore headline
			*)
				set $line
				NF=$#
				if [ $NF == 4 ]; then
					brdev="$4"
					bridge="$1"
				elif [ $NF == 1 ]; then
					brdev="$1"
				else 
					continue
				fi

				if [ "$find_dev" == "$brdev" ]; then
					echo $bridge
					break
				fi
			;;
		esac
	} done
}

bridge=$(FindBridge $1)
echo -n $bridge