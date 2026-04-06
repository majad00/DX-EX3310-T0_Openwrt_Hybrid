#!/bin/sh

case "$1" in
	start)
		echo ">>>>> Fake mount mtd misc successful! <<<<<"
		exit 0
		;;
	stop)
		exit 0
		;;
	*)
		exit 0
		;;
esac