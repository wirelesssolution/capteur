#####
##### CREATE SD CARD 
#####
###  curl -s https://raw.githubusercontent.com/wirelesssolution/capteur/master/setup.bash | bash /dev/stdin arg1 arg2
####
####

ps -ef | grep systemd.daily

apt-get update

echo -n " Install GIT... "
apt-get install git

echo -n " Download openhabian.conf... "
wget -q -O /etc/openhabian.conf  https://raw.githubusercontent.com/wirelesssolution/capteur/master/openhabian.conf.dist
echo -n " Download Log file cleaning... "
wget -q -O /opt/log-file-cleaning  https://raw.githubusercontent.com/SixArm/log-file-cleaning/master/log-file-cleaning
chmod 755 /opt/log-file-cleaning

git clone https://github.com/openhab/openhabian.git /opt/openhabian
ln -s /opt/openhabian/openhabian-setup.sh /usr/local/bin/openhabian-config
/usr/local/bin/openhabian-config unattended


cd /root
wget https://github.com/wirelesssolution/capteur/blob/master/Java/local_policy.jar
wget https://github.com/wirelesssolution/capteur/blob/master/Java/US_export_policy.jar
cp *jar /usr/lib/jvm/zulu-embedded-8-armhf/jre/lib/security
cp *jar /usr/lib/jvm/zulu-embedded-8-armhf/lib

echo -n "Download Cron.sh  under /opt/capteur/cron.sh/ and install cron config at /etc/cron.d ... "
wget -q -O /etc/cron.d/capteur_cron  https://raw.githubusercontent.com/wirelesssolution/capteur/master/cron.d/capteur
wget -q -O /opt/boot.sh  https://raw.githubusercontent.com/wirelesssolution/capteur/master/cron.d/boot.sh
/bin/chmod 755 /opt/boot.sh


echo -n "Install MQTT SERVER... "
apt -y --no-install-recommends install mosquitto mosquitto-clients
touch /etc/mosquitto/passwd
mosquitto_passwd -b /etc/mosquitto/passwd mymqtt mymqtt

echo -n "Preparing interface config... "
sed -i "/boot/d" /etc/rc.local
sed -i "/exit/d" /etc/rc.local
sed -i "\#^$#d" /etc/rc.local
  (
    echo ""
    echo "/opt/boot.sh"
    echo "exit 0"
  ) >> /etc/rc.local
cat /etc/rc.local

echo -n "Preparing clean fstab ... "
sed -i "\#[ \t]/srv/openhab2-#d" /etc/fstab
sed -i "\#[ \t]/opt/capteur/capteur-#d" /etc/fstab
sed -i "\#^$#d" /etc/fstab
  (
    echo ""
    echo "#/var/lib/openhab2            /opt/capteur/capteur-userdata      none bind 0 0"
    echo "#/etc/openhab2                /opt/capteur/capteur-conf          none bind 0 0"
    echo "#/var/log/openhab2            /opt/capteur/capteur-logs          none bind 0 0"
  ) >> /etc/fstab
cat /etc/fstab

#wget -q -O /root/fstab  https://raw.githubusercontent.com/wirelesssolution/capteur/master/fstab
#chmod 755 /root/fstab
#mkdir -p /opt/capteur/capteur-{conf,userdata,logs}
#mount --all --verbose

