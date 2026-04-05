if [ ! -e /tmp/quarterHours/last1min ]; then
	mkdir /tmp/quarterHours

	touch /tmp/quarterHours/last1min
	echo ReceiveBlocks: 0 > /tmp/quarterHours/last1min
	echo TransmitBlocks: 0  >> /tmp/quarterHours/last1min
	echo CellDelin: 0 >> /tmp/quarterHours/last1min
	echo LinkRetrain: 0 >> /tmp/quarterHours/last1min
	echo InitErrors: 0 >> /tmp/quarterHours/last1min
	echo InitTimeouts: 0 >> /tmp/quarterHours/last1min
	echo LossOfFraming: 0 >> /tmp/quarterHours/last1min
	echo LOF: 0 >> /tmp/quarterHours/last1min
	echo ErroredSecs: 0 >> /tmp/quarterHours/last1min
	echo SeverelyErroredSecs: 0 >> /tmp/quarterHours/last1min
	echo CRCErrors: 0 >> /tmp/quarterHours/last1min
	echo HECErrors: 0 >> /tmp/quarterHours/last1min
	echo FECErrors: 0 >> /tmp/quarterHours/last1min

	cp /tmp/quarterHours/last1min /tmp/quarterHours/last2min
	cp /tmp/quarterHours/last1min  /tmp/quarterHours/last3min
	cp /tmp/quarterHours/last1min  /tmp/quarterHours/last4min
	cp /tmp/quarterHours/last1min  /tmp/quarterHours/last5min
	cp /tmp/quarterHours/last1min  /tmp/quarterHours/last6min
	cp /tmp/quarterHours/last1min  /tmp/quarterHours/last7min
	cp /tmp/quarterHours/last1min  /tmp/quarterHours/last8min
	cp /tmp/quarterHours/last1min  /tmp/quarterHours/last9min
	cp /tmp/quarterHours/last1min  /tmp/quarterHours/last10min
	cp /tmp/quarterHours/last1min  /tmp/quarterHours/last11min
	cp /tmp/quarterHours/last1min  /tmp/quarterHours/last12min
	cp /tmp/quarterHours/last1min  /tmp/quarterHours/last13min
	cp /tmp/quarterHours/last1min  /tmp/quarterHours/last14min
	cp /tmp/quarterHours/last1min  /tmp/quarterHours/last15min
fi
