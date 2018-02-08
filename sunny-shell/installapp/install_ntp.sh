#!/bin/bash
#
#******************************************************************************
#Author:               Sunny
#Email:                ghbsunny@sina.com
#Date:                 2017-09-08
#FileName:             install_ntp.sh
#version:              1.0
#Your change info:     
#Description:          For install ntp by  auto
#Copyright(C):         2017  All rihts reserved
#*****************************************************************************


is_bakfile(){

[ -e /root/bakfile ] || mkdir /root/bakfile

}

min_time () {
    time=`date +%Y%m%d%H%M`
}
is_bakfile
min_time

[ -e /etc/ntp.conf ] &&mv /etc/ntp.conf /root/bakfile/ntp.conf."$time".bak

read -p "Please input your choice,server or client: " choice

if ! $(date | grep CST &>/dev/null);then

[ -e /etc/localtime ]&& mv /etc/localtime /root/bakfile/localtime."$time".bak

 ln -s /usr/share/zoneinfo/Asia/Shanghai  /etc/localtime
 fi


case $choice in

server)

echo "#################################################################################################"
   echo "if your server is virtual host,suggest you will use its own time to  synchronization host time."
   echo "you should also install vmware tools in the server host in order  use phisical  host  time to syn your virtual time,you need to start time ntp option in vmware"
   echo "If your want to user common time from internet  to syn server host time,you  should make sure your host can access to the common time server from internet.You just replace server ip which line in line "server 127.127.0.1" "
   echo "start to config ntp server"
echo "###################################################################################################"
echo
echo
   rpm -q ntp &>/dev/null || yum -y install ntp &>/dev/null

   cat >>/etc/ntp.conf<<eof

driftfile /var/lib/ntp/drift

restrict 192.168.32.0 mask 255.255.255.0 nomodify 

restrict 172.18.0.0  mask 255.255.0.0  nomodify

restrict 127.0.0.1

restrict -6 ::1

server 127.127.1.0

fudge 127.127.1.0 stratum 10

includefile /etc/ntp/crypto/pw

keys /etc/ntp/keys

eof

service ntpd restart&>/dev/null || echo "Something wrong when restart ntp service"

netstat -ntlup | grep ntpd &>/dev/null && echo "ntpd is running " || echo "Something wrong happened when start ntp,please check"
chkconfig ntpd on

echo "now it use cmd "ntpq -p",if you see st is what you set in  stratum and less than 16,ntp server is now now ,but it need few minutes to work normal."

ntpq  -p 

echo "hint: to syn client host time after 3 minites"

;;

client)

netstat -ntlup | grep ntpd &>/dev/null && service ntpd stop&>/dev/null
read -p "Please input which server to syn(default:192.168.32.61): " ip
if [ -z "${ip:-}" ];then
ip=192.168.32.61
fi

ntpdate $ip

#set auto syn schedule

grep ntpdate /etc/crontab &>/dev/null && echo "already set auto ntp schdule,please check" || echo "* * * * * root /usr/sbin/ntpdate 192.168.32.61;/sbin/hwclock -w">>/etc/crontab

;;

*)
  echo "Your choice is wrong,please check"
;;

esac

unset ip
unset time


exit


