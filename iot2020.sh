# /etc/network/interfaces -- configuration file for ifup(8), ifdown(8)
 
# The loopback interface
auto lo
iface lo inet loopback

# Wired interfaces
auto eth0
iface eth0 inet dhcp
# Wireless Interfaces
auto wlan0
iface wlan0 inet dhcp
wireless_mode managed
wireless_essid any
wpa-driver wext
wpa-conf /etc/wpa_supplicant.conf

auto eth1
iface eth1 inet dhcp

more /etc/wpa_supplicant.conf 
ctrl_interface=/var/run/wpa_supplicant
ap_scan=1
network={
ssid="wsa"
scan_ssid=1
proto=WPA RSN
key_mgmt=WPA-PSK
pairwise=CCMP TKIP
group=CCMP TKIP
psk="0882988966"
}


 modinfo sierra
 lsusb
 lsmod
 
 
 cd
curl -O https://download.samba.org/pub/ppp/ppp-2.4.7.tar.gz
tar -xzf ./ppp-2.4.7.tar.gz
cd ./ppp-2.4.7/
./configure
make
make install
cd
rm ./ppp-2.4.7.tar.gz
rm -r ./ppp-2.4.7/
reboot


#!/bin/sh 
case "$1" in 
    bound|renew) 
	rdate -s time.nist.gov 
	hwclock --utc --systohc 
    ;; 
esac 
exit 0 

timezone
hwclock --utc --systohc 

