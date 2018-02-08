#!/bin/bash
#
#******************************************************************************
#Author:               Sunny
#Date:                 2017-08-30
#FileName:             sendscript.sh
#version:              1.0
#Your change info:     
#Description:          For sending script to other host by auto
#Copyright(C):         2017  All rihts reserved
#*****************************************************************************
net="192.168.32"
scriptpath=/sharedisk/script/autoscript
dstpath=/root/autoscript/
date=`date +%F-%H-%M`

cd $scriptpath
scriptnu=`ls | grep -e .sh$ | wc -l`
if [ $scriptnu -eq 0 ];then
#   echo "nothing to do"
   exit 8
else

for  script in *.sh;do

	for ip in 61 62 63 71 72 73 75;do

  	if ping -c 1 -W 1  $net.$ip &>/dev/null;then
 

expect -c "
	spawn scp  $scriptpath/$script  root@$net.$ip:$dstpath
expect {
\"*assword\" {set timeout 300; send \"Pass123456\r\"; }
\"yes/no\" { send \"yes\r\"; exp_continue; }
}
expect efo"


# expect <<EOF
#	expec -c "
#	spawn scp  $scriptpath/$script  root@$net.$ip:$dstpath
#	expect {
#	"*assword" {set timeout 300; send "Pass123456\r"; }
#	"yes/no" { send "yes\r"; exp_continue; }
#	}
#	expect efo"&>/dev/null
#EOF
   			if [ $? -eq 0 ];then
				echo "$script had been send to $net.$ip:$dstpath"
				wall "$script had been send to $net.$ip:$dstpath"
			else 
				echo "$script did not send to $net.$ip:$dstpath,please check"
				wall "$script did not send to $net.$ip:$dstpath,please check"
			fi
   	else 
     wall "$net.$ip is down,please check"
	 echo "skip the host,task continue"
	 continue
 	 fi
	done
mv $script "$script".$date.bak
done

fi

echo "Congratulation!"

unset net
unset scriptpath
unset dstpath
unset script

exit
