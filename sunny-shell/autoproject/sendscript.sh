#!/bin/bash
#
#******************************************************************************
#Author:               Sunny
#Date:                 2017-08-30
#FileName:             sendscript.sh
#version:              1.0
#Your change info:     
#Description:          For sending script to other host by manual
#Copyright(C):         2017  All rihts reserved
#*****************************************************************************
net="192.168.32"
scriptpath=/root/script
dstpath=/root/autoscript/

echo "Usage:$0 is used to send script which you want to send"
read -p "Please input script name you want to send under dir autoscript: " script

if [ -z "$script" ];then
    echo "Your input is nothing,please re-input"
	      exit 6
  elif [ -e "$scriptpath"/"$script" ];then
    echo "The $script is exist,it will be sent"
   else 
   		echo "$script does not exit,please check"
        exit 8
fi

for ip in 61 62 71 72 73;do

  if ping -c 1 -W 1  $net.$ip &>/dev/null;then
  
	expect -c "
	spawn scp  $scriptpath/$script  root@$net.$ip:$dstpath
	expect {
	\"*assword\" {set timeout 300; send \"Pass123456\r\"; }
	\"yes/no\" { send \"yes\r\"; exp_continue; }
	}
	expect efo"&>/dev/null
   		if [ $? -eq 0 ];then
			echo "$script had been send to $net.$ip:$dstpath"
		else 
			echo "$script did not send to $net.$ip:$dstpath,please check"
		fi
  else 
     echo "$net.$ip is down,please check"
	 echo "skip the host,task continue"
	 continue
  fi

echo "Congratulation!"

done

unset net
unset scriptpath
unset dstpath
unset script

exit
