#!/bin/bash
#
#******************************************************************************
#Author:               Sunny
#Email:                ghbsunny@sina.com
#Date:                 2017-09-03
#FileName:             install_telnet.sh
#version:              1.0
#Your change info:     
#Description:          For
#Copyright(C):         2017  All rihts reserved
#*****************************************************************************
rpm -q xinetd &>/dev/null || yum -y install xinetd &>/dev/null
rpm -q telnet &>/dev/null || yum -y install telnet &>/dev/null
rpm -q telnet-server &>/dev/null ||  yum -y install telnet-server &>/dev/null 

iptables -I INPUT -p tcp --dport 23 -jACCEPT   
iptables -I INPUT -p udp --dport 23 -jACCEPT

os_version=`cat /etc/system-release | grep -o " [0-9]"| cut -d " " -f2`

check_telnet (){
	if	netstat -nutlp | grep ":23 " &>/dev/null;then
	echo "Telnet service is open now,the host can be telnet now"
	else 
	echo "Telnet port 23 is not open,please check"
	fi
};


case $os_version in
6)
	chkconfig xinetd on;
	chkconfig telnet on;
   	service xinetd restart;
	check_telnet;
	;;
7)
	systemctl enable telnet.socket;
	systemctl start telnet.socket;
	systemctl enable xinetd;
	systemctl restart xinetd;
	check_telnet;
	;;
*)
    echo "Please check your system version,it not 6 or 7"
	exit
	;;
esac

