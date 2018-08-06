#/bin/sh
#
# Edit rc.local By default this script does nothing.
# bash /opt/boot.sh
# exit 0

echo "Seting IP"
local_ip_value=$(ifconfig eth0|awk '/inet addr/ {split ($2,A,":"); print A[2]}'  | sed '$s/\w*$//' )
new_ip_value=$local_ip_value'222'
sudo /sbin/ifconfig eth0:0 $new_ip_value netmask 255.255.255.0 up
if [ -f /root/fstab ]; then
            echo "File found!"
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
