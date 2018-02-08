#!/bin/bash
#
#******************************************************************************
#Author:               Sunny
#Email:                ghbsunny@sina.com
#Date:                 2017-09-07
#FileName:             install_nfs.sh
#version:              1.0
#Your change info:     
#Description:          For auto install nfs
#Copyright(C):         2017  All rihts reserved
#*****************************************************************************
read -p  "Please input your choice,server or client: " choice
read -p "if it is server,input full path dir as serverfile (eg:/sharedisk2): " serverfile
read -p "if it is server,input path you want to  mount  serverfile(eg:/dev/sdb1: ): " mpoint

case $choice in

server)
	[ -e $serverfile ] && echo $serverfile is exist || mkdir $serverfile
	rpm -q nfs-utils &>/dev/null || yum -y install nfs-utils &>/dev/null;
	rpm -q rpcbind &>/dev/null || yum -y install rpcbind &>/dev/null;
	{ service rpcbind restart;rpcinfo -p |grep portmapper; }&>/dev/null || echo rpcbind does not start
	{ service nfs restart;rpcinfo -p |grep nfs; }&>/dev/null || echo nfs does not start

	echo "$serverfile 192.168.32.0/24(rw,no_root_squash,sync)">>/etc/exports
	echo "$serverfile 172.18.0.0/16(rw,no_root_squash,sync)">>/etc/exports
    exportfs -r
	if  $(grep "$serverfile"  /etc/fstab&>/dev/null) ;then
	echo "$serverfile already in /etc/fstab,please if you really want to mount $serverfile on $mpoint"
	elif  $(grep "$mpoint"  /etc/fstab&>/dev/null) ;then
	echo "$mpoint already in /etc/fstab,please if you really want to mount $serverfile on $mpoint"
	else
	echo " $mpoint            $serverfile              ext4      defaults      0 0">>/etc/fstab
	mount -a
	fi
	showmount  -e &>/dev/null && echo "nfs server start ok,you can check in client"|| echo "nfs start fail,please check" 
;;
client)

 rpm -q nfs-utils &>/dev/null || yum -y install nfs-utils &>/dev/null;
 showmount -e 192.168.32.61
;;

esac

unset choice
unset serverfile
unset mpoint

exit
