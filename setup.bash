#####
##### CREATE SD CARD 
#####
ps -ef | grep systemd.daily

apt-get update

echo -n " Install GIT... "
apt-get install git

echo -n " Download openhabian.conf... "
wget -q -O /etc/openhabian.conf  https://raw.githubusercontent.com/wirelesssolution/capteur/master/openhabian.conf.dist
echo -n " Download Log file cleaning... "
wget -q -O /opt/log-file-cleaning  https://raw.githubusercontent.com/SixArm/log-file-cleaning/master/log-file-cleaning
chmod 755 /opt/log-file-cleaning
echo -n "Download mosquitto.service to support auto reconfig... "
wget -q -O /etc/avahi/services/mosquitto.service  https://raw.githubusercontent.com/wirelesssolution/capteur/master/mosquitto.service

git clone https://github.com/openhab/openhabian.git /opt/openhabian
ln -s /opt/openhabian/openhabian-setup.sh /usr/local/bin/openhabian-config
/usr/local/bin/openhabian-config unattended

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

wget -q -O /root/fstab  https://raw.githubusercontent.com/wirelesssolution/capteur/master/fstab
chmod 755 /root/fstab
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

echo -n "Install FTP server share under /opt/capteur/... "
apt-get install pure-ftpd -y
(echo ciadmin;echo ciadmin) | pure-pw useradd capteur -u openhab -g openhab -d /opt/capteur -m
pure-pw mkdb
ln -s /etc/pure-ftpd/conf/PureDB /etc/pure-ftpd/auth/60puredb
service pure-ftpd restart
apt-get remove samba -y
apt install npm -y
echo "User command to check IR gateway miio discover"
npm install -g miio

apt-get install avahi-utils -y



/etc/init.d/avahi-daemon restart


wget https://raw.githubusercontent.com/Angristan/nginx-autoinstall/master/nginx-autoinstall.sh
chmod +x nginx-autoinstall.sh
./nginx-autoinstall.sh

sleep 10
clear
echo "SD CARD READY !!!!"
echo "RUN /root/install.sh flash to Controller Box"
echo " "
echo " "


tail -F /var/log/openhab2/openhab.log /var/log/openhab2/events.log



