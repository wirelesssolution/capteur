#/bin/sh
ip4=$(/sbin/ifconfig | awk '/inet addr:192/{print substr($2,6)}' | cut -f3  -d'.' | sed '1q')
echo $ip4
ip='192.168.'$ip4'.222'
echo $ip
fping -c1 -t300 $ip 2>/dev/null 1>/dev/null
if [ "$?" = 0 ]
then
echo "Found" 
else
echo "Not Found" 
ip4=$(/sbin/ifconfig eth0:0 192.168.$ip4.222 netmask 255.255.255.0 up)
fi
#echo 0 > /sys/class/leds/green_led/brightness
#until wget -S --spider http://localhost:8080 2>&1 | grep -q 'HTTP/1.1 200 OK'; do
#sleep 1
#echo 0 > /sys/class/leds/green_led/brightness
#done
#echo 255 > /sys/class/leds/green_led/brightness
#echo "OK"
rm -f /var/log/openhab2/*.1
rm -f /var/log/*.[1-9]*
