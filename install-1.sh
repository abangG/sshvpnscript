#!/bin/bash
myip=`ifconfig | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0' | head -n1`;
myint=`ifconfig | grep -B1 "inet addr:$myip" | head -n1 | awk '{print $1}'`;
curl -s -o ip.txt https://raw.githubusercontent.com/abangG/sshvpnscript/master/script/ip.txt
find=`grep $myip ip.txt`
if [ "$find" = "" ]
then
clear
echo "
      System Menu By MKSSHVPN
[ YOUR IP NOT REGISTER ON MY SCRIPT ]
         RM 20 PER IP/VPS
----==== CONTACT FOR REGISTER ====----
[ SMS/Telegram : 0162771064 / @mk_let ]
"
rm *.txt
rm *.sh
exit
fi
if [ $USER != 'root' ]; then
	echo "Sorry, for run the script please using root user"
	exit
fi
echo "
== MKSSHVPN SYSTEM SCRIPT ==
PLEASE CANCEL ALL PACKAGE POPUP
TAKE NOTE !!!"
clear
echo "START AUTOSCRIPT"
clear
echo "SET TIMEZONE KUALA LUMPUT GMT +8"
ln -fs /usr/share/zoneinfo/Asia/Kuala_Lumpur /etc/localtime;
clear
echo "
CHECK AND INSTALL IT
COMPLETE 1%
"
apt-get -y install wget curl
clear
echo "
INSTALL COMMANDS
COMPLETE 15%
"
apt-get -y wget
apt-get -y install sudo
clear
echo "
UPDATE AND UPGRADE PROCESS 
PLEASE WAIT..... 
COMPLETE 25%
"
apt-get update;apt-get -y upgrade
echo "
INSTALL IN BEGINS
PLEASE WAIT THIS MAY TAKE A FEW MINUTES
COMPLETE 30%
"
# user-list
wget https://raw.githubusercontent.com/abangG/sshvpnscript/master/script/user-list
mv user-list /usr/local/bin/
chmod +x  /usr/local/bin/user-list

#menu
wget https://raw.githubusercontent.com/abangG/sshvpnscript/master/script/menu
mv menu /usr/local/bin/
chmod +x  /usr/local/bin/menu


#status
wget https://raw.githubusercontent.com/abangG/sshvpnscript/master/script/status
mv status /usr/local/bin/
chmod +x  /usr/local/bin/status


#monssh
wget https://raw.githubusercontent.com/abangG/sshvpnscript/master/script/monssh
mv monssh /usr/local/bin/
chmod +x  /usr/local/bin/monssh

clear
echo "
INSTALL OPENVPN AND KEYS
COMPLETE 45%
"
#needed by openvpn-nl
apt-get -y install apt-transport-https
#adding source list
echo "deb https://openvpn.fox-it.com/repos/deb wheezy main" > /etc/apt/sources.list.d/foxit.list
apt-get update
wget https://openvpn.fox-it.com/repos/fox-crypto-gpg.asc
apt-key add fox-crypto-gpg.asc
apt-get update
cd /root
#installing normal openvpn, easy rsa & openvpn-nl
apt-get install easy-rsa -y
apt-get install openvpn -y
apt-get install openvpn-nl -y
#ipforward
sysctl -w net.ipv4.ip_forward=1
sed -i 's/#net.ipv4.ip_forward=1/net.ipv4.ip_forward=1/g' /etc/sysctl.conf
iptables -F
iptables -t nat -F
iptables -t nat -A POSTROUTING -s 10.8.0.0/16 -o eth0 -j MASQUERADE
iptables -t nat -A POSTROUTING -s 172.16.0.0/16 -o eth0 -j MASQUERADE
iptables -t nat -A POSTROUTING -s 172.1.0.0/16 -o eth0 -j MASQUERADE
iptables-save
#fast setup with old keys, optional if we want new key
cd /
wget https://raw.githubusercontent.com/abangG/sshvpnscript/master/script/ovpn.tar
tar -xvf ovpn.tar
rm ovpn.tar
service openvpn-nl restart
openvpn-nl --remote CLIENT_IP --dev tun0 --ifconfig 10.9.8.1 10.9.8.2
#get ip address
apt-get -y install aptitude curl

if [ "$IP" = "" ]; then
        IP=$(curl -s ifconfig.me)
fi
#installing squid3
aptitude -y install squid3
rm -f /etc/squid3/squid.conf
#restoring squid config with open port proxy 3128, 7166, 8080
wget -P /etc/squid3/ "https://raw.githubusercontent.com/abangG/sshvpnscript/master/script/squid.conf"
sed -i "s/ipserver/$IP/g" /etc/squid3/squid.conf
service squid3 restart
cd

#install vnstat
apt-get -y install vnstat
vnstat -u -i eth0
sudo chown -R vnstat:vnstat /var/lib/vnstat
service vnstat restart

clear
echo "
INSTALL DROPBEAR, WEBMIN 
COMPLETE 75%
"
#install dropbear
apt-get -y install dropbear
sed -i 's/NO_START=1/NO_START=0/g' /etc/default/dropbear
sed -i 's/DROPBEAR_PORT=22/DROPBEAR_PORT=443/g' /etc/default/dropbear
sed -i 's/DROPBEAR_EXTRA_ARGS=/DROPBEAR_EXTRA_ARGS="-p 109 -p 110"/g' /etc/default/dropbear
echo "/bin/false" » /etc/shells
service ssh restart
service dropbear restart

#installing webmin
wget http://www.webmin.com/jcameron-key.asc
apt-key add jcameron-key.asc
echo "deb http://download.webmin.com/download/repository sarge contrib" >> /etc/apt/sources.list
echo "deb http://webmin.mirror.somersettechsolutions.co.uk/repository sarge contrib" >> /etc/apt/sources.list
apt-get update
apt-get -y install webmin
#disable webmin https
sed -i "s/ssl=1/ssl=0/g" /etc/webmin/miniserv.conf
/etc/init.d/webmin restart
service openvpn-nl restart
service squid3 restart
cd

#swap ram
wget https://raw.githubusercontent.com/abangG/sshvpnscript/master/script/swap-ram.sh
chmod +x  swap-ram.sh
./swap-ram.sh

clear

echo "
BLOCK TORRENT PORT INSTALL
COMPLETE 95%
"
#bonus block torrent
wget https://raw.githubusercontent.com/abangG/sshvpnscript/master/script/torrent.sh
chmod +x  torrent.sh
./torrent.sh

clear
echo "
COMPLET 100%
DONE.
"
echo "========================================"  | tee -a log-install.txt
echo "MKSSHVPN"  | tee -a log-install.txt
echo "----------------------------------------"  | tee -a log-install.txt
echo ""  | tee -a log-install.txt
echo "Webmin : http://$myip:10000/"  | tee -a log-install.txt
echo "Squid3 : 7166,8080"  | tee -a log-install.txt
echo "Dropbear : 443"  | tee -a log-install.txt
echo "Timezone : Asia/Kuala_Lumpur"  | tee -a log-install.txt
echo "Script command : menu"  | tee -a log-install.txt
echo "========================================"  | tee -a log-install.txt
echo "      PLEASE REBOOT TAKE EFFECT !"
echo "========================================"  | tee -a log-install.txt
cat /dev/null > ~/.bash_history && history -c
rm install-1.sh
