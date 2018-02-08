#!/bin/bash
#
#******************************************************************************
#Author:               Sunny
#Email:                ghbsunny@sina.com
#Date:                 2017-09-27
#FileName:             install_pxe_env.sh
#version:              1.0
#Your change info:      
#Description:          For install PXE_environment auto
#DOC URL:              http://ghbsunny.blog.51cto.com/7759574/1969753 
#Copyright(C):         2017  All rihts reserved
#*****************************************************************************

restart_dhcpd() { 
service dhcpd restart &>/dev/null;
chkconfig dhcpd on &>/dev/null;
}
restart_tftp () {
sed -i 's/disable.*/disble = no/g' /etc/xinetd.d/tftp &>/dev/null;
chkconfig tftp on &>/dev/null;
service xinetd restart &>/dev/null;
}
restart_httpd(){
service httpd restart &>/dev/null;
chkconfig httpd on &>/dev/null;
}

min_time () {
    time=`date +%Y%m%d%H%M`
}
ip=$(ifconfig  | awk '/inet /{print $2}'| awk -F : '{print $NF}'| head -1)
min_time;

#install server
echo "Now install dhcp,http,tftp server and tftp client,it might take few minites"
rpm -q httpd &>/dev/null && restart_httpd || { yum -y install httpd &>/dev/null;restart_httpd; }
rpm -q dhcp &>/dev/null && restart_dhcpd ||  { yum -y install dhcp&>/dev/null;restart_dhcpd; }
rpm -q tftp-server &>/dev/null && restart_tftp  || { yum -y install tftp-server &>/dev/null;restart_tftp; }
rpm -q tftp &>/dev/null || yum -y install tftp &>/dev/null;
#For centos 6.9,file pxelinux.0 comes from packges syslinux-nonlinux,other version is from syslinux,but if you install packge syslinux,it will also install syslinux-nonlinux packge,so just install syslinux packge is OK to get file syslinux-nonlinux.
rpm -q syslinux &>/dev/null || yum -y install syslinux &>/dev/null;

#set http for yum server
#mount yum source
echo "Now you need to config  yum server in http server"
echo "Since I do not know which different disc your disc will be displayed,such as,centos7 display as /dev/sr0,or display as/dev/sr1 or other device "
echo "This time,I have three disks,6i386 means 386 arch for ceentos6.5,6x86_64 means 64bit for centos6.9,7 means centos7.3"
echo "the relation of my disk  dislay in the centos as below"
echo -e "/dev/sr0 ---> 6x86_64 \n/dev/sr1 ---> 6i386 \n/dev/sr2 ---> 7"
mkdir -p /var/www/html/os/{6i386,6x86_64,7}
read -p "Would you want to mount disk auto:(eg:y/n): " automount
case $automount in
y)
echo -e "/dev/sr0 ---> 6x86_64 \n/dev/sr1 ---> 6i386 \n/dev/sr2 ---> 7"
mount /dev/sr0   /var/www/html/os/6x86_64
mount /dev/sr1   /var/www/html/os/6i386
mount /dev/sr2   /var/www/html/os/7
;;
*)
echo "Since your answer is no or other,please mount disk after the script end"
echo "eg: run    mount /dev/sr0   /var/www/html/os/6x86_64  "
echo "eg: if your want to mount the disk fixed,please write to /etc/fstab,eg: /dev/sr0        /var/www/html/os/6x86_64      iso9660    defaults        0 0 "
;;
esac

#prepare ks file in /var/www/html/ksdir
echo "If your have put ks file in other hosts,your should input remote ,and input the remote file full path,and it will use scp cmd to copy the ks file directory to /var/www/html/ksdir"
echo "If you put dir in local host,input local,it will will cp cmd to  copy the ks file directory to /var/www/html/ksdir"
echo "if you input any other,you should cp ksdir to /var/www/html/ksdir"
read -p "Do you want to copy remote ks dir( r (remote) or l (local) or any other input ): " ifcopy
mkdir -p /var/www/html/ksdir/
case $ifcopy in 
r|remote)
read -p "input the remote ksdir directory(defaults:root@172.18.50.75:/var/www/html/ksdir/*): " ksdir 
if [ -z ${ksdir:-} ];then
ksdir="root@172.18.50.75:/var/www/html/ksdir/*"
fi
read -p "input host user's password you have put: " passwd
    expect -c "
    spawn  scp  $ksdir /var/www/html/ksdir/
    expect {
           \"*assword\" {set timeout 300; send \"$passwd\r\"; }
           \"yes/no\" { send \"yes\r\"; exp_continue; }
    }
    expect eof"
	
	ls /var/www/html/ksdir | while read ksfile; do
	sed -i "s@url --url=\"http://.*/os/@url --url=\"http://$ip/os/@g"  /var/www/html/ksdir/$ksfile
	done

;;
l|local )
read -p "Please input your local ks directory(eg:/root/ksdir/*): " ksdir
cp $ksdir /var/www/html/ksdir/
;;
*)
echo "your input is wrong,please manual copy ksdir to /var/www/html/ksdir/"
;;
esac

