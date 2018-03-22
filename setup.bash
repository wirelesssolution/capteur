ps -ef | grep systemd.daily

apt-get update
apt-get install git

wget -q -O /etc/openhabian.conf  https://raw.githubusercontent.com/wirelesssolution/condoconfig/master/openhabian.conf.dist


git clone https://github.com/openhab/openhabian.git /opt/openhabian
ln -s /opt/openhabian/openhabian-setup.sh /usr/local/bin/openhabian-config
/usr/local/bin/openhabian-config unattended

wget -q -O /etc/openhab2/scripts/cron.sh https://raw.githubusercontent.com/wirelesssolution/condoconfig/master/scripts/cron.sh
sudo /bin/chmod 755 /etc/openhab2/scripts/cron.sh 
cronjob="*/1 * * * * /etc/openhab2/scripts/cron.sh"
(crontab -u root -l; echo "$cronjob" ) | crontab -u root -

wget -q -O /etc/openhab2/services/addons.cfg  https://raw.githubusercontent.com/wirelesssolution/condoconfig/master/services/addons.cfg

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
 
cls

cd /etc/openhab2/services
echo "UUID"
cat 	/var/lib/openhab2/uuid
ln -s /var/lib/openhab2/uuid
echo "Secret"
cat /var/lib/openhab2/openhabcloud/secret
ln -s /var/lib/openhab2/openhabcloud/secret


echo "change logo size 145x40 pixcel"
scp /etc/openhab2/logo paperui/img/logo

echo "get uuid"
curl -X GET --header "Accept: text/plain" "http://192.168.0.222:8080/rest/uuid"


echo "Todo List - chmod a+w /var/lib/openhab2/jsondb/homekit.json "
echo "Config Openhab RUN /usr/local/bin/openhabian-config"
echo "Done - HOMEKIT 031-45-154."
echo "set samba password "
sudo /usr/bin/smbpasswd  openhab
(echo wsaadmin; echo wsaadmin) | sudo /usr/bin/smbpasswd  openhab -s
