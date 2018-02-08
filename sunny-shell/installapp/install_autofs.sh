#!/bin/bash
#
#******************************************************************************
#Author:               Sunny
#Email:                ghbsunny@sina.com
#Date:                 2017-09-08
#FileName:             install_autofs.sh
#version:              1.0
#Your change info:     
#Description:          For install autofs clinet by auto
#URL                   http://ghbsunny.blog.51cto.com/7759574/1957591
#Copyright(C):         2017  All rihts reserved
#*****************************************************************************
echo "This script is only use to auto install autofs and  make auto mount in client"
read -p "Please input a full path  dir you want to auto mount(default:/nfsfile): " autodir
read -p "Please creat a file in /etc you want to assign for autofs(default:auto.nfs): " autofile
read -p "Please input remote source file ip and file (default:192.168.32.61:/sharedisk): " remotesrc

rpm -q nfs-utils &>/dev/null || yum -y install nfs-utils &>/dev/null

if [ -z ${autodir:-} ];then
autodir=/nfsfile
fi

if [ -z ${autofile:-} ];then
autofile=auto.nfs
fi

if [ -z ${remotesrc:-} ];then
remotesrc=192.168.32.61:/sharedisk
fi


[ -e "$autodir" ]&>/dev/null && echo "$autodir already exist"|| mkdir "$autodir"

rpm -q autofs &>/dev/null || yum -y install autofs&>/dev/null;


#to assign a dir(in the eg is share ) which you want to access to the source dir
#attention,share is a dir,but is should not exist,the dir will exist when you access to it
if [ -e /etc/$autofile ];then
echo "$autofile is exist,please check"
exit  6;
else
cat >>/etc/$autofile<<eof
share  -rw,bg,soft,rsize=32768,wsize=32768 $remotesrc
eof

sed -r -i.bak "/^\/misc/ a $autodir   \/etc\/$autofile" /etc/auto.master

fi

service autofs restart &>/dev/null || echo "something unexpect happened,please check autofs service"

[ -e /root/bakfile ] || mkdir /root/bakfile

mv /etc/*.bak /root/bakfile

unset autodir
unset autofile
unset remotesrc

exit
