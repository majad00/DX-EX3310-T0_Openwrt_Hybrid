cp /tmp/quarterHours/last14min /tmp/quarterHours/last15min
cp /tmp/quarterHours/last13min /tmp/quarterHours/last14min
cp /tmp/quarterHours/last12min /tmp/quarterHours/last13min
cp /tmp/quarterHours/last11min /tmp/quarterHours/last12min
cp /tmp/quarterHours/last10min /tmp/quarterHours/last11min
cp /tmp/quarterHours/last9min /tmp/quarterHours/last10min
cp /tmp/quarterHours/last8min /tmp/quarterHours/last9min
cp /tmp/quarterHours/last7min /tmp/quarterHours/last8min
cp /tmp/quarterHours/last6min /tmp/quarterHours/last7min
cp /tmp/quarterHours/last5min /tmp/quarterHours/last6min
cp /tmp/quarterHours/last4min /tmp/quarterHours/last5min
cp /tmp/quarterHours/last3min /tmp/quarterHours/last4min
cp /tmp/quarterHours/last2min /tmp/quarterHours/last3min
cp /tmp/quarterHours/last1min /tmp/quarterHours/last2min

ReceiveBlocks=`grep -wr ReceiveBlock /proc/tc3162/adsl_stas_show | awk '{print $2}'`
TransmitBlocks=`grep -wr TransmitBlock /proc/tc3162/adsl_stas_show | awk '{print $2}'`
CellDelin=`grep -wr CellDelin /proc/tc3162/adsl_stas_show | awk '{print $2}'`
LinkRetrain=`grep -wr LinkRetrain /proc/tc3162/adsl_stas_show | awk '{print $2}'`
InitErrors=`grep -wr InitErrors /proc/tc3162/adsl_stas_show | awk '{print $2}'`
InitTimeouts=`grep -wr InitTimeouts /proc/tc3162/adsl_stas_show | awk '{print $2}'`
LossOfFraming=`grep -wr LossOfFraming /proc/tc3162/adsl_stas_show | awk '{print $2}'`
LOF=`grep -wr LOF /proc/tc3162/adsl_stas_show | awk '{print $2}'`
ErroredSecs=`grep -wr ErroredSecs /proc/tc3162/adsl_stas_show | awk '{print $2}'`
SeverelyErroredSecs=`grep -wr SeverelyErroredSecs /proc/tc3162/adsl_stas_show | awk '{print $2}'`
CRC1=`grep -wr CRC /proc/tc3162/adsl_stas_show | awk 'FNR==1 {print $5}'`
CRC2=`grep -wr CRC /proc/tc3162/adsl_stas_show | awk 'FNR==2 {print $5}'`
CRC3=`grep -wr CRC /proc/tc3162/adsl_stas_show | awk 'FNR==3 {print $5}'`
CRC4=`grep -wr CRC /proc/tc3162/adsl_stas_show | awk 'FNR==4 {print $5}'`
CRCErrors=$(($CRC1+$CRC2+$CRC3+$CRC4))
HEC1=`grep -wr HEC /proc/tc3162/adsl_stas_show | awk 'FNR==1 {print $5}'`
HEC2=`grep -wr HEC /proc/tc3162/adsl_stas_show | awk 'FNR==2 {print $5}'`
HEC3=`grep -wr HEC /proc/tc3162/adsl_stas_show | awk 'FNR==3 {print $5}'`
HEC4=`grep -wr HEC /proc/tc3162/adsl_stas_show | awk 'FNR==4 {print $5}'`
HECErrors=$(($HEC1+$HEC2+$HEC3+$HEC4))
FEC1=`grep -wr FEC /proc/tc3162/adsl_stas_show | awk 'FNR==1 {print $5}'`
FEC2=`grep -wr FEC /proc/tc3162/adsl_stas_show | awk 'FNR==2 {print $5}'`
FEC3=`grep -wr FEC /proc/tc3162/adsl_stas_show | awk 'FNR==3 {print $5}'`
FEC4=`grep -wr FEC /proc/tc3162/adsl_stas_show | awk 'FNR==4 {print $5}'`
FECErrors=$(($FEC1+$FEC2+$FEC3+$FEC4))

