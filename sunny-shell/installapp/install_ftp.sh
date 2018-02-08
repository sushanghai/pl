#!/bin/bash
#
#******************************************************************************
#Author:               Sunny
#Email:                ghbsunny@sina.com
#Date:                 2017-09-11
#FileName:             install_ftp.sh
#version:              1.0
#Your change info:     
#Description:          For auto install ftp
#Copyright(C):         2017  All rihts reserved
#*****************************************************************************
#ftp service dir is relative to system dir attribute.for example,if you are use anonmous to login ftp,if you upload some file to ftp,it use defaults user ftp to upload new file,and the new file permisson is 600,so other people could not download the file unless you change the file attribute about  other with r permission
time=`date +%Y%m%d%H%M`

#the function is used to install vsftpd  generate a new config file and create chroot_list and welcome.txt  file
#install ftp server
rpm -q  vsftpd &>/dev/null || yum -y install vsftpd &>/dev/null;
#install ftp  client,not necessary,but suggest
rpm -q ftp &>/dev/null || yum -y install ftp &>/dev/null;

[ -e /etc/vsftpd/vsftpd.conf ] && mv /etc/vsftpd/vsftpd.conf /etc/vsftpd/vsftpd.conf."$time".bak
[ -e /etc/vsftpd/welcome.txt ] && mv  /etc/vsftpd/welcome.txt  /etc/vsftpd/welcome.txt."$time".bak
cat >>/etc/vsftpd/vsftpd.conf<<eof

#should not listen both ipv4 and ipv6 port.suggest just only listen ipv4,so listen_ipv6 does not need to config.
#about anonymous

anonymous_enable=YES
anon_mkdir_write_enable=YES
anon_other_write_enable=YES
anon_upload_enable=YES

#about entity user

local_enable=YES
write_enable=YES
local_umask=022
userlist_enable=YES
userlist_deny=YES
userlist_file=/etc/vsftpd/user_list
chroot_local_user=YES
chroot_list_enable=YES
chroot_list_file=/etc/vsftpd/chroot_list


#about server env

dirmessage_enable=YES
xferlog_enable=YES
connect_from_port_20=YES
xferlog_std_format=YES
listen=YES
pam_service_name=vsftpd
tcp_wrappers=YES
use_localtime=yes



#/etc/vsftpd/welcom.txt  need be created by manual
banner_file=/etc/vsftpd/welcome.txt

eof

[ -e /etc/vsftpd/chroot_list ] || touch /etc/vsftpd/chroot_list

cat >>/etc/vsftpd/welcome.txt<<eof

Welcome to sunny ftp

eof


#create ftp users without login system pemission
echo "If you don't want to create user ,you can enter number 0 to skip create new ftp user"
read -p "how many ftp users would you want to create(eg:3,means create 3 users total): " usernu
[[ "$usernu" =~ ^[0-9]+$  ]] || { echo your input is no num,user does not create,please check;$usernu=0; }
if [ -z ${usernu:-} ];then
usernu=0
fi
read -p "enter passwd for all new users(default:ftp123): " pass
if [ -z ${pass:-} ];then
pass=ftp123
fi
while [ "$usernu" -gt 0 ];do
read -p "pleas input new username you want to create: " user
if $(id "$user" &>/dev/null);then
echo "$user" is already exist,$user will not be create again
continue
else
useradd -s /sbin/nologin -d /var/ftp/"$user" "$user"
echo "$pass"| passwd --stdin "$user"
echo "$user" >> /etc/vsftpd/chroot_list
let usernu--
fi
done



echo "You will create two dir under /var/ftp for project"
echo "dir share : everyone can do create,delete,upload,download files after one minute once file is upload under share"
echo "dir share_project : it  is similar to dir share,but one can delete file under it"

read -p "If you want to make two share dir,enter yes,it will not create if your enter other: " answer

if [ "$answer" = "yes" ];then

[ -e /var/ftp/share ] || mkdir /var/ftp/share
[ -e /var/ftp/share_project ] || mkdir /var/ftp/share_project


grep "/ftp/share1" /etc/crontab &>/dev/null || echo "* * * * * root chmod -R 777 /var/ftp/share">>/etc/crontab

chattr +a /var/ftp/share_project

else 

echo "no share dir was created"

fi

#both cent 6 and 7
chkconfig vsftpd on
service vsftpd restart &>/dev/null

#centOS7 can run below cmd to restart and enble service when start system as well
#systemctl restart vsftpd.service
#systemctl enable vsftpd

setenforce 0  &>/dev/null

#if you want to use selinux,your run cmd below to make ftp work normal
#getsebool -a | grep ftp
#setsebool -P tftp_home_dir=1
#setsebool -P tftp_anon_write=1
#setsebool -P ftpd_anon_write=1

netstat -netlp | grep vsftpd &>/dev/null && echo "Your ftp is working,your can use it now" || echo "Your ftp service does not start,Please check"


unset usernu
unset pass

