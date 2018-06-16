ps -ef | grep systemd.daily

apt-get update

apt-get install git
apt-get install avahi-utils

wget -q -O /etc/openhabian.conf  https://raw.githubusercontent.com/wirelesssolution/capteur/master/openhabian.conf.dist
wget -q -O /etc/avahi/services/mosquitto.service  https://raw.githubusercontent.com/wirelesssolution/capteur/master/mosquitto.service

git clone https://github.com/openhab/openhabian.git /opt/openhabian
ln -s /opt/openhabian/openhabian-setup.sh /usr/local/bin/openhabian-config
/usr/local/bin/openhabian-config unattended

wget -q -O /srv/cron.sh  https://raw.githubusercontent.com/wirelesssolution/capteur/master/scripts/cron.sh
sudo /bin/chmod 755 /srv/cron.sh
cronjob="*/1 * * * * /srv/cron.sh  >/dev/null 2>&1"
(crontab -u root -l; echo "$cronjob" ) | crontab -u root -



echo "Install MQTT Server"
apt -y --no-install-recommends install mosquitto mosquitto-clients
touch /etc/mosquitto/passwd
mosquitto_passwd -b /etc/mosquitto/passwd mymqtt mymqtt




git clone https://github.com/wirelesssolution/condoconfig.git
cp -R condoconfig/* /etc/openhab2
chown -R openhab:openhab /etc/openhab2
rm -fr condoconfig/

 
wget -q -O /etc/openhab2/services/addons.cfg  https://raw.githubusercontent.com/wirelesssolution/capteur/master/services/addons.cfg
wget -q -O /etc/openhab2/services/openhabcloud.cfg https://raw.githubusercontent.com/wirelesssolution/capteur/master/openhabcloud.cfg
wget -q -O /etc/openhab2/things/demo.things https://raw.githubusercontent.com/wirelesssolution/capteur/master/demo.things

chown openhab:openhab /var/log/openhab2/
chown openhab:openhab /srv/*

echo "Start OpenHab"
/etc/init.d/openhab2 start
 
echo "add Samba User "
(echo ciadmin;echo ciadmin) | sudo /usr/bin/smbpasswd  -s -a openhab
wget -q -O /etc/samba/smb.conf https://raw.githubusercontent.com/wirelesssolution/capteur/master/smb.conf
/etc/init.d/samba restart

echo "Install FTP Server "
sudo apt-get install pure-ftpd
sudo pure-pw useradd capteur -u openhab -g openhab -d /srv -m
sudo pure-pw mkdb
sudo ln -s /etc/pure-ftpd/conf/PureDB /etc/pure-ftpd/auth/60puredb
sudo service pure-ftpd restart

npm install -g miio
echo "User command to check IR gateway miio discover"

sleep 10
clear
tail -F /var/log/openhab2/openhab.log /var/log/openhab2/events.log



