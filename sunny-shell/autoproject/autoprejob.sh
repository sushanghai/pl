#!/bin/bash
#
#******************************************************************************
#Author:               Sunny
#Email:                ghbsunny@sina.com
#Date:                 2017-08-30
#FileName:             mkdirtory.sh
#version:              1.0
#Your change info:     
#Description:          For
#Copyright(C):         2017  All rihts reserved
#*****************************************************************************
dir=/root/autoscript
bakdir=/root/autoscript.bak
scriptpath=/sharedisk/script/autoscript
cliscriptpath=/nfsfile/share/script/autoproject
send=autosend.sh
run=autorun.sh
serverip=192.168.32.61

echo "Usage:$0 will make dir which need ,send auto script to assign dir,make script run schedule by set /etc/crontab"
echo "If You set server,please run $0 in 192.168.32.61"
echo "If you set client,you can choose host by yourself"

main(){
    [ -e "$dir" ] && echo "$dir exist" || { mkdir $dir;echo "$dir is created"; }
	[ -e "$bakdir" ] && echo "$bakdir exist" || { mkdir $bakdir;echo "$bakdir is created"; }
	grep autorun /etc/crontab &>/dev/null || echo "*/3 * * * * root /root/autoscript.bak/autorun.sh">>/etc/crontab
}

read -p "Please input server or client: " host

case $host in
server)
     ifconfig | grep $serverip &>/dev/null
	 if [ $? -eq 0 ]; then
     main
    [ -e   $bakdir/$send ] || cp $scriptpath/$send  $bakdir
    [ -e  $bakdir/$run ] || cp $scriptpath/$run  $bakdir
    grep autosend /etc/crontab &>/dev/null || echo "*/2 * * * * root /root/autoscript.bak/autosend.sh">>/etc/crontab
	else
	   echo "The host is not server,please check"
	fi
    ;;
client)
    main
    [ -e  $bakdir/$run ] || cp $cliscriptpath/$run  $bakdir
	;;
esac

unset dir
unset bakdir
unset scriptpath
unset cliscriptpath
unset send
unset run
unset serverip
exit