echo ReceiveBlocks: $ReceiveBlocks > /tmp/quarterHours/last1min
echo TransmitBlocks: $TransmitBlocks  >> /tmp/quarterHours/last1min
echo CellDelin: $CellDelin >> /tmp/quarterHours/last1min
echo LinkRetrain: $LinkRetrain >> /tmp/quarterHours/last1min
echo InitErrors: $InitErrors >> /tmp/quarterHours/last1min
echo InitTimeouts: $InitTimeouts >> /tmp/quarterHours/last1min
echo LossOfFraming: $LossOfFraming >> /tmp/quarterHours/last1min
echo LOF: $LOF >> /tmp/quarterHours/last1min
echo ErroredSecs: $ErroredSecs >> /tmp/quarterHours/last1min
echo SeverelyErroredSecs: $SeverelyErroredSecs >> /tmp/quarterHours/last1min
echo CRCErrors: $CRCErrors >> /tmp/quarterHours/last1min
echo HECErrors: $HECErrors >> /tmp/quarterHours/last1min
echo FECErrors: $FECErrors >> /tmp/quarterHours/last1min

TH_ReceiveBlocks=`grep -wr ReceiveBlocks /tmp/quarterHours/last15min | awk '{print $2}'`
TH_TransmitBlocks=`grep -wr TransmitBlocks /tmp/quarterHours/last15min | awk '{print $2}'`
TH_CellDelin=`grep -wr CellDelin /tmp/quarterHours/last15min | awk '{print $2}'`
TH_LinkRetrain=`grep -wr LinkRetrain /tmp/quarterHours/last15min | awk '{print $2}'`
TH_InitErrors=`grep -wr InitErrors /tmp/quarterHours/last15min | awk '{print $2}'`
TH_InitTimeouts=`grep -wr InitTimeouts /tmp/quarterHours/last15min | awk '{print $2}'`
TH_LossOfFraming=`grep -wr LossOfFraming /tmp/quarterHours/last15min | awk '{print $2}'`
TH_LOF=`grep -wr LOF /tmp/quarterHours/last15min | awk '{print $2}'`
TH_ErroredSecs=`grep -wr ErroredSecs /tmp/quarterHours/last15min | awk '{print $2}'`
TH_SeverelyErroredSecs=`grep -wr SeverelyErroredSecs /tmp/quarterHours/last15min | awk '{print $2}'`
TH_CRCErrors=`grep -wr CRCErrors /tmp/quarterHours/last15min | awk '{print $2}'`
TH_HECErrors=`grep -wr HECErrors /tmp/quarterHours/last15min | awk '{print $2}'`
TH_FECErrors=`grep -wr FECErrors /tmp/quarterHours/last15min | awk '{print $2}'`

max=0xffffffff
if [ $ReceiveBlocks -ge $TH_ReceiveBlocks ]; then
	QTH_ReceiveBlocks=$(($ReceiveBlocks - $TH_ReceiveBlocks))
else
	cau=$(($max - $TH_ReceiveBlocks))
	QTH_ReceiveBlocks=$(($ReceiveBlocks + $cau))
fi
if [ $TransmitBlocks -ge $TH_TransmitBlocks ]; then
	QTH_TransmitBlocks=$(($TransmitBlocks - $TH_TransmitBlocks))
else
	cau=$(($max - $TH_TransmitBlocks))
	QTH_TransmitBlocks=$(($TransmitBlocks + $cau))
fi
if [ $CellDelin -ge $TH_CellDelin ]; then
	QTH_CellDelin=$(($CellDelin - $TH_CellDelin))
else
	cau=$(($max - $TH_CellDelin))
	QTH_CellDelin=$(($CellDelin + $cau))
fi
if [ $LinkRetrain -ge $TH_LinkRetrain ]; then
	QTH_LinkRetrain=$(($LinkRetrain - $TH_LinkRetrain))
else
	cau=$(($max - $TH_LinkRetrain))
	QTH_LinkRetrain=$(($LinkRetrain + $cau))
