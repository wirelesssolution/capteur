#!/bin/bash
#
# Edit rc.local By default this script does nothing.
# bash /opt/boot.sh
# exit 0
echo "Seting IP"
LIP="$(/sbin/ifconfig eth0|awk '/inet addr/ {split ($2,A,":"); print A[2]}'  | sed '$s/\w*$//' )"
ip=$LIP'222'
echo $ip
fping -c1 -t300 $ip 2>/dev/null 1>/dev/null
if [ "$?" = 0 ]
then
	echo "Found" 
else
	echo "Not Found" 
	ip4=$(/sbin/ifconfig eth0:0 $ip netmask 255.255.255.0 up)
#	sudo find /var/log/ -type f -regex '.*\.[0-9]+\.gz$' -delete
#	MAC="$(cat /sys/class/net/eth0/address  | sed 's/[:]//g')"
# 	echo "String ulinealert \"User Line Alert\" <light>" > /etc/openhab2/items/linealert.items
#	echo "{mqtt=\">[track:/ci/smarthome/linealert/u/"$MAC"/alert:command:*:default]\"}"  >> /etc/openhab2/items/linealert.items
fi


						    #echo 0 > /sys/class/leds/green_led/brightness
						    #until wget -S --spider http://localhost:8080 2>&1 | grep -q 'HTTP/1.1 200 OK'; do
						    #sleep 1
						    #echo 0 > /sys/class/leds/green_led/brightness
						    #done
						    #echo 255 > /sys/class/leds/green_led/brightness
						    #echo "OK"
						    #rm -f /var/log/openhab2/*.1
						    #rm -f /var/log/*.[1-9]*
						    #chown openhab:openhab -R /opt/capteur/
						    #chown openhab:openhab -R /var/log/openhab2/
exit 0
