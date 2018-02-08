#!/bin/bash
date
yum remove -y ntp &> /dev/null
rm -rf /etc/ntp* &> /dev/null
yum install ntp -y &> /dev/null
cp /etc/ntp.conf /etc/ntp.conf.bak
SERVERIP=192.168.70.151
sed -i "s/^server 0.centos.pool.ntp.org iburst/#server 0.centos.pool.ntp.org iburst/g" /etc/ntp.conf
sed -i "s/^server 1.centos.pool.ntp.org iburst/#server 1.centos.pool.ntp.org iburst/g" /etc/ntp.conf
sed -i "s/^server 2.centos.pool.ntp.org iburst/#server 2.centos.pool.ntp.org iburst/g" /etc/ntp.conf
sed -i "s/^server 3.centos.pool.ntp.org iburst/#server 3.centos.pool.ntp.org iburst/g" /etc/ntp.conf
echo "server $SERVERIP iburst" >> /etc/ntp.conf
service ntpd start
ss -tunlp | grep "123" &> /dev/null
RESULT=`echo $?` &> /dev/null
if [ $RESULT -eq 0 ] ;then
echo "ntpd服务已启动."
chkconfig ntpd on
else
echo "ntpd服务启动失败,请检查配置!"
fi
sleep 2
SYNC=`ntpstat |grep -o 'synchronised'`

if [ $SYNC = 'synchronised' ];then
echo "已同步到时间服务器$SERVERIP"
else
echo "同步时间服务器失败，请检查配置！"
fi
sleep 5
chkconfig ntpd on
date
hwclock -w
sleep 9
ntpq -p -n