fi
if [ $InitErrors -ge $TH_InitErrors ]; then
	QTH_InitErrors=$(($InitErrors - $TH_InitErrors))
else
	cau=$(($max - $TH_InitErrors))
	QTH_InitErrors=$(($InitErrors + $cau))
fi
if [ $InitTimeouts -ge $TH_InitTimeouts ]; then
	QTH_InitTimeouts=$(($InitTimeouts - $TH_InitTimeouts))
else
	cau=$(($max - $TH_InitTimeouts))
	QTH_InitTimeouts=$(($InitTimeouts + $cau))
fi
if [ $LossOfFraming -ge $TH_LossOfFraming ]; then
	QTH_LossOfFraming=$(($LossOfFraming - $TH_LossOfFraming))
else
	cau=$(($max - $TH_LossOfFraming))
	QTH_LossOfFraming=$(($LossOfFraming + $cau))
fi
if [ $LOF -ge $TH_LOF ]; then
	QTH_LOF=$(($LOF - $TH_LOF))
else
	cau=$(($max - $TH_LOF))
	QTH_LOF=$(($LOF + $cau))
fi
if [ $ErroredSecs -ge $TH_ErroredSecs ]; then
	QTH_ErroredSecs=$(($ErroredSecs - $TH_ErroredSecs))
else
	cau=$(($max - $TH_ErroredSecs))
	QTH_ErroredSecs=$(($ErroredSecs + $cau))
fi
if [ $SeverelyErroredSecs -ge $TH_SeverelyErroredSecs ]; then
	QTH_SeverelyErroredSecs=$(($SeverelyErroredSecs - $TH_SeverelyErroredSecs))
else
	cau=$(($max - $TH_SeverelyErroredSecs))
	QTH_SeverelyErroredSecs=$(($SeverelyErroredSecs + $cau))
fi
if [ $CRCErrors -ge $TH_CRCErrors ]; then
	QTH_CRCErrors=$(($CRCErrors - $TH_CRCErrors))
else
	cau=$(($max - $TH_CRCErrors))
	QTH_CRCErrors=$(($CRCErrors + $cau))
fi
if [ $HECErrors -ge $TH_HECErrors ]; then
	QTH_HECErrors=$(($HECErrors - $TH_HECErrors))
else
	cau=$(($max - $TH_HECErrors))
	QTH_HECErrors=$(($HECErrors + $cau))
fi
if [ $FECErrors -ge $TH_FECErrors ]; then
	QTH_FECErrors=$(($FECErrors - $TH_FECErrors))
else
	cau=$(($max - $TH_FECErrors))
	QTH_FECErrors=$(($FECErrors + $cau))
fi

echo ReceiveBlocks: $QTH_ReceiveBlocks > /tmp/quarterHours/totalin15mins
echo TransmitBlocks: $QTH_TransmitBlocks  >> /tmp/quarterHours/totalin15mins
echo CellDelin: $QTH_CellDelin >> /tmp/quarterHours/totalin15mins
echo LinkRetrain: $QTH_LinkRetrain >> /tmp/quarterHours/totalin15mins
echo InitErrors: $QTH_InitErrors >> /tmp/quarterHours/totalin15mins
echo InitTimeouts: $QTH_InitTimeouts >> /tmp/quarterHours/totalin15mins
echo LossOfFraming: $QTH_LossOfFraming >> /tmp/quarterHours/totalin15mins
echo LOF: $QTH_LOF >> /tmp/quarterHours/totalin15mins
echo ErroredSecs: $QTH_ErroredSecs >> /tmp/quarterHours/totalin15mins
echo SeverelyErroredSecs: $QTH_SeverelyErroredSecs >> /tmp/quarterHours/totalin15mins
echo CRCErrors: $QTH_CRCErrors >> /tmp/quarterHours/totalin15mins
echo HECErrors: $QTH_HECErrors >> /tmp/quarterHours/totalin15mins
echo FECErrors: $QTH_FECErrors >> /tmp/quarterHours/totalin15mins