#config dhcp
echo "Now config dhcp server..."
read -p "Input your next-server ip(default is your host ip): " nextip
if [ -z ${nextip:-} ];then
nextip="$ip"
fi
echo nextip is "$nextip"
mv /etc/dhcp/dhcpd.conf /etc/dhcp/dhcpd.conf."$time".bak
cat >/etc/dhcp/dhcpd.conf<<eof
option domain-name "sunny.com";
option domain-name-servers 192.168.32.61;
default-lease-time 86400;
max-lease-time 86400;
subnet 192.168.32.0 netmask 255.255.255.0 {
range 192.168.32.100 192.168.32.200;
option routers 192.168.32.1;
next-server $nextip;
filename "pxelinux.0";
}
log-facility local7;
eof

echo "As default,the dhcp server will alocate ip 192.168.32.100--192.168.32.200,dns server is 192.168.32.61,router is 192.168.32.1,if you want to change these config ,please run 'vim /etc/dhcp/dhcpd.conf' to change /etc/dhcp/dhcpd.conf"

echo "dhcp is complete config now"

#config tltp 
echo "If you want to copy linux kernel file to /var/lib/tftpboot/{6i386,6x86_64,7}"
read -p "Please input m(means manual) or a (means auto): " copyfile
case $copyfile in
a)
mkdir -p /var/lib/tftpboot/{6i386,6x86_64,7}
cp /var/www/html/os/6i386/isolinux/{initrd.img,vmlinuz} /var/lib/tftpboot/6i386
cp /var/www/html/os/6x86_64/isolinux/{initrd.img,vmlinuz} /var/lib/tftpboot/6x86_64
cp /var/www/html/os/7/isolinux/{initrd.img,vmlinuz}   /var/lib/tftpboot/7
;;
*)
echo "Your input is m or other things"
echo "you should do two things after the scripts"
echo "create directory under /var/lib/tftpboot/,such as mkdir /var/lib/tftpboot/6i386"
echo "copy the kernel file to the relative dir,such as cp /var/www/html/os/6i386/isolinux/{initrd.img,vmlinuz} /var/lib/tftpboot/6i386"
echo "If you have many other yum source,please create relative dir under /var/lib/tftpboot/6i386"
;;
esac

cp /usr/share/syslinux/{pxelinux.0,menu.c32} /var/lib/tftpboot/

echo "Now config defaults file ,you can copy the host relative disk file ,/media/isolinux/isolinux.cfg to /var/lib/tftpboot/pxelinux.cfg,and rename it to defaults,and the modify the config,run cmd 'cp /media/isolinux/isolinux.cfg /var/lib/tftpboot/    pxelinux.cfg/default' "
echo "Now I will config /var/lib/tftpboot/pxelinux.cfg/default"
mkdir  /var/lib/tftpboot/pxelinux.cfg
cat > /var/lib/tftpboot/pxelinux.cfg/default<<eof

default menu.c32
#prompt 1
timeout 80

display boot.msg

menu background splash.jpg
menu title Welcome to Sunny diy install Linux!
menu color border 0 #ffffffff #00000000
menu color sel 7 #ffffffff #ff000000
menu color title 0 #ffffffff #00000000
menu color tabmsg 0 #ffffffff #00000000
menu color unsel 0 #ffffffff #00000000
menu color hotsel 0 #ff000000 #ffffffff
menu color hotkey 7 #ffffffff #ff000000
menu color scrollbar 0 #ffffffff #00000000

label desktop73
  menu label Install diy ^desktop centos 7
  menu default
  kernel 7/vmlinuz
  append initrd=7/initrd.img ks=http://$ip/ksdir/ks73desk.cfg
label mini73
  menu label Install diy ^mini centos 7
  menu default
  kernel 7/vmlinuz
  append initrd=7/initrd.img ks=http://$ip/ksdir/ks73min.cfg
label desktop6.5
  menu label Installed d^esktop centos 6.5 i386
  kernel 6i386/vmlinuz
  append initrd=6i386/initrd.img ks=http://$ip/ksdir/ks65desk.cfg
label mini6.5
  menu label Install m^ini centos 6.5 i386 
  kernel 6i386/vmlinuz
  append initrd=6i386/initrd.img ks=http://$ip/ksdir/ks65min.cfg
label desktop6.9
  menu label Installed de^sktop centos 6.9 
  kernel 6x86_64/vmlinuz
  append initrd=6x86_64/initrd.img ks=http://$ip/ksdir/ks69desk.cfg
label mini6.9
  menu label Install mi^ni centos 6.9 
  kernel 6x86_64/vmlinuz
  append initrd=6x86_64/initrd.img ks=http://$ip/ksdir/ks69min.cfg
eof

echo "tftp is config OK"

#restart server
echo "now restart server"

restart_httpd;
restart_tftp;
restart_dhcpd;

netstat -ntulp | grep dhcpd | grep :67 &>/dev/null && echo "dhcp is running..." || echo "dhcp is not run,please check"
netstat -ntulp | grep httpd | grep :80 &>/dev/null && echo "http is running..." || echo "http is not run,please check"
netstat -ntulp | grep xinetd | grep 69 &>/dev/null && echo "tftp is running..." || echo "tftp is not run,please check"






