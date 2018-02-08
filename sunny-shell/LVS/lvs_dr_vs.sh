#!/bin/bash
#
#******************************************************************************
#Author:               Sunny
#Email:                ghbsunny@sina.com
#Date:                 2017-10-24
#FileName:             lvs_dr_vs.sh
#version:              1.0
#Your change info:      
#Description:          For auto set VS_dr
#DOC URL:              http://ghbsunny.blog.51cto.com/7759574/1975813 
#Copyright(C):         2017  All rihts reserved
#*****************************************************************************
vip='10.10.10.10'
iface='eth0:1'
mask='255.255.255.0'
port='80'
rs1='192.168.32.63'
rs2='192.168.32.73'
scheduler='wrr'
type='-g'
rpm -q ipvsadm &> /dev/null || yum -y install ipvsadm &> /dev/null

case $1 in
start)
    ifconfig $iface $vip netmask $mask broadcast $vip up
    iptables -F
 
    ipvsadm -A -t ${vip}:${port} -s $scheduler
    ipvsadm -a -t ${vip}:${port} -r ${rs1} $type -w 3
    ipvsadm -a -t ${vip}:${port} -r ${rs2} $type -w 1
    echo "The VS Server is Ready!"
    ;;  
stop)
    ipvsadm -C
    ifconfig $iface down
    echo "The VS Server is Canceled!"
    ;;  
*)
    echo "Usage: $(basename $0) start|stop"
    exit 1
    ;;  
esac

