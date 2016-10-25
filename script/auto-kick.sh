#!/bin/bash

# go to root
cd

# download userlimit
wget https://raw.githubusercontent.com/abangG/sshvpnscript/master/script/user-limit.sh
chmod +x user-limit.sh

# setup cron for userlimit
echo "* * * * * root /root/user-limit.sh" >> /etc/crontab
echo "* * * * * root sleep 5; /root/user-limit.sh" >> /etc/crontab
echo "* * * * * root sleep 10; /root/user-limit.sh" >> /etc/crontab
echo "* * * * * root sleep 15; /root/uuser-limit.sh" >> /etc/crontab
echo "* * * * * root sleep 20; /root/user-limit.sh" >> /etc/crontab
echo "* * * * * root sleep 25; /root/user-limit.sh" >> /etc/crontab
echo "* * * * * root sleep 30; /root/user-limit.sh" >> /etc/crontab
echo "* * * * * root sleep 35; /root/user-limit.sh" >> /etc/crontab
echo "* * * * * root sleep 40; /root/user-limit.sh" >> /etc/crontab
echo "* * * * * root sleep 45; /root/user-limit.sh" >> /etc/crontab
echo "* * * * * root sleep 50; /root/user-limit.sh" >> /etc/crontab
echo "* * * * * root sleep 55; /root/user-limit.sh" >> /etc/crontab

service cron restart