git clone https://github.com/wirelesssolution/config.git
cp -R config/* /etc/openhab2
chown -R openhab:openhab /etc/openhab2
rm -fr config/


rm -fr /var/log/openhab2/
mkdir /opt/openhab2
cd /var/log/
ln -s /opt/openhab2 openhab2
chown -R openhab:openhab  /opt/openhab2
chown -R openhab:openhab  /var/log/openhab2
chown -R openhab:openhab  /etc/openhab2/

crontab remove log file
0 1 * * *	/usr/bin/find /var/log/ -type f -regex '.*\.[0-9]+\.gz$' -delete
0 1 * * *	/usr/bin/find /opt/ -type f -regex '.*\.[0-9]$' -delete





 
 
wget -q -O /etc/openhab2/services/addons.cfg  https://raw.githubusercontent.com/wirelesssolution/capteur/master/services/addons.cfg
wget -q -O /etc/openhab2/services/openhabcloud.cfg https://raw.githubusercontent.com/wirelesssolution/capteur/master/openhabcloud.cfg
wget -q -O /etc/openhab2/things/demo.things https://raw.githubusercontent.com/wirelesssolution/capteur/master/demo.things

chown openhab:openhab /var/log/openhab2/
chown openhab:openhab /srv/*

echo "Start OpenHab"
/etc/init.d/openhab2 start
 
#echo "add Samba User "
#(echo ciadmin;echo ciadmin) | sudo /usr/bin/smbpasswd  -s -a openhab
#wget -q -O /etc/samba/smb.conf https://raw.githubusercontent.com/wirelesssolution/capteur/master/smb.conf
#/etc/init.d/samba restart

echo -n "Install FTP server share under /opt/capteur/... "
apt-get install pure-ftpd -y
(echo ciadmin;echo ciadmin) | pure-pw useradd config -u openhab -g openhab -d /etc/openhab2 -m
(echo ciadmin;echo ciadmin) | pure-pw useradd userdata -u openhab -g openhab -d /var/lib/openhab2 -m
pure-pw mkdb
ln -s /etc/pure-ftpd/conf/PureDB /etc/pure-ftpd/auth/60puredb
service pure-ftpd restart

apt-get remove samba -y

apt install npm -y
echo "User command to check IR gateway miio discover"
npm install -g miio
npm install -g macaddress
npm install -g fs

wget -q -O /usr/lib/node_modules/miio/cli/commands/mac.js https://raw.githubusercontent.com/wirelesssolution/capteur/master/nodejs/mac.js
wget -q -O /usr/lib/node_modules/miio/cli/commands/remote.js https://raw.githubusercontent.com/wirelesssolution/capteur/master/nodejs/remote.js

# /usr/lib/node_modules/miio/cli/commands/mac.js remote.js
# copy file mac.js remote.js
#

apt-get install avahi-utils -y
echo -n "Download mosquitto.service to support auto reconfig... "
wget -q -O /etc/avahi/services/mosquitto.service  https://raw.githubusercontent.com/wirelesssolution/capteur/master/mosquitto.service



/etc/init.d/avahi-daemon restart


wget https://raw.githubusercontent.com/Angristan/nginx-autoinstall/master/nginx-autoinstall.sh
chmod +x nginx-autoinstall.sh
./nginx-autoinstall.sh
#
#  Install WEB front page
#
get -q -O /etc/nginx/sites-enabled/openhab.conf https://raw.githubusercontent.com/wirelesssolution/capteur/master/nginx/openhab.conf


get -q -O /usr/lib/node_modules/frontail/preset/openhab.json https://raw.githubusercontent.com/wirelesssolution/capteur/master/logviewer/openhab.json

# vi /etc/nginx/.htpasswd
# key capteur:$apr1$P6R8ZlxX$nVZFkrFXaXzO0rZnp4VuC0


sleep 10
clear
echo "SD CARD READY !!!!"
echo "RUN /root/install.sh flash to Controller Box"
echo " "
echo " "

# Remove UUID / Secret
tail -F /var/log/openhab2/openhab.log /var/log/openhab2/events.log
#
#
# Backup config to cloud
#
# curl https://rclone.org/install.sh | sudo bash
# NEW BACKUPCONFIG.WSA.CLOUD
# user config
# password ciadmin
# /home/ftp/capteur/customer
#
apt-get install ftp
mdkir /opt/backup
/opt/dailybackup.sh 

Download IP camera
http://www.pcmus.com/openhab/IpCameraBinding/ipcamera-15-08-2018.zip
mv org.openhab.binding.ipcamera-2.3.0-SNAPSHOT.jar /usr/share/openhab2/addons/

for bluetooeh
apt install blueman

find / -uid 1023 -exec chown root:root {} +
chown -R openhab:openhab /var/log/openhab2/
chown -R openhab:openhab /usr/share/openhab2/
chown -R openhab:openhab /etc/openhab2/
# Disable log2ram
# systemctl stop rsyslog.service
# systemctl stop syslog.socket
# lsof /var/log
#(make sure it's empty)
# systemctl stop log2ram
# systemctl disable log2ram
# mv /var/log /var/oldlog
# rsync -avPHAXx /var/oldlog /var/log
# reboot

#edit /etc/rsyslog.d/50-default.conf
#disable all syslog

#install WIFI Access Point
sudo apt-get update
sudo apt-get install hostapd isc-dhcp-server
vi /etc/dhcp/dhcpd.conf
#option domain-name "example.org";
#option domain-name-servers ns1.example.org, ns2.example.org;
authoritative;
#add 
subnet 192.168.42.0 netmask 255.255.255.0 {
	range 192.168.42.10 192.168.42.50;
	option broadcast-address 192.168.42.255;
	option routers 192.168.42.1;
	default-lease-time 600;
	max-lease-time 7200;
	option domain-name "local";
	option domain-name-servers 8.8.8.8, 8.8.4.4;
}
and save
vi /etc/default/isc-dhcp-server
INTERFACES="wlan0"
vi /etc/network/interface
iface wlan0 inet static
  address 192.168.42.1
  netmask 255.255.255.0

vi /etc/rc.local
/sbin/ifconfig wlan0 192.168.42.1

rm /var/lib/openhab2/uuid
rm /var/lib/openhab2/openhabcloud/secret


vi /etc/openhab2/wifi/wifi.conf
# Basic configuration
ssid=CAPTEUR_AP
wpa_passphrase=ci12345678
#
interface=wlan0
driver=nl80211
hw_mode=g
# WPA and WPA2 configuration
channel=6
macaddr_acl=0
auth_algs=1
ignore_broadcast_ssid=0
wpa=2

wpa_key_mgmt=WPA-PSK
wpa_pairwise=TKIP
wpa_group_rekey=86400
ieee80211n=1
wme_enabled=1
#rsn_pairwise=CCMP TKIP

vi /etc/default/hostapd
DAEMON_CONF="/etc/openhab2/wifi/wifi.conf"
vi  /etc/sysctl.conf
net.ipv4.ip_forward=1
sudo sh -c "echo 1 > /proc/sys/net/ipv4/ip_forward"
sudo /usr/sbin/hostapd /etc/openhab2/wifi/wifi.conf

## add install file
find / -uid 1023 -exec chown root:root {} +
rm /var/lib/openhab2/uuid
rm /var/lib/openhab2/openhabcloud/secret
chown -R openhab:openhab /var/log/openhab2/
chown -R openhab:openhab /usr/share/openhab2/
chown -R openhab:openhab /etc/openhab2/

### setup script to replace all config
find ./ -type f -exec sed -i 's/CAPTEUR_XXXXXX/CAPTEUR_XXXXX1/g' {} \;

