ps -ef | grep systemd.daily

apt-get update
apt-get install git

wget -q -O /etc/openhabian.conf  https://raw.githubusercontent.com/wirelesssolution/capteur/master/openhabian.conf.dist

git clone https://github.com/openhab/openhabian.git /opt/openhabian
ln -s /opt/openhabian/openhabian-setup.sh /usr/local/bin/openhabian-config
/usr/local/bin/openhabian-config unattended

wget -q -O /etc/openhab2/scripts/cron.sh https://raw.githubusercontent.com/wirelesssolution/capteur/master/scripts/cron.sh
sudo /bin/chmod 755 /etc/openhab2/scripts/cron.sh 
cronjob="*/1 * * * * /etc/openhab2/scripts/cron.sh"
(crontab -u root -l; echo "$cronjob" ) | crontab -u root -

wget -q -O /etc/openhab2/services/addons.cfg  https://raw.githubusercontent.com/wirelesssolution/capteur/master/services/addons.cfg

echo "Install MQTT Server"
apt -y --no-install-recommends install mosquitto mosquitto-clients
touch /etc/mosquitto/passwd
mosquitto_passwd -b /etc/mosquitto/passwd mymqtt mymqtt




git clone https://github.com/wirelesssolution/condoconfig.git
cp -R condoconfig/* /etc/openhab2
chown -R openhab:openhab /etc/openhab2
rm -fr condoconfig/

echo "Start OpenHab"
/etc/init.d/openhab2 start
 
 echo "add Samba User "
(echo ciadmin;echo ciadmin) | sudo /usr/bin/smbpasswd  -s -a openhab

clear
sleep 10




echo "change logo size 145x40 pixcel"
scp /etc/openhab2/logo paperui/img/logo

tail -f  /var/log/openhab2/openhab.log




