#!/bin/bash
#
#******************************************************************************
#Author:               Sunny
#Email:                ghbsunny@sina.com
#Date:                 2017-10-24
#FileName:             lvs_dr_rs.sh
#version:              1.0
#Your change info:      
#Description:          For auto set RS_dr
#DOC URL:              http://ghbsunny.blog.51cto.com/7759574/1975813 
#Copyright(C):         2017  All rights reserved
#*****************************************************************************
vip=172.18.50.80
vip2=172.18.50.90
mask='255.255.255.255'
dev=lo:1
dev2=lo:2
rpm -q httpd &> /dev/null || yum -y install httpd &>/dev/null
service httpd start &> /dev/null && echo "The httpd Server is Ready!"
echo "<h1>`hostname`</h1>" > /var/www/html/index.html

case $1 in
start)
    echo 1 > /proc/sys/net/ipv4/conf/all/arp_ignore
    echo 1 > /proc/sys/net/ipv4/conf/lo/arp_ignore
    echo 2 > /proc/sys/net/ipv4/conf/all/arp_announce
    echo 2 > /proc/sys/net/ipv4/conf/lo/arp_announce
    ifconfig $dev $vip netmask $mask broadcast $vip up
    ifconfig $dev2 $vip2 netmask $mask broadcast $vip up
    #route add -host $vip dev $dev
    echo "The RS Server is Ready!"
    ;;  
stop)
    ifconfig $dev down
    ifconfig $dev2 down
    echo 0 > /proc/sys/net/ipv4/conf/all/arp_ignore
    echo 0 > /proc/sys/net/ipv4/conf/lo/arp_ignore
    echo 0 > /proc/sys/net/ipv4/conf/all/arp_announce
    echo 0 > /proc/sys/net/ipv4/conf/lo/arp_announce
    echo "The RS Server is Canceled!"
    ;;  
*) 
    echo "Usage: $(basename $0) start|stop"
    exit 1
    ;;  
esac

