ps -ef | grep systemd.daily

apt-get update

echo -n "$(timestamp) Install GIT... "
apt-get install git

echo -n "$(timestamp) Download openhabian.conf... "
wget -q -O /etc/openhabian.conf  https://raw.githubusercontent.com/wirelesssolution/capteur/master/openhabian.conf.dist
echo -n "$(timestamp) Download mosquitto.service to support auto reconfig... "
wget -q -O /etc/avahi/services/mosquitto.service  https://raw.githubusercontent.com/wirelesssolution/capteur/master/mosquitto.service

git clone https://github.com/openhab/openhabian.git /opt/openhabian
ln -s /opt/openhabian/openhabian-setup.sh /usr/local/bin/openhabian-config
/usr/local/bin/openhabian-config unattended

echo -n "$(timestamp) Download Cron.sh  under /opt/capteur/cron.sh/ and install cron config at /etc/cron.d ... "
wget -q -O /etc/cron.d/capteur_cron  https://raw.githubusercontent.com/wirelesssolution/capteur/master/cron.d/capteur
wget -q -O /srv/cron.sh  https://raw.githubusercontent.com/wirelesssolution/capteur/master/scripts/cron.sh
sudo /bin/chmod 755 /opt/capteur/cron.sh
cronjob="*/1 * * * * /opt/capteur/cron.sh  >/dev/null 2>&1"
(crontab -u root -l; echo "$cronjob" ) | crontab -u root -



echo -n "$(timestamp) Install MQTT SERVER... "
apt -y --no-install-recommends install mosquitto mosquitto-clients
touch /etc/mosquitto/passwd
mosquitto_passwd -b /etc/mosquitto/passwd mymqtt mymqtt


echo -n "$(timestamp) Preparing Capteur folder mounts under /opt/capteur/... "
sed -i "\#[ \t]/srv/openhab2-#d" /etc/fstab
sed -i "\#[ \t]/opt/capteur/capteur-#d" /etc/fstab
sed -i "\#^$#d" /etc/fstab
  (
    echo ""
    echo "/var/lib/openhab2            /opt/capteur/capteur-userdata      none bind 0 0"
    echo "/etc/openhab2                /opt/capteur/capteur-conf          none bind 0 0"
    echo "/var/log/openhab2            /opt/capteur/capteur-logs          none bind 0 0"
  ) >> /etc/fstab
cat /etc/fstab
mkdir -p /opt/capteur/capteur-{conf,userdata,logs}
mount --all --verbose

  


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
 
#echo "add Samba User "
#(echo ciadmin;echo ciadmin) | sudo /usr/bin/smbpasswd  -s -a openhab
#wget -q -O /etc/samba/smb.conf https://raw.githubusercontent.com/wirelesssolution/capteur/master/smb.conf
#/etc/init.d/samba restart

echo -n "$(timestamp) Install FTP server share under /opt/capteur/... "
apt-get install pure-ftpd -y
(echo ciadmin;echo ciadmin) | pure-pw useradd capteur -u openhab -g openhab -d /opt/capteur -m
pure-pw mkdb
ln -s /etc/pure-ftpd/conf/PureDB /etc/pure-ftpd/auth/60puredb
service pure-ftpd restart
apt-get remove samba -y
apt-get install avahi-utils

npm install -g miio
echo "User command to check IR gateway miio discover"

sleep 10
clear
tail -F /var/log/openhab2/openhab.log /var/log/openhab2/events.log



